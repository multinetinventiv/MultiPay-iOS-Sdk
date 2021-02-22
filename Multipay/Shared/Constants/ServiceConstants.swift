import Foundation

public enum APIType : Int, CaseIterable {
    case prod = 1
    case pilot = 2
    case test = 3
    case dev = 4
}

struct Config {
    static let basePathTpype: APIType = {
        return (APIType(rawValue: API_TYPE) ?? APIType.prod)
    }()
    static let forcePathType: Bool      = IS_ENVIRONMENT_FORCED  // true oldugunda uygulama icerisinden ortam degisikligi yapilamaz
    static let isDebug                  = false // Debug loglarını açar ve kullanıcı bilgilerini ilgili alanlara dolu getirir.
    
    // Testing local
    static let LOCAL                    = false //True olduğunda, servisleri localden çağırır.                        !! (Live için false)
    static let kPinLocalTest            = false //True olduğunda, pin belirli olsa bile pin belirme ekranını açar.    !! (Live için false)
    static let kMultinetPlaza           = false //CoreManager.Instance().isLocationMultinetPlaza()                    !! (Live için false)
    
    // Setup
    static let GET_USER_IN_CM           = true   //getUser servisi launchVC içinde değil CoreManager içinde çağrılıp, user Aggrement BaseVC içinde implemente edilir
}

//MARK: - ServiceConstants
struct ServiceConstants {
    
    static let kRequestTimeout          = 60.0
    static let SUCCESS_RESULT_CODE      = 0
    
    //Service Code
    static let SESSION_ERROR                = 21451
    static let AGGREMENT_ERROR              = 21452
    static let KVKK_AGGREEMENT_ERROR        = 21454
    static let SYSTEM_ERROR                 = 21450
    static let TOKEN_ERROR                  = 20001
    static let TYPE_ERROR                   = 20002
    static let UNKNOWN_ERROR                = 99999
    static let REPLACE_CARD_ERROR           = 21453
    static let SECURE_CALL_ERROR                            = 20202
    static let SSL_PINNING_VALIDATION_ERROR                 = 25000
    static let NO_INTERNET_CONNECTION                       = -1009
    static let CONNECTION_WAS_LOST                          = -1005
    static let CONNECTION_WAS_CANCELLED                     = -1001
    static let NO_SERVICE_AUTHORIZATION                     = 20003
    static let MISSING_PARAMETERS_FOR_VERIFICATION          = 25603
    static let NO_MULTICARD_FOUND_FOR_VERIFICATION          = 55754
    
    
    //Google
    static let GoogleTrackId            = ServiceConstants.getValueFromGoogleFile(named: "TRACKING_ID")
    static let GoogleApiIOSKey          = ServiceConstants.getValueFromGoogleFile(named: "API_KEY")
    
    //Service Constant
    static var salt_prod_multipay       = ""
    static var salt_pilot_multipay      = ""
    static var salt_test_multipay       = ""
    static var kAPPToken                = ""
    static var kProdToken               = ""
    static var kKeychainSessionId       = ""
    static var kKeychainOpyId           = ""
    static var kNetmeraTestSdkKey       = ""
    static var kNetmeraProdSdkKey       = ""
    static var kNetmeraAppGroupName     = ""
    static var kMultinetSSLKey          = ""
    static var kTestMultinetSSLKey      = ""
    
    //MARK: - Keys.plist
    static func getValueFromGoogleFile(named keyname:String) -> String {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as! String
        return value
    }
    
