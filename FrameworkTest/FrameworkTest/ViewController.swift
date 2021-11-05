//
//  ViewController.swift
//  FrameworkTest
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import UIKit
import Multipay

public let userDefaults = UserDefaults.standard

class ViewController: UIViewController {
    
    @IBOutlet weak var testModeSwitch: UISwitch!
    
    @IBOutlet weak var authenticationTokenSwitch: UISwitch!
    
    @IBOutlet weak var walletTokenSwitch: UISwitch!
    
    @IBOutlet weak var kartNameLbl: UILabel!
    @IBOutlet weak var kartNumber: UILabel!
    @IBOutlet weak var bakiyeLbl: UILabel!
    @IBOutlet weak var kartImage: UIImageView!
    
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    @IBOutlet weak var activityInd2: UIActivityIndicatorView!
    
    @IBOutlet weak var cardStack: UIStackView!
    @IBOutlet weak var ödemeYapBtn: UIButton!
    @IBOutlet weak var kartDegistirBtn: UIButton!
    @IBOutlet weak var kartSilBtn: UIButton!
    
    @IBOutlet weak var reversalStackView: UIStackView!
    @IBOutlet weak var transferServerRefNoValue: UILabel!
    @IBOutlet weak var reversalSegmentedControl: UISegmentedControl!
    
    var selectedWalletToken: String?
    {
        get{
            //return getWalletToken(apiType: lastSelectedApiType ?? .test) ?? userDefaults.object(forKey: "selectedWalletToken") as? String
            return userDefaults.object(forKey: "selectedWalletToken") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "selectedWalletToken")
            saveToPropertyList()
        }
    }
    
    var selectedAuthToken: String?
    {
        get{
            //return getAuthToken(apiType: lastSelectedApiType ?? .test) ?? userDefaults.object(forKey: "selectedAuthToken") as? String
            return userDefaults.object(forKey: "selectedAuthToken") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "selectedAuthToken")
            saveToPropertyList()
        }
    }
    
    var lastConfirmPaymentRequestId: String?
    {
        get{
            return userDefaults.object(forKey: "lastConfirmPaymentRequestId") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "lastConfirmPaymentRequestId")
        }
    }
    
    var lastReversalPaymentRequestId: String?
    {
        get{
            return userDefaults.object(forKey: "lastReversalPaymentRequestId") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "lastReversalPaymentRequestId")
        }
    }
    
    var lastTransferReferenceNumber: String?
    {
        get{
            return userDefaults.object(forKey: "lastTransferReferenceNumber") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "lastTransferReferenceNumber")
        }
    }
    
    var lastTransferServerReferenceNumber: String?
    {
        get{
            return userDefaults.object(forKey: "lastTransferServerReferenceNumber") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "lastTransferServerReferenceNumber")
        }
    }
    
    var lastRollbackReferenceNumber: String?
    {
        get{
            return userDefaults.object(forKey: "lastRollbackReferenceNumber") as? String
        }
        set{
            userDefaults.set(newValue, forKey: "lastRollbackReferenceNumber")
        }
    }
    
    var lastSelectedApiType:APIType?{
        
        get{
            let apiType = userDefaults.object(forKey: "lastSelectedApiType") as? Int
            return APIType(rawValue: apiType ?? 3)
        }
        set{
            userDefaults.set(newValue?.rawValue, forKey: "lastSelectedApiType")
        }
        
    }
    
}

extension ViewController{
    
    func openMultipay(apiType:APIType){
        
        lastSelectedApiType = apiType
        
        //let userPreset = UserPreset(name: "TestName", surname: "TestSurname", email: "testEmail", gsm: "5321234567")
        
        let userPreset = UserPreset()
        
        Multipay.start(vcToPresent: self.navigationController!.topViewController ?? self, appToken: getAppToken(apiType: apiType), referenceNumber: getReferenceNumber(apiType: apiType), delegate: self, languageCode: "tr", apiType: apiType, testMode: testModeSwitch.isOn, walletToken: walletTokenSwitch.isOn ? (selectedWalletToken != nil) ? selectedWalletToken : getWalletToken(apiType: apiType) : nil, obfuscationSalt: getObfuscationSalt(apiType: apiType) ?? "", userPreset: userPreset)
    }
}

