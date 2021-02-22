
import Foundation

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class UserInfo:CustomStringConvertible {
    
    var  message :String?
    var  opyId   :String?
    var  surname :String?
    var  name :String?
    var  isGsmVerified :Bool?
    var  email :String?
    var  gsm :String?
    var  otherData :AnyObject?
    var  pinCodeThresholdAmount: String?
    var  pinCodeThresholdAmountSign: String?
    var  pinCodeThresholdAmountCurrency: String?
    var  pinCodeProtected : Bool?
    
    var pinCodeLimit : String {
        if pinCodeThresholdAmount != nil && pinCodeThresholdAmount?.length > 0 {
            return String(Double(self.pinCodeThresholdAmount!)! / 100).formatAmountToDisplay()
        }
        return ""
    }
    
    var pinCodeAmount: String{
        if pinCodeThresholdAmount != nil && pinCodeThresholdAmount?.length > 0 {
            return pinCodeThresholdAmount!
        }
        return ""
    }
    
    var description: String {
        
        if let namez = name, let surnamez = surname,let verifiedx = isGsmVerified {
            return "UserInfo: \(namez) \(surnamez)  verified:\(verifiedx) "
        }
        return "UserInfo info null"
    }
    
    deinit{
        print("\(self.name!) \(self.surname!) deinit")
    }
    
    
    init(message:String?,opyId:Int?,surname:String?,name:String?,isGsmVerified:Bool,email:String?,gsm:String?,pinProtected:Bool? = nil,otherData:AnyObject?){
        
        self.message = message
        self.name = name
        if let id = opyId{
            self.opyId = String(id)
        }
        
        
        self.surname = surname
        self.isGsmVerified = isGsmVerified
        self.email = email
        self.gsm = gsm
        self.otherData = otherData
        if(pinProtected != nil) {
            self.pinCodeProtected = pinProtected
        }
        
        if let theData = otherData {
             setThresholdAmount(theData)
        }
       
    }
    
    init(opyId:String,surname:String,name:String){
        self.name = name
        self.opyId = opyId
        self.surname = surname
    }
    
    func setThresholdAmount(_ data: AnyObject){
        if let pinCodeThresholdAmount = data["PinCodeThresholdAmount"] as? [String : AnyObject]{
            
            if let currency = pinCodeThresholdAmount["Currency"] as? String {
                self.pinCodeThresholdAmountCurrency = currency
            }
            
            if let money = pinCodeThresholdAmount["Money"] as? String {
                self.pinCodeThresholdAmount = money
            }
            
            if let sign = pinCodeThresholdAmount["Sign"] as? String {
                
                self.pinCodeThresholdAmountSign = sign
            }
        }
    }
    
    func getMail() -> String {
        
        guard let mail = self.email else{
            return ""
        }
        return mail
    }
    func getOpy() -> String {
    
        return opyId ?? ""
    }
    
    func getUserNameSurname() -> String {
        
        guard let name = self.name else{
            return ""
        }
        
        guard let surname = self.surname else{
            return name
        }
        return name + " " + surname
    }
    
    
    func getUserName() -> String {
        
        guard let name = self.name else{
            return ""
        }
    
        return name 
    }
    
    
    func getSurname() -> String {
        
        guard let surname = self.surname else{
            return ""
        }
        
        
        return surname
    }
    
    func getPinCodeThresholdAmountInDouble() -> Double {
     
        if (self.pinCodeThresholdAmount!.length > 0 ) {
            return Double(self.pinCodeThresholdAmount!)!
            
        }
        return 0.0
    
    }
    
    class func getUser(_ loginResponse:AnyObject?) -> UserInfo? {
        
       
        print("\(String(describing: loginResponse))")
        if let data  = loginResponse {
            
            var userVerified = true

            if let isGsmVerified = data["IsGsmVerified"], let verified = isGsmVerified as? Bool {
                
                userVerified = verified
            }
            
            var pincodeProtect :Bool? = nil
            
            if let thePin = data["PinCodeProtected"], let pinProtect = thePin as? Bool {
                
                pincodeProtect = pinProtect
            }
            
            if(Config.kPinLocalTest) {
                pincodeProtect = false
            }
            
            let userInfo = UserInfo(message: data["UserMessage"] as? String,
                                    opyId   : data["OpyId"] as? Int,
                                    surname : data["Surname"] as? String,
                                    name    : data["Name"] as? String,
                                    isGsmVerified: userVerified,
                                    email   : data["Email"] as? String,
                                    gsm : data["Gsm"] as? String,
                                    pinProtected : pincodeProtect,
                                    otherData: data)
            
         return userInfo
        }
            
        return nil;
    }
    
}
