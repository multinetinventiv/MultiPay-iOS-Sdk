//
//  ConfigViewController.swift
//  FrameworkTest
//
//  Created by ilker sevim on 26.01.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import UIKit
import Multipay

class ReversalConfigViewController: UIViewController {
    
    @IBOutlet weak var requestIdTxtField: UITextField!
        
    @IBOutlet weak var terminalRefNumTxtField: UITextField!
    
    @IBOutlet weak var merchantRefNumTxtField: UITextField!
    
    @IBOutlet weak var paymentwalletAppTokenTxtField: UITextField!
    
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
        
        let confirmPayDict = getRollbackPaymentDict(environment: self.lastSelectedApiType!)
        
        if let dict = confirmPayDict{
            
            self.paymentwalletAppTokenTxtField.text = dict["paymentAppTokenTest"] as? String
            
            self.requestIdTxtField.text = dict["requestId"] as? String
                        
            self.merchantRefNumTxtField.text = dict["merchantReferenceNumberTest"] as? String
            
            self.terminalRefNumTxtField.text = dict["terminalReferenceNumberTest"] as? String
            
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

extension ReversalConfigViewController{
    
    func getRollbackPaymentDict(environment:Environment) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(environment: environment){
            
            let paymentConfirmDict = plistDict["RollbackPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        }
        else{
            return nil
        }
    }
    
    //Operation Write, update and delete plist file
    func saveToPropertyList() {
        
        let returnValues = getMutableDictionaryFromPlist(lastSelectedApiType: self.lastSelectedApiType ?? .test)
        
        let tempDict: NSMutableDictionary? = returnValues.mutDict
        
        let plistDict = tempDict?["RollbackPayment"] as? NSMutableDictionary
        
        if let plistDict = plistDict{
                        
            plistDict["terminalReferenceNumberTest"] = terminalRefNumTxtField.text
            
            plistDict["merchantReferenceNumberTest"] = merchantRefNumTxtField.text
            
            plistDict["paymentAppTokenTest"] = paymentwalletAppTokenTxtField.text
            
            plistDict["requestId"] = self.requestIdTxtField.text
            
            tempDict?["RollbackPayment"] = plistDict
        }
        
        tempDict?.write(toFile: returnValues.url.path, atomically: true)
    }
}
