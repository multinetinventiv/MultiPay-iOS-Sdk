//
//  Setting.swift
//  MultiPay
//
//  Created by  on 30/09/2016.
//  Copyright © 2016 . All rights reserved.
//

import Foundation


class Setting: BaseModel {
    
    var lookUpListVersion: String?
    var pinCodeThresholdAmountDefaultValue:String?
    var userAgreementUrl: String?
    var callCenterPhone: String?
    var faqURL: String?
    var tatliParaUrl: String?
    var cardIconUrlFormat:String?
    var numberOfCampaignsToShowOnScreen:Int = 10
    var versionIosMin               :String? = ""
    var bannedIosVersions: [String]? = []
    var kvkkUrl: String?
    
    init(lookUpListVersion: String? = nil,
         pinCodeThresholdAmountDefaultValue:String? = nil,
         userAgreementUrl: String? = nil,
         callCenterPhone: String? = nil,
         faqURL: String? = nil,
         tatliParaUrl: String? = nil,
         cardIconUrlFormat:String? = nil,
         numberOfCampaignsToShowOnScreen:String? = nil,
         versionIosMin: String? = "",
         bannedIosVersions: [String]? = [],
         kvkkUrl: String? = ""
         ) {
        
        self.lookUpListVersion = lookUpListVersion
        self.pinCodeThresholdAmountDefaultValue = pinCodeThresholdAmountDefaultValue
        self.userAgreementUrl = userAgreementUrl
        self.callCenterPhone = callCenterPhone
        self.faqURL = faqURL
        self.tatliParaUrl = tatliParaUrl
        self.cardIconUrlFormat = cardIconUrlFormat
        self.versionIosMin = versionIosMin
        self.bannedIosVersions = bannedIosVersions
        self.kvkkUrl = kvkkUrl
        
        if let value = numberOfCampaignsToShowOnScreen {
            self.numberOfCampaignsToShowOnScreen = Int(value) ?? 10
        }
    }
    
    class func createSetting(_ data: [String : AnyObject]?) -> Setting{
        
        
        if let result = data {
        
            log.debug("**********SERVER SIDE LOOKUP VERSION********** \(String(describing: result["LookUpListVersion"]))")
            
            return Setting(lookUpListVersion: result["LookUpListVersion"] as? String,
                           pinCodeThresholdAmountDefaultValue: result["PinCodeThresholdAmountDefaultValue"] as? String,
                           userAgreementUrl: result["UserAgreementUrl"] as? String,
                           callCenterPhone: result["CallCenterPhoneNumber"] as? String,
                           faqURL:result["FaqUrl"] as? String,
                           tatliParaUrl: result["TatliParaInfoUrl"] as? String,
                           cardIconUrlFormat: result["CardIconUrlFormat"] as? String,
                           numberOfCampaignsToShowOnScreen: result["NumberOfCampaignsToShowOnScreen"] as? String,
                           versionIosMin: result["ForceUpdateMinVersionForIos"] as? String,
                           bannedIosVersions: result["ForceUpdateVersionsForIos"] as? [String],
                           kvkkUrl: result["KvkkFormUrl"] as? String)
        }
        
        return Setting()
        
    }
    
}