    static func getValueFromInfoPlist(named keyname: String) -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        let value = plist?.object(forKey: keyname) as? String ?? "false"
        return value
    }
    
    //MARK: - ServiceName
    struct ServiceName {
        
        //SDK
        static let SdkLogin             = "auth/login"
        static let SdkOtpConfirm        = "auth/otp/confirm"
        static let SdkWallet            = "wallets/list"
        static let SdkAddWallet         = "wallets"
        static let SdkSelectWallet      = "wallets/select"
        static let SdkChangeWallet      = "wallets/change"
        static let SdkUnselectWallet    = "wallets/unselect"
        static let SdkSingleWallet      = "wallets/single"
        static let SdkPaymentConfirm    = "payment/confirm"
        static let SdkRollbackPayment   = "payment/rollback"
        
        
        static let SdkCreateMultinetCard        = "CreateMultinetCard"
        static let SdkDeleteMultinetCard        = "DeleteMultinetCard"
        static let SdkDeleteMultinetCardProduct = "DeleteMultinetCardProduct"
        static let SdkGetMultinetCard           = "GetMultinetCard"
        static let SdkGetMultinetCards          = "GetMultinetCards"
        static let SdkSetCardProductVisible     = "SetCardProductVisible"
        
        //Login
        
        static let LoginWithoutOtp          = "SdkLogin"
        static let LoginWithOtp             = "LoginWithOtp"
        static let LoginWithOtpSecure       = "LoginWithOtpSecure"
        static let Login                    = "Login"
        static let registerUser             = "Register"
        static let ConfirmOtp               = "ConfirmOtp"
        static let VerifyGsm                = "VerifyGsm"
        static let RemindPassword           = "RemindPassword"
        static let changePasswordviaRemind  = "ChangePasswordViaRemindPassword"
        static let changePassword           = "ChangePassword"
        static let GetCards                 = "GetMultinetCards"
        static let Update                   = "Update"
        static let GetUser                  = "GetUser"
        static let GetWalletBalance         = "GetWalletBalance"
        static let AddPhoto                 = "AddPhoto"
        static let GetPhoto                 = "GetPhoto"
        static let DeletePhoto              = "DeletePhoto"
        static let GetTotalBalance          = "GetMultinetCards"
        static let LoginWithActivationCode  = "LoginWithActivationCode"
        static let SetPassword              = "SetPassword"
        
        static let GetSaleInfo              = "GetProvisionInfo"
        static let GetMerchants             = "SearchNearestMerchants"
        static let GetCampaignMerchants     = "GetCampaignMerchants"
        static let GetParantezMerchantDetail = "GetParantezMerchantDetail"
        static let ConfirmProvision         = "ConfirmProvision"
        static let CreateCard               = "CreateCard"
        static let GetCardTransactions      = "GetWalletTransactions"
        static let GetTotalParantezReward   = "GetTotalParantezReward"
        static let GetMerchantFacilities    = "GetMerchantFacilities"
        static let GetCvvRequiredInfo       = "GetCvvRequiredInfo"
        
        //Installment
        static let GetBankCards             = "GetBankCards"
        static let CreateTopupFormAnonym    = "CreateTopupFormAnonym"
        static let TopupNonSecureAnonym     = "TopupNonSecureAnonym"
        static let CreateTopupForm          = "CreateTopupForm"
        static let TopupNonSecure           = "TopupNonSecure"
        static let TopupThreeDConfirm       = "TopupThreeDConfirm"
        static let DeleteBankCard           = "DeleteBankCard"
        static let CreateOrderTopupForm     = "CreateTopupOrderForm"
        
        //CardSpending
        static let GetSecurityQuestion      = "GetSecurityQuestion"
        static let ValidateSecurityAnswer   = "ValidateSecurityAnswer"
        static let GetCardOnlineTransactionLimit    =   "GetCardOnlineTransactionLimit"
        static let UpdateCardForWebSale     = "UpdateCardForWebSale"
        static let UpdateCardForMobileSale  = "UpdateCardForSale"
        static let BlockCard                = "BlockCard"
        static let UnblockCard              = "UnBlockCard"
        static let DeleteMultinetCard       = "DeleteMultinetCard"
        static let GetLostCardSummary       = "GetLostCardSummary"
        static let CreateInstantReplaceCardOrder = "CreateInstantReplaceCardOrder"
        
        static let GetCampaigns             = "GetCampaigns"
        
        static let ParantezCheckIn          = "ParantezCheckIn"
        static let ParantezCheckOut         = "ParantezCheckOut"
        
        static let GetSettings              = "GetSettings"
        static let SPFilterService          = "GetLookUpList"
        static let NotificationChannel      = "GetNotificationConfig"
        static let UpdateNotificationChannel = "UpdateNotificationConfig"
        
        static let GetUserTransactions      = "GetUserTransactions"
        
        static let GetContactUsReasonType   = "GetContactUsReasonType"
        static let ContactUs                = "ContactUs"
        static let UpdatePin                = "UpdatePinCode"
        static let UpdateThresholdAmount    = "UpdatePinCodeThresholdAmount"
        
        //Vertial Card Campaign
        static let GetCities                = "GetCities"
        static let GetDistricts             = "GetDistricts"
        static let GetNeighbourhoods        = "GetNeighbourhoods"
        static let CreateVirtualCard        = "CreateVirtualCard"
        
        
        //Campaign
        static let parantezReward           = "GetParantezRewards"
        static let parantezRewardTotal      = "GetTotalParantezReward"
        static let sendFeedBack             = "ReportMerchantError"
        static let Logout                   = "Logout"
        
        static let GetCardParantezReward    = "GetParantezReward"
        static let GetMissingRewards        = "GetMissingRewards"
        
        //Agreement
        static let MarkCurrentUserAggrementAsRead = "MarkCurrentUserAggrementAsRead"
        static let MarkKVKKAsRead           = "MarkKvkkAsAccepted"
        static let KeepThisCard             = "KeepThisCard"
        
        //MerchantDetail
        static let GetMerchantDetail        = "GetMerchantDetail"
        
        //TopUpOrder
        static let GetInquiryTopUpOrders    =  "GetTopupOrders"//"InquiryTopupOrders"
        static let CreateBankCard           =  "CreateBankCard"
        static let DeleteTopupOrder         =  "DeleteTopupOrder"
        
        static let ValidateUserInfo         =  "ValidateUserInfo"
        static let ReplaceCard              =  "ReplaceCard"
    }
    
    // MARK: - ErrorCheck
    struct ErrorCheck {
        static func isSessionInvalid(_ code: Int) -> Bool {
            return  ServiceConstants.SESSION_ERROR == code
        }
        
        static func isUserAggrement(_ code: Int) -> Bool {
            return  ServiceConstants.AGGREMENT_ERROR == code
        }
        
        static func isKVKKAgreementErrorEquals(to code: Int) -> Bool {
            return code == ServiceConstants.KVKK_AGGREEMENT_ERROR
        }
        
        static func isShowable(_ code: Int) -> Bool {
            return  ServiceConstants.SYSTEM_ERROR >= code
        }
        
        static func isTokenError(_ code: Int) -> Bool {
            return  ServiceConstants.TOKEN_ERROR == code ||  ServiceConstants.TYPE_ERROR == code
        }
        
        static func isSystemError(_ code: Int) -> Bool {
            return  ServiceConstants.UNKNOWN_ERROR == code
        }
        
        static func isSystemErrorWithCode(_ code: Int) -> Bool {
            return  ServiceConstants.SYSTEM_ERROR < code
        }
        
    }
    
    // MARK: - LocalService
    struct LocalService {
        static let serviceLocalList = [
            ServiceName.Login, ServiceName.GetUser, ServiceName.GetTotalBalance,
            ServiceName.GetCampaigns, ServiceName.GetCards, ServiceName.GetBankCards,
            ServiceName.GetMerchants, ServiceName.NotificationChannel,
            ServiceName.GetUserTransactions, ServiceName.UpdatePin,
            ServiceName.GetCardTransactions, ServiceName.parantezReward,
            ServiceName.GetSaleInfo
        ]
        
        static func isAvaliableToLocal(_ serviceName: String) -> Bool {
            return serviceLocalList.contains(serviceName)
        }
    }
    
}



