//
//  LocalizationManager.swift
//  Multipay
//
//  Created by ilker sevim on 8.12.2020.
//

import Foundation
import SwiftDate

let poApiToken = "56bcfdfce25508862040fd209574be86"
let multipaySdkId = "378379"
var selectedLanguageCode = "tr"
let localizationManagerUserDefaults = UserDefaults(suiteName: suitIdentifier)
let lastLocalizationUpdateDateKey = "lastLocalizationUpdateDateKey"
let alwaysUpdateOnInit = true

class LocalizationManager {
    
    static let shared = LocalizationManager()
    
    let bundle =  Bundle(url: (Bundle(for: Localization.self).resourceURL?.appendingPathComponent("\(Strings.bundleName).bundle"))!)
    
    private init() { }
    
    var languageDictKey: String {
        var languageDictKeyTemp = "languageDict"
        let locale = Locale.current
        let languageCode = locale.languageCode ?? "tr"
        languageDictKeyTemp += "-" + languageCode
        return languageDictKeyTemp
    }
    
    var poTermsListResponse: PoTermsListResponse?
    {
        didSet{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.LocalizationsUpdated), object: nil)
        }
    }
    
    func saveLanguageData(data: Data?, model: PoTermsListResponse){
        
        if let data = data{
            localizationManagerUserDefaults?.set(data, forKey: languageDictKey)
        }
        poTermsListResponse = model
        
    }
    
    public func localized(_ key: String, comment: String) -> String {
        
        var stringInFile = ""
        
        if let bundle = bundle{
            
            stringInFile = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
            
            if stringInFile.isEmpty {
                stringInFile = NSLocalizedString(key.lowercased(), tableName: nil, bundle: bundle, value: "", comment: "")
            }
            
            if stringInFile.isEmpty {
                stringInFile = NSLocalizedString(key.uppercased(), tableName: nil, bundle: bundle, value: "", comment: "")
            }
        }
        
        if poTermsListResponse == nil {
            
            if let savedLocalizations = localizationManagerUserDefaults?.object(forKey: languageDictKey) as? Data {
                let decoder = JSONDecoder()
                if let loadedLanguage = try? decoder.decode(PoTermsListResponse.self, from: savedLocalizations) {
                    LocalizationManager.shared.saveLanguageData(data: nil, model: loadedLanguage)
                }
            }
        }
        
        let stringInMemory: String = poTermsListResponse?.getTranslation(forKey: key) ?? ""
        
        let translation = stringInMemory.isEmpty ? (stringInFile.isEmpty ? key : stringInFile) : (stringInMemory)
        
        return translation
    }
    
    private static func needUpdate() -> Bool {
        
        if alwaysUpdateOnInit{
            return true
        }
        
        let lastClientDiffDate = localizationManagerUserDefaults?.object(forKey: lastLocalizationUpdateDateKey) as? Date
        
        var needUpdate = true
        
        if lastClientDiffDate != nil {
            let lastRefreshDateInRegion = DateInRegion(lastClientDiffDate!)
            needUpdate = !lastRefreshDateInRegion.compare(.isToday)
            if needUpdate {
                localizationManagerUserDefaults?.set(nil, forKey: lastLocalizationUpdateDateKey)
            }
        }
        
        return needUpdate
    }
    
    public static func getLanguageDataFromPoEditor(){
        
        if !needUpdate(){
            log.debug("localization language update cancelled")
            return
        }
        
        ServiceInvokerHandler.sharedInstance.post("", isSdkService: false, isForPoEditor: true, parameters: [:], isCancelable: true, isSecure: false, applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay, supportCodable: true, httpMethod: .post) { (data: [String:AnyObject]?, rawData) in
            
            if let rawData = rawData{
                do{
                    let modelObject = try rawData.decoded() as PoTermsListResponse
                    LocalizationManager.shared.saveLanguageData(data: rawData, model: modelObject)
                    localizationManagerUserDefaults?.set(Date(), forKey: lastLocalizationUpdateDateKey)
                }
                catch{
                    print("error: \(error)")
                }
            }
            
            if let responseData  = data {
                log.debug("data : \(responseData)")
            }
            
        } errorCallback: {(responseFail, rawData) in
            log.debug("responseFail \(responseFail)")
        }
    }
    
}
