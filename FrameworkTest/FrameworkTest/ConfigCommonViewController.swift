//
//  ConfigCommonViewController.swift
//  FrameworkTest
//
//  Created by ilker sevim on 26.01.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import UIKit
import Multipay

class ConfigCommonViewController: UIViewController {
    
    @IBOutlet weak var authTokenTxtField: UITextField!
    @IBOutlet weak var walletTokenTxtField: UITextField!
    @IBOutlet weak var referenceNumberTxtField: UITextField!
    @IBOutlet weak var appTokenTxtField: UITextField!
    
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
        
        let tempDict = getConfirmPaymentDict(apiType: self.lastSelectedApiType!)
        
        if let dict = tempDict{
            
            self.authTokenTxtField.text = dict["authenticationToken"] as? String
            
            self.walletTokenTxtField.text = dict["walletToken"] as? String
            
            self.referenceNumberTxtField.text = dict["referenceNumber"] as? String
            
            self.appTokenTxtField.text = dict["appToken"] as? String
            
        }
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

extension ConfigCommonViewController{
    
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
        
        if  let path = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path)
        {
            print("xml: \(xml)")
            return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String:AnyObject]
        }
        
        return nil
    }
    
    func getConfirmPaymentDict(apiType:APIType) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(apiType: apiType){
            
            let paymentConfirmDict = plistDict
            
            print("common Dict: \(String(describing: paymentConfirmDict))")
            
            return paymentConfirmDict
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
        
        let paths = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist")
        let path = paths
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path!)))
        {
            do {
                let bundlePath : NSString = Bundle.main.path(forResource: apiFileNameStart + "-Configs", ofType: "plist")! as NSString
                
                try fileManager.copyItem(atPath: bundlePath as String, toPath: path!)
            }catch {
                print(error)
            }
        }
        
        let tempDict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        
        tempDict["authenticationToken"] = authTokenTxtField.text
        
        tempDict["walletToken"] = walletTokenTxtField.text
        
        tempDict["referenceNumber"] = referenceNumberTxtField.text
        
        tempDict["appToken"] = appTokenTxtField.text
        
        tempDict.write(toFile: path!, atomically: true)
    }
    
}