extension ViewController{
    
    func getObfuscationSalt(apiType:APIType) -> String?{
        var obfuscationSalt:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["obfuscationSalt"]
            obfuscationSalt = tempAppToken as? String
        }
        return obfuscationSalt
    }
    
    func getWalletToken(apiType:APIType) -> String?{
        
        var appToken:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["walletToken"]
            appToken = tempAppToken as? String
        }
        
        return appToken
    }
    
    func getAuthToken(apiType:APIType) -> String?{
        
        var appToken:String?
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["authenticationToken"]
            appToken = tempAppToken as? String
        }
        
        return appToken
    }
    
    func getAppToken(apiType:APIType) -> String{
        
        var appToken = ""
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["appToken"]
            appToken = tempAppToken as! String
        }
        
        return appToken
    }
    
    func getReferenceNumber(apiType:APIType) -> String{
        
        var appToken = ""
        
        if let plistDict = getPlist(apiType: apiType){
            let tempAppToken = plistDict["referenceNumber"]
            appToken = tempAppToken as! String
        }
        
        return appToken
    }
    
}

extension ViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardStack.layer.borderWidth = 1
        self.cardStack.layer.borderColor = UIColor.black.cgColor
        
        testModeSwitch.isOn = false
        
        if selectedWalletToken != nil, selectedWalletToken!.count > 0{
            walletTokenSwitch.isOn = true
        }
        else{
            walletTokenSwitch.isOn = false
        }
        
        if let selectedWalletToken = selectedWalletToken, selectedWalletToken.count > 0 {
            Multipay.callSingleWallet(delegate: self, appToken: getAppToken(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), walletToken: selectedWalletToken, languageCode: "tr", referenceNumber: getReferenceNumber(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType!) ?? "", testMode: testModeSwitch.isOn)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.navigationBar.barTintColor = nil
        self.navigationController?.navigationBar.tintColor = nil
        self.navigationController?.navigationBar.backgroundColor = nil
        
    }
    
}

extension ViewController{
    func changeVisibility(isHidden : Bool){
        //self.cardStack.isHidden = isHidden
        
        if self.lastTransferServerReferenceNumber != nil{
            self.reversalStackView.isHidden = isHidden
        }
        else if self.lastTransferServerReferenceNumber == nil{
            self.reversalStackView.isHidden = true
        }
    }
}

