//
//  ConfigViewController.swift
//  FrameworkTest
//
//  Created by ilker sevim on 26.01.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import UIKit
import Multipay

class ConfigViewController: UIViewController {
    
    @IBOutlet weak var requestIdTxtField: UITextField!
    @IBOutlet weak var saltKeyTxtField: UITextField!
    @IBOutlet weak var productIdTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var transferRefNumTxtField: UITextField!
    @IBOutlet weak var terminalRefNumTxtField: UITextField!
    @IBOutlet weak var merchantRefNumTxtField: UITextField!
    @IBOutlet weak var paymentAppTokenTxtField: UITextField!
    
    var lastSelectedApiType:APIType?{
        get{
            let apiType = userDefaults.object(forKey: "lastSelectedApiType") as? Int
            return APIType(rawValue: apiType ?? 3)
        }
        set{
            userDefaults.set(newValue?.rawValue, forKey: "lastSelectedApiType")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confirmPayDict = getConfirmPaymentDict(apiType: self.lastSelectedApiType!)
        
        if let dict = confirmPayDict{
            
            self.saltKeyTxtField.text = dict["saltKeyTest"] as? String
            
            self.paymentAppTokenTxtField.text = dict["paymentAppTokenTest"] as? String
            
            self.merchantRefNumTxtField.text = dict["merchantReferenceNumberTest"] as? String
            
            self.terminalRefNumTxtField.text = dict["terminalReferenceNumberTest"] as? String
            
            self.transferRefNumTxtField.text = dict["transferReferenceNumberTest"] as? String
            
            self.productIdTxtField.text = dict["productIdTest"] as? String
            
            self.amountTxtField.text = dict["amount"] as? String ?? "100TRY"
            
            self.requestIdTxtField.text = dict["requestId"] as? String
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        saveToPropertyList()
        
        self.dismiss(animated: true) {
        }
        
    }
    
    @IBAction func kapatClicked(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
        
    }
}

extension ConfigViewController{
    
    func getPlist(apiType:APIType) -> [String:AnyObject]?
    {
        
        var apiFileNameStart = ""
        
        switch apiType {
        case .dev:
            apiFileNameStart = "Dev"
            break
        case .test:
            apiFileNameStart = "Test"
            break
        case .pilot:
            apiFileNameStart = "Pilot"
            break
        case .prod:
            apiFileNameStart = "Prod"
            break
        }
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentFileURL = documentDirectoryURL.appendingPathComponent(apiFileNameStart + "-Configs.plist", isDirectory: false)
        let filemanager = FileManager.default
        
        if filemanager.fileExists(atPath: documentFileURL.path), let xml = FileManager.default.contents(atPath: documentFileURL.path) {
            
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:AnyObject]
        } else {
            if let bundlePath = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist"), filemanager.fileExists(atPath: bundlePath), let xml = FileManager.default.contents(atPath: bundlePath) {
                
                do {
                    try filemanager.copyItem(at: URL(fileURLWithPath: bundlePath), to: documentFileURL)
                } catch {
                    print(error)
                }
                
                
                return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String : AnyObject]
            }
        }
        
        return nil
    }
    
    func getConfirmPaymentDict(apiType:APIType) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(apiType: apiType){
            
            let paymentConfirmDict = plistDict["ConfirmPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        }
        else{
            return nil
        }
    }
    
    //Operation Write, update and delete plist file
    func saveToPropertyList() {
        
        let apiType:APIType = self.lastSelectedApiType!
        
        var apiFileNameStart = ""
        
        switch apiType {
        case .dev:
            apiFileNameStart = "Dev"
            break
        case .test:
            apiFileNameStart = "Test"
            break
        case .pilot:
            apiFileNameStart = "Pilot"
            break
        case .prod:
            apiFileNameStart = "Prod"
            break
        }
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentFileURL = documentDirectoryURL.appendingPathComponent(apiFileNameStart + "-Configs.plist", isDirectory: false)
        let filemanager = FileManager.default
        
        if filemanager.fileExists(atPath: documentFileURL.path) {
            let tempDict : NSMutableDictionary = NSMutableDictionary(contentsOfFile: documentFileURL.path)!
            
            let plistDict = tempDict["ConfirmPayment"] as? NSMutableDictionary
            
            if let plistDict = plistDict{
                
                plistDict["saltKeyTest"] = saltKeyTxtField.text
                
                plistDict["productIdTest"] = productIdTxtField.text
                
                plistDict["transferReferenceNumberTest"] = transferRefNumTxtField.text
                
                plistDict["terminalReferenceNumberTest"] = terminalRefNumTxtField.text
                
                plistDict["merchantReferenceNumberTest"] = merchantRefNumTxtField.text
                
                plistDict["paymentAppTokenTest"] = paymentAppTokenTxtField.text
                
                plistDict["amount"] = amountTxtField.text
                
                plistDict["requestId"] = self.requestIdTxtField.text
                
                tempDict["ConfirmPayment"] = plistDict
            }
            
            tempDict.write(toFile: documentFileURL.path, atomically: true)
        }
    }
    
}
