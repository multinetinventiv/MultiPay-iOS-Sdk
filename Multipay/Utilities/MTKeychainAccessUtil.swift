

import Foundation
import KeychainAccess

private let MTKeychainAccessUtilInstance = MTKeychainAccessUtil()


open class MTKeychainAccessUtil{
    
    fileprivate static var sharedInstance: MTKeychainAccessUtil {
        return MTKeychainAccessUtilInstance
    }
    
    
    fileprivate let keychainInstance = Keychain(service: "tr.com.multinet.multipay", accessGroup: "F2HN77VMS2.multiPayKeychainGroup")
    public static func getValue(_ identifier: String) -> String?{
    
        do {
            let value = try sharedInstance.keychainInstance.get(identifier)
            return value
            
        }catch{
            
            return nil
        }
        
    }
    
    public static func setValue(_ value: String?, key: String){
    
        if let val = value{
        
            if !val.isEmpty {
                
                sharedInstance.keychainInstance[key] = val
            }
            
        }
        
        
    }
    
    public static func removeDataCompleted(_ key: String) -> Bool{
    
        do {
            try sharedInstance.keychainInstance.remove(key)
            return true
            
            
        }catch{
            
            return false
        }

    }
    
    
    
}
