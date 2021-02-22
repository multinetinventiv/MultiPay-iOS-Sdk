

import Foundation
import UIKit

struct Constants {
    
    static let kQR_CODE_TYPE_VALUE = ""
    
    static let ENCRYPTION_KEY   = ""
    static let TEXT_TO_ENCRIPT  = ""
    static let TEXT_TO_DENCRIPT = ""
    
    
    static let ENCRYPTION_ENABLED = false
    
    static let kCARD_LIMIT_TO_SHOW = 5
    
    static let kNewLogin   = true
    
    static let kCluster = true
    static let kMaxKMInSearch = 1000 //1000
    
    static let  _DEFAULT_USER_LOCATION_LATITUDE_	= 41.0405
    static let  _DEFAULT_USER_LOCATION_LONGITUDE_	= 28.9704
    
    
    static let TRY_COUNT_DIC_KEY = "TRY_COUNT_DIC"
    static let MAX_TRY_COUNT = ServiceUrl.isPROD() ? 3 : 16 // 4-16
    static let MAX_WAIT_TIME: TimeInterval = 86400 * 8 // 8 days
    
    static let STATUS_BAR_STYLE_ANIMATION_DURATION = 0.3
    
    static let maxRetryCount = Multipay.testModeActive ? 0 : 2

    //MARK:
    struct FormatTemplate {
        static let mobilePhoneTemplate = "0(599~)~ *9*9*9~ 99~ 99"
        static let phoneTemplate = "0(999~)~ *9*9*9~ 99~ 99"
        static let standardCardTemplate = "9999~ 99*9*9~ *9*9*9*9~ 9999"
        static let multinetCardTemplate = "9999~ 99*9*9~ *9*9*9*9~ 9999"
        static let amexCardTemplate = "9999~ 99*9*9*9*9~ *9*9999"
    }
    
    struct Notifications {
    }
    
    struct CardSpending {
        static let kCardSpendingUpdateButton              =    "kCARD_SPENDING_UPDATE_BUTTON"
    }


}

//MARK: - Regex
struct Regex {
    static let kEmail = "\\b(^['_A-Za-z0-9-]+(\\.['_A-Za-z0-9-]+)*@([A-Za-z0-9-])+(\\.[A-Za-z0-9-]+)*((\\.[A-Za-z0-9]{2,})|(\\.[A-Za-z0-9]{2,}\\.[A-Za-z0-9]{2,}))$)\\b"   // "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    static let kName  = "^[a-zA-ZöçşığüÖÇŞİĞÜ \\.]{2,50}$"
    
    static let kGSM  = "[5][0-9]{2}[0-9]{7}"
    static let kTCKN = "[1-9][0-9]{10}"
    static let kPin = "[0-9]{4}"
    
    static let kPassword1 = ".*[a-z]+.*"
    static let kPassword2 = ".*[A-Z]+.*"
    static let kPassword3 = ".*\\d+.*"
    static let kPasswordMin = 8
    static let kPasswordMax = 20

    static let kGSM444 = #"([0-9]{3}\ [0-9]{2}\ [0-9]{2})"#
}

//MARK: - LocalStorageKeys
struct LocalStorageKeys {
    
    static let kLangCode = "kLangCode"
    static let kLookUp   = "kLookUp"
    static let kLookUpVersion   = "kLookUpVersion"
    static let kAppNewInstalled = "kAppNewInstalled"
    static let kShownTutorialCompletely = "kShownTutorialCompletely"
    static let kPushNotificationRequestAlreadySeen = "PushNotificationRequestAlreadySeen"
    static let kDashBoardShowCaseCompleted = "DashBoardShowCaseCompleted"
    static let kSalePointShowCaseCompleted = "SalePointShowCaseCompleted"
    static let kFuelMessageNeverShow = "FuelMessageNeverShow"
    static let k3DTopUp =   "3dTopUp"
    static let kCardOrderByUserChoice = "CardOrderByUserChoice"
    static let kCardTotalBalanceChoice = "CardTotalBalanceChoice"
    static let kQRPaymentFromExtensions = "QRPaymentFromExtensions"
    static let kPushNotificationPermissionsUpdatedForNetmera = ""
}


struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

struct GeneralConstants {
    static let kMultinetCallCenterPhoneNumberForDisplayValue = ""
}