// MARK: - ServiceUrl
public struct ServiceUrl {
    
    static func setApiType(kApiType: APIType) {
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(kApiType.rawValue, forKey: "apiType")
        userDefaults.synchronize()
        
    }
    
    static func readApiType() -> APIType {
        if let kApiType = UserDefaults.standard.object(forKey: "apiType") as? Int {
            switch kApiType {
            case 1:
                return .prod
            case 2:
                return .pilot
            case 3:
                return .test
            case 4:
                return .dev
            default:
                return .prod
            }
        }
        return .prod
    }
    
    static func isPROD() -> Bool {
        return ServiceUrl.readApiType() == .prod ? true : false
    }
    
    static func isPILOT() -> Bool {
        return ServiceUrl.readApiType() == .pilot ? true : false
    }
    
    static func isTEST() -> Bool {
        return ServiceUrl.readApiType() == .test ? true : false
    }
    
    static func getBaseURL(isSdk: Bool = true) -> String {
        switch ServiceUrl.readApiType() {
        case .dev:
                return DevSdkConfig.API_BASE_PATH
        case .test:
                return TestSdkConfig.API_BASE_PATH
        case .pilot:
                return PilotSdkConfig.API_BASE_PATH
        case .prod:
                return ProdSdkConfig.API_BASE_PATH
        }
    }
    
    static func getApiBaseDomainUrl(isSdk: Bool = false) -> String {
        
        switch ServiceUrl.readApiType() {
        case .dev:
                return DevSdkConfig.API_BASE_DOMAIN_URL
        case .test:
                return TestSdkConfig.API_BASE_DOMAIN_URL
        case .pilot:
                return PilotSdkConfig.API_BASE_DOMAIN_URL
        case .prod:
                return ProdSdkConfig.API_BASE_DOMAIN_URL
        }
    }
    
    static func getURL(_ serviceName:String, isSdk: Bool = false) -> String {
        return getBaseURL(isSdk: isSdk) + "/" + serviceName
    }
    
    
    static func getToken() -> String {
        
        if let token = Auth.appToken{
            return token
        }
        else{
            return ""
        }
        
        
    }
    
}
