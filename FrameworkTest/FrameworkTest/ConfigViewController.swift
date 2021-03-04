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
        
        let returnValues = getMutableDictionaryFromPlist(lastSelectedApiType: self.lastSelectedApiType ?? .test)
        
        let tempDict : NSMutableDictionary? = returnValues.mutDict
            
        let plistDict = tempDict?["ConfirmPayment"] as? NSMutableDictionary
            
        if let plistDict = plistDict{
                
                plistDict["saltKeyTest"] = saltKeyTxtField.text
                
                plistDict["productIdTest"] = productIdTxtField.text
                
                plistDict["transferReferenceNumberTest"] = transferRefNumTxtField.text
                
                plistDict["terminalReferenceNumberTest"] = terminalRefNumTxtField.text
                
                plistDict["merchantReferenceNumberTest"] = merchantRefNumTxtField.text
                
                plistDict["paymentAppTokenTest"] = paymentAppTokenTxtField.text
                
                plistDict["amount"] = amountTxtField.text
                
                plistDict["requestId"] = self.requestIdTxtField.text
                
                tempDict?["ConfirmPayment"] = plistDict
        }
            
        tempDict?.write(toFile: returnValues.url.path, atomically: true)
    }
    
    
    
}
