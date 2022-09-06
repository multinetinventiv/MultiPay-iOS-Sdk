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
    @IBOutlet weak var productIdTxtField: UITextField!
    @IBOutlet weak var amountTxtField: UITextField!
    @IBOutlet weak var transferRefNumTxtField: UITextField!
    @IBOutlet weak var terminalRefNumTxtField: UITextField!
    @IBOutlet weak var merchantRefNumTxtField: UITextField!
    @IBOutlet weak var paymentwalletAppTokenTxtField: UITextField!
    @IBOutlet weak var signTxtField: UITextField!

    var lastSelectedApiType:Environment? {
        get {
            let environment = userDefaults.object(forKey: "lastSelectedApiType") as? Int
            return Environment(rawValue: environment ?? 3)
        } set {
            userDefaults.set(newValue?.rawValue, forKey: "lastSelectedApiType")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confirmPayDict = getConfirmPaymentDict(environment: self.lastSelectedApiType!)
        
        if let dict = confirmPayDict{
                        
            self.paymentwalletAppTokenTxtField.text = dict["paymentAppTokenTest"] as? String
            
            self.merchantRefNumTxtField.text = dict["merchantReferenceNumberTest"] as? String
            
            self.terminalRefNumTxtField.text = dict["terminalReferenceNumberTest"] as? String
            
            self.transferRefNumTxtField.text = dict["transferReferenceNumberTest"] as? String
            
            self.productIdTxtField.text = dict["productIdTest"] as? String
            
            self.amountTxtField.text = dict["amount"] as? String ?? "100TRY"
            
            self.requestIdTxtField.text = dict["requestId"] as? String
            
            self.signTxtField.text = dict["sign"] as? String
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        
        saveToPropertyList()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func kapatClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ConfigViewController{
    
    func getConfirmPaymentDict(environment:Environment) -> [String:AnyObject]? {
        
        if let plistDict = getPlist(environment: environment) {
            let paymentConfirmDict = plistDict["ConfirmPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        } else {
            return nil
        }
    }
    
    //Operation Write, update and delete plist file
    func saveToPropertyList() {
        
        let returnValues = getMutableDictionaryFromPlist(lastSelectedApiType: self.lastSelectedApiType ?? .test)
        
        let tempDict : NSMutableDictionary? = returnValues.mutDict
            
        let plistDict = tempDict?["ConfirmPayment"] as? NSMutableDictionary
            
        if let plistDict = plistDict{
            
            plistDict["productIdTest"] = productIdTxtField.text
            
            plistDict["transferReferenceNumberTest"] = transferRefNumTxtField.text
            
            plistDict["terminalReferenceNumberTest"] = terminalRefNumTxtField.text
            
            plistDict["merchantReferenceNumberTest"] = merchantRefNumTxtField.text
            
            plistDict["paymentAppTokenTest"] = paymentwalletAppTokenTxtField.text
            
            plistDict["amount"] = amountTxtField.text
            
            plistDict["requestId"] = self.requestIdTxtField.text
            
            plistDict["sign"] = self.signTxtField.text
            
            tempDict?["ConfirmPayment"] = plistDict
        }
            
        tempDict?.write(toFile: returnValues.url.path, atomically: true)
    }
}
