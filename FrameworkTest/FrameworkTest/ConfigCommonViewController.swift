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
    @IBOutlet weak var walletAppTokenTxtField: UITextField!
    @IBOutlet weak var obfuscationKeyTxtField: UITextField!

    var lastSelectedApiType:Environment?{
        get{
            let environment = userDefaults.object(forKey: "lastSelectedApiType") as? Int
            return Environment(rawValue: environment ?? 3)
        }
        set{
            userDefaults.set(newValue?.rawValue, forKey: "lastSelectedApiType")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempDict = getConfirmPaymentDict(environment: self.lastSelectedApiType!)
        
        if let dict = tempDict{
            
            self.authTokenTxtField.text = dict["authenticationToken"] as? String
            
            self.walletTokenTxtField.text = dict["walletToken"] as? String
            
            self.referenceNumberTxtField.text = dict["referenceNumber"] as? String
            
            self.walletAppTokenTxtField.text = dict["walletAppToken"] as? String
            
            self.obfuscationKeyTxtField.text = dict["obfuscationKey"] as? String
            
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
    
    func getConfirmPaymentDict(environment:Environment) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(environment: environment){
            
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
        
        let returnValues = getMutableDictionaryFromPlist(lastSelectedApiType: self.lastSelectedApiType ?? .test)
        
        let tempDict:NSMutableDictionary? = returnValues.mutDict
        
        if let tempDict = tempDict{
            
            tempDict["authenticationToken"] = authTokenTxtField.text
            
            tempDict["walletToken"] = walletTokenTxtField.text
            
            tempDict["referenceNumber"] = referenceNumberTxtField.text
            
            tempDict["walletAppToken"] = walletAppTokenTxtField.text

            tempDict["obfuscationKey"] = obfuscationKeyTxtField.text

            tempDict.write(toFile: returnValues.url.path, atomically: true)
            
        }
    }
}