extension ViewController: MultipayDelegate {
    func multipayRollbackWithSignDidFail(error: ErrorModel?) {
        
        let alert = UIAlertController(title: "Reversal process failed", message: (error?.message ?? ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        activityInd2.stopAnimating()
        
    }
    
    
    func multipayRollbackWithSignDidSucceed(sign: String?, rollbackServerReferenceNumber: String?) {
        
        if let _ = sign, let _ = rollbackServerReferenceNumber
        {
            
            let alert = UIAlertController(title: "Rollback payment request succeed!", message: "Success", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            if let selectedWalletToken = selectedWalletToken, selectedWalletToken.count > 0 {
                Multipay.callSingleWallet(delegate: self, appToken: getAppToken(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), walletToken: selectedWalletToken, languageCode: "tr", referenceNumber: getReferenceNumber(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
            }
            
            self.reversalStackView.isHidden = true
            
            print("Rollback payment is finished successfully")
        }
        
        else{
            let alert = UIAlertController(title: "Rollback payment request succeed but sign is not valid!", message: "Sign is not valid ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        activityInd2.stopAnimating()
    }
    
    func multipayPaymentDidSucceed(sign: String?, transferServerRefNo: String?) {
        
        self.lastTransferServerReferenceNumber = transferServerRefNo
        
        if let sign = sign
        {
            print("sign is \(sign)")
            
            let alert = UIAlertController(title: "confirm payment request succeed!", message: "Success", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            if selectedWalletToken != nil, selectedWalletToken!.count > 0{
                walletTokenSwitch.isOn = true
            }
            else{
                walletTokenSwitch.isOn = false
            }
            
            if let selectedWalletToken = selectedWalletToken, selectedWalletToken.count > 0 {
                Multipay.callSingleWallet(delegate: self, appToken: getAppToken(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), walletToken: selectedWalletToken, languageCode: "tr", referenceNumber: getReferenceNumber(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
            }
            
            self.reversalStackView.isHidden = false
            
            print("Payment is finished successfully")
        }
        
        else{
            let alert = UIAlertController(title: "confirm payment request succeed but sign is not valid!", message: "Sign is not valid ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("sign values do not match! ")
        }
        
        activityInd.stopAnimating()
    }
    
    
    func multipayPaymentDidFail(error: Error?) {
        
        if let selectedWalletToken = selectedWalletToken, selectedWalletToken.count > 0 {
            Multipay.callSingleWallet(delegate: self, appToken: getAppToken(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), walletToken: selectedWalletToken, languageCode: "tr", referenceNumber: getReferenceNumber(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
        }
        
        self.reversalStackView.isHidden = false
        
        let alert = UIAlertController(title: "confirm payment request failed", message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        activityInd.stopAnimating()
    }
    
    func multipayUnselectCardSuccess() {
        let alert = UIAlertController(title: "UnSelectWallet Request", message: "Result is: success", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        changeVisibility(isHidden: true)
        
        self.selectedAuthToken = nil
        
        activityInd.stopAnimating()
    }
    
    func multipayUnselectCardFailed(resultCode: String?, resultMessage: String?) {
        let alert = UIAlertController(title: "UnSelectWallet Request", message: "Result is: failed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        activityInd.stopAnimating()
    }
    
    func multipaySingleWalletSuccess(cardBalance: String?, cardImageUrl: String?, cardName: String?, walletToken: String?, cardMaskedNumber: String?) {
        
        self.kartNameLbl.text = cardName
        self.kartNumber.text = cardMaskedNumber
        self.bakiyeLbl.text = cardBalance
        self.selectedWalletToken = walletToken
        
        if let walletToken = walletToken, walletToken.count > 0{
            self.walletTokenSwitch.isOn = true
        }
        
        if let url = cardImageUrl{
            self.kartImage.load(url: URL(string: url)!)
        }
        
        self.cardStack.isHidden = false
        activityInd.stopAnimating()
        
    }
    
    func multipaySingleWalletFailed(resultCode: String?, resultMessage: String?) {
        let alert = UIAlertController(title: "Single Wallet Request", message: "Result is: Failed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.selectedWalletToken = nil
        self.walletTokenSwitch.isOn = false
        changeVisibility(isHidden: true)
        
        activityInd.stopAnimating()
    }
    
    func walletTokenExpired(expiredWalletToken: String?) {
        self.selectedWalletToken = nil
        self.walletTokenSwitch.isOn = false
    }
    
    func multipaySelectedCardInfos(cardBalance: String?, cardImageUrl: String?, cardName: String?, walletToken: String?, cardMaskedNumber: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: "Eşleştirilen kart", message: "cardName: \(String(describing: cardName)) \n cardBalance: \(String(describing: cardBalance)) walletToken: \(String(describing: walletToken)) \n cardMaskedNumber: \(String(describing: cardMaskedNumber))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        self.kartNameLbl.text = cardName
        self.kartNumber.text = cardMaskedNumber
        self.bakiyeLbl.text = cardBalance
        self.selectedWalletToken = walletToken
        
        if let walletToken = walletToken, walletToken.count > 0{
            self.walletTokenSwitch.isOn = true
        }
        
        if let url = cardImageUrl{
            self.kartImage.load(url: URL(string: url)!)
        }
        
        changeVisibility(isHidden: false)
    }
    
    func multipayLoginDidComplete(authToken: String) {
        
        self.selectedAuthToken = authToken
        
        self.authenticationTokenSwitch.isOn = true
        
    }
    
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension ViewController{
    
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
            
            let paymentConfirmDict = plistDict["ConfirmPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        }
        else{
            return nil
        }
    }
    
    func getReversalPaymentDict(apiType:APIType) -> [String:AnyObject]?{
        
        if let plistDict = getPlist(apiType: apiType){
            
            let paymentConfirmDict = plistDict["RollbackPayment"]
            
            return paymentConfirmDict as? [String : AnyObject]
        }
        else{
            return nil
        }
    }
    
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
        
        tempDict["authenticationToken"] = self.selectedAuthToken
        
        tempDict["walletToken"] = self.selectedWalletToken
        
        tempDict.write(toFile: path!, atomically: true)
    }
}

extension ViewController{
    
    @IBAction func resetClicked(_ sender: Any) {
        
        self.silClicked(self)
        
        self.testModeSwitch.isOn = false
        self.authenticationTokenSwitch.isOn = false
        self.walletTokenSwitch.isOn = false
        
        changeVisibility(isHidden: true)
        
        self.selectedWalletToken = nil
        
        self.selectedAuthToken = nil
        
        self.lastConfirmPaymentRequestId = nil
        
        self.lastTransferReferenceNumber = nil
    }
    
    @IBAction func configurePaymentParamClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfigViewController")
        
        self.present(vc, animated: true) {
            
        }
    }
    
    @IBAction func configureReversalParamClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReversalConfigViewController")
        
        self.present(vc, animated: true) {
        }
        
    }
    
    @IBAction func configureCommonParamsClicked(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfigCommonViewController")
        
        self.present(vc, animated: true) {
            
        }
    }
    
    @IBAction func silClicked(_ sender: Any) {
        if let walletToken = selectedWalletToken{
            
            activityInd.startAnimating()
            
            Multipay.callUnSelectWallet(delegate: self, appToken: getAppToken(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), walletToken: walletToken, referenceNumber: getReferenceNumber(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test), obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
        }
    }
    
    @IBAction func confirmPaymentClicked(_ sender: Any) {
        
        let confirmPayment = getConfirmPaymentDict(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test)
        
        if let confirmPaymentDict = confirmPayment, let walletToken = selectedWalletToken {
            
            activityInd.startAnimating()
            
            let paymentAppToken = confirmPaymentDict["paymentAppTokenTest"] as! String
            let merchantReferenceNumber = confirmPaymentDict["merchantReferenceNumberTest"] as! String
            let terminalReferenceNumber = confirmPaymentDict["terminalReferenceNumberTest"] as! String
            //let transferReferenceNumber = confirmPaymentDict["transferReferenceNumberTest"] as! String
            
            let transferReferenceNumber = UUID().uuidString.lowercased()
            
            self.lastTransferReferenceNumber = transferReferenceNumber
            
            let productId = confirmPaymentDict["productIdTest"] as! String
            
            var configRequestId = confirmPaymentDict["requestId"] as? String ?? ""
            if configRequestId.count < 1 {
                configRequestId = UUID().uuidString.lowercased()
            }
            
            let requestId = configRequestId
            
            let referenceNumber = UUID().uuidString.lowercased()
            
            let amount = confirmPaymentDict["amount"] as? String ?? "100TRY"
            let transactionDetailModel: TransactionDetailModel = TransactionDetailModel(amount: amount, productId: productId , referenceNumber: referenceNumber)
            
            let transactionDetailModelArray:[TransactionDetailModel] = [transactionDetailModel]
            
            let saltKey = confirmPaymentDict["saltKeyTest"] as! String
            
            var transactionDetailSaltValue = ""
            
            for transDetailModel in transactionDetailModelArray{
                transactionDetailSaltValue += transDetailModel.amount + transDetailModel.productId
            }
            
            var sign = saltKey + merchantReferenceNumber + transferReferenceNumber + transactionDetailSaltValue + terminalReferenceNumber + requestId
            sign = sign.sha256PaymentConfirmation ?? sign
            
            self.lastConfirmPaymentRequestId = requestId
            
            Multipay.callConfirmPayment(delegate: self, paymentAppToken: paymentAppToken, languageCode: "tr", requestId: requestId, walletToken: walletToken, merchantReferenceNumber: merchantReferenceNumber, terminalReferenceNumber: terminalReferenceNumber, transferReferenceNumber: transferReferenceNumber, transactionDetails: transactionDetailModelArray, sign: sign, obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
        }
        
    }
    
}

//MARK: Reversal Button Actions

extension ViewController{
    
    func callPaymentReversal(reason:ReferenceToRollbackModel.ReasonRollback){
        
        let confirmPayment = getReversalPaymentDict(apiType: (lastSelectedApiType != nil) ? lastSelectedApiType! : .test)
        
        if let confirmPaymentDict = confirmPayment{
            
            activityInd2.startAnimating()
            
            let paymentAppToken = confirmPaymentDict["paymentAppTokenTest"] as! String
            let merchantReferenceNumber = confirmPaymentDict["merchantReferenceNumberTest"] as! String
            let terminalReferenceNumber = confirmPaymentDict["terminalReferenceNumberTest"] as! String
            
            let rollbackReferenceNumber = UUID().uuidString.lowercased()
            
            self.lastRollbackReferenceNumber = rollbackReferenceNumber
            
            var configRequestId = confirmPaymentDict["requestId"] as? String ?? ""
            if configRequestId.count < 1 {
                configRequestId = UUID().uuidString.lowercased()
            }
            
            let requestId = configRequestId
            
            self.lastReversalPaymentRequestId = requestId
            
            let saltKey = confirmPaymentDict["saltKeyTest"] as! String
            
            var sign = saltKey + merchantReferenceNumber + self.lastRollbackReferenceNumber! + String(reason.rawValue) + terminalReferenceNumber + requestId
            sign = sign.sha256PaymentConfirmation ?? sign
            
            let selectedSegmentIndex = self.reversalSegmentedControl.selectedSegmentIndex
            
            let referenceNumberType = ReferenceToRollbackModel.ReferenceNumberType(rawValue: selectedSegmentIndex)!
            
            var referenceNumber = UUID().uuidString.lowercased()
            
            if selectedSegmentIndex == ReferenceToRollbackModel.ReferenceNumberType.Client.rawValue, let lastTransferReferenceNumber = self.lastTransferReferenceNumber{
                referenceNumber = lastTransferReferenceNumber
            }
            
            else if selectedSegmentIndex == ReferenceToRollbackModel.ReferenceNumberType.Server.rawValue, let lastTransferServerReferenceNumber = self.lastTransferServerReferenceNumber{
                referenceNumber = lastTransferServerReferenceNumber
            }
            
            else if let lastTransferReferenceNumber = self.lastTransferReferenceNumber{
                referenceNumber = lastTransferReferenceNumber
            }
            
            Multipay.callPaymentReversal(delegate: self, paymentAppToken: paymentAppToken, languageCode: "tr", requestId: requestId, sign: sign, merchantRefNo: merchantReferenceNumber, terminalRefNo: terminalReferenceNumber, rollbackReferenceNumber: rollbackReferenceNumber, reason: reason, referenceNumberType: referenceNumberType, referenceNumber: referenceNumber, obfuscationSalt: getObfuscationSalt(apiType: lastSelectedApiType ?? .test) ?? "", testMode: testModeSwitch.isOn)
            
        }
    }
    
    @IBAction func reversalCancelClicked(_ sender: Any) {
        
        callPaymentReversal(reason: ReferenceToRollbackModel.ReasonRollback.Cancel)
        
    }
    
    @IBAction func reversalClicked(_ sender: Any) {
        
        callPaymentReversal(reason: ReferenceToRollbackModel.ReasonRollback.Reversal)
        
    }
    
    @IBAction func refundClicked(_ sender: Any) {
        
        callPaymentReversal(reason: ReferenceToRollbackModel.ReasonRollback.Refund)
        
    }
    
    @IBAction func kartDegistirClicked(_ sender: Any) {
        self.openMultipay(apiType: lastSelectedApiType ?? .test)
    }
}


