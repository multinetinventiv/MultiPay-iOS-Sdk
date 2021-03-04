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
        
        let returnValues = getMutableDictionaryFromPlist(lastSelectedApiType: self.lastSelectedApiType ?? .test)
        
        let tempDict:NSMutableDictionary? = returnValues.mutDict
        
        if let tempDict = tempDict{
            
            tempDict["authenticationToken"] = authTokenTxtField.text
            
            tempDict["walletToken"] = walletTokenTxtField.text
            
            tempDict["referenceNumber"] = referenceNumberTxtField.text
            
            tempDict["appToken"] = appTokenTxtField.text
            
            tempDict.write(toFile: returnValues.url.path, atomically: true)
            
        }
    }
}
