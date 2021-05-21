//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON
import XCGLogger

typealias settingCallBack = (_
    data: Setting) -> Void
typealias lookUpCallBack = (_ data: [String : LookUpTable]?) -> AnyObject?
typealias errorCallBack = (_ data: ErrorModel) -> Void

internal let log = XCGLogger.default

internal class CoreManager {
    
    var manager = NetworkClient.shared.session
    
    weak var vcToPresent: UIViewController!
    
    static let shared = CoreManager()
    
    static let instance = shared
    
    var language  = NSLocale.preferredLanguages[0]
    var setting: Setting = Setting()
    var user : UserInfo? {
        
        willSet{
            print("old value: \(String(describing: self.user?.getOpy()))")
        }
    }
    
    var avatarOriginal:String?
    var avatarThumbnail: String?
    {
        didSet{
            
        }
    }
    
    var cards:[Card]?
    private(set)  var cardServiceRunning  = false
    
    var sector = [String:String]()
    
    var userLocation:CLLocation?
    
    private init(){    }
    
    public static func Instance() -> CoreManager {
        return shared
    }
    
    class func getVersion() -> String {
        
        if ServiceUrl.isPROD() {
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return "Version: " + version
            }
            return "V:"
        }
        
        
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                if ServiceUrl.isPILOT(){
                    return  "P_Version: " + version + "_" + build
                }
                return  "T_Version: " + version + "_" + build
            }
            
            return "TVersion: " + version
        }
        
        return "Test"
    }
    
    internal class func start(vcToPresent: UIViewController, appToken: String?, referenceNumber: String?, languageCode: String? = nil, apiType: APIType = .prod, walletToken: String? = nil, obfuscationSalt: String, userPreset: UserPreset? = nil)
    {
        
        CoreManager.shared.vcToPresent = vcToPresent
        
        Auth.obfuscationSalt = obfuscationSalt
        
        if let token = appToken{
            Auth.appToken = token
        }
        Auth.referenceNumber = referenceNumber
        
        Auth.walletToken = walletToken
        
        Auth.userPreset = userPreset
        
        if let language = languageCode, language.count > 0{
            CoreManager.shared.language = language
        }
        
        ServiceUrl.setApiType(kApiType: apiType)
        
        FontHelper.registerFonts()
        CoreManager.shared.setConfiguration()
        
        let navigationCont = MyNavigationController.instantiate()
        navigationCont.modalPresentationStyle = .fullScreen
        CoreManager.shared.vcToPresent.show(navigationCont, sender: nil)
    }
    
    class func getLocaleIdentifier() -> String {
        
        
        /*Bu Method LocaleIdentifier gerektirebileck durumlar için
         ref : https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html
         
         check with avaliableCurrentLocaleIdentifier()
         
         */
        
        //log.debug(NSLocaleCountryCode)
        let langCode = shared.language
        
        
        if (langCode.contains("en")) {
            return "en_US"
        }else if(langCode.contains("tr")) {
            return "tr_TR"
            
        }else{
            return "en_US"
        }
    }
    
    func getLanguageRegion() -> String {
        
        //log.debug(NSLocaleCountryCode)
        let langCode = self.language
        
        if (langCode.contains("en")) {
            return "en-US"
        }else if(langCode.contains("tr")) {
            return "tr-TR"
        }else{
            return "en-US"
        }
        
        //        else if (langCode.contains("fr")){
        //            return "fr-FR"
        //        }
    }
    
    class func dateFromatter(formatStr:String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = formatStr
        return formatter
        
    }
    
    //MARK: - LookUpList
    
    class func systemVersionLessThanIOS10() -> Bool{
        
        //switch UIDevice.current.systemVersion.compare("10.0", options: NSString.CompareOptions.NumericSearch)
        switch UIDevice.current.systemVersion.compare("10.0", options: NSString.CompareOptions.numeric){
        case .orderedSame, .orderedDescending:
            return false
        case .orderedAscending:
            return true
        }
        
    }
    
    //MARK: - Set Configuration
    
    func setConfiguration() {
        
        // Navigation
        UINavigationBar.setCustomAppereance()
        
    }
    
    //MARK: - GetUsers
    public func getUser() {
        let url = ServiceUrl.getURL(ServiceConstants.ServiceName.GetUser)
        
        let serviceParameter:[String:Any] = [languageCodeKey : self.getLanguageRegion(),
                                             appTokenKey    : ServiceUrl.getToken() ]
        
        let httpHeaders = HTTPHeaders(Auth.shared.getHeader())
        
        NetworkClient.request(url, method: .post, parameters: serviceParameter, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                if  let jsonData = json.dictionaryObject,let resultDictionary = jsonData[resultKey] {
                    
                    let theCode =  jsonData[resultCodeKey]
                    
                    if  ServiceConstants.ErrorCheck.isUserAggrement((theCode as! Int)) {
                        
                        return
                    }
                    
                    if ServiceConstants.ErrorCheck.isKVKKAgreementErrorEquals(to: theCode as! Int) {
                        
                        return
                    }
                    
                    
                    guard let _ = theCode, theCode as! Int == 0 else {
                        print("GetUser error \(String(describing: theCode)) - \(String(describing: jsonData[resultMessageKey]))")
                        return
                    }
                    
                    CoreManager.shared.user =  UserInfo.getUser(resultDictionary as AnyObject)
                    
                }else{
                    print("GetUser json error")
                }
                
                break
                
            case .failure:
                break
                
            }
        }
    }
    
    //MARK: - Card operations

    func  hasMoreThanOneRestonet() -> Bool {
        
        let filteredCards = self.cards!.filter({ $0.isRestonet() })
        return filteredCards.count > 1
        
    }
    
    func getRestonetCard() -> Card?{

        guard let cardList = self.cards else {
            return nil
        }
        
        return cardList.filter({ $0.isRestonet() }).first
    }
    
    func getVirtualCards() -> [Card]? {
        
        guard let cardList = self.cards else {
            return nil
        }
        
        return cardList.filter({ $0.productionType == ProductionType.virtual})
    }
    
    
    func addCard(card:Card) {
        
        if (cards == nil){
            cards = [Card] ()
        }
        cards?.append(card)
    }
    
    
    func  updateCard(card:Card,balance:String? = nil,addBalance:Bool = false) {
        
        for thecard in cards! {
            
            if(card.cardNo == thecard.cardNo &&
                card.product?.productType == thecard.product?.productType)
            {
                thecard.updateBalance(balance == nil ? "" : balance)
                break
            }
        }
    }
    
    
    
    
    func  invalidateCardBalance(card:Card) {
        
        for thecard in cards! {
            
            if(card.cardNo == thecard.cardNo &&
                card.product?.productType == thecard.product?.productType)
            {
                
                thecard.updateBalance(nil,force: true)
                break
            }
        }
        
    }
    
    
    func  getCard(cardNumber:String) -> Card? {
        
        var card:Card? = nil
        for thecard in cards! {
            
            if(cardNumber == thecard.cardNo)
            {
                card = thecard
                break
            }
        }
        return card
    }
    
    
    func  getTotalBalancewithCurrency() -> String {
        
        var balance = String(getTotalBalance())
        
        if(cards != nil && (cards?.count)!>0) {
            
            let theCard  = cards![0]
            
            if(theCard.sign != "") {
                balance = balance.asLocaleCurrency + " " + theCard.sign
            }else{
                balance = balance.asLocaleCurrency + " " + theCard.currency
            }
        }
        return balance
    }
    
    func  getCardCurrency() -> String {
        
        
        if(cards != nil && (cards?.count)!>0) {
            
            let theCard  = cards![0]
            
            if(theCard.sign != "") {
                return theCard.sign
            }else{
                return theCard.currency
            }
        }
        return ""
    }
    
    func  getTotalBalance() -> Double {
        
        var balance:Double = 0
        for thecard in cards! {

            balance += thecard.getBalance()
        }
        return balance
    }

    func logAnalytics(for eventName: String, withData data: [String: Any]) {
        //Analytics.logEvent(eventName, parameters: data)
    }
    
    //MARK : - Stack
    var viewControllerStack = Stack<UIViewController>()
    
    func pushVCToSctack(viewController:UIViewController)  {
        viewControllerStack.push(viewController)
        log.debug("push : \(viewController.className)")
    }
    
    func clear()  {
        
        self.user = nil
        self.cards = nil
        self.sector = [String:String]()
        self.userLocation = nil
        //self.isDashboardAnimationRun = false
        self.avatarOriginal = nil
        self.avatarThumbnail = nil
        
        viewControllerStack.clear()
        
    }
    
}
