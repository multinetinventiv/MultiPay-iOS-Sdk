
import Foundation

public let suitIdentifier = "group.multinet.multipay.data"

public func loadFromNSUserDefaults(_ key: String) -> String?{
    
    if let defaults = UserDefaults(suiteName: suitIdentifier){
        
        if let result = defaults.string(forKey: key) {
            
            return result
            
        }else {
            
            return nil
        }
    }
    
    return nil
    
}

public func saveToNSUserDefaults(_ key: String, value: String){
    
    if let defaults = UserDefaults(suiteName: suitIdentifier){
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
        
    }
}

public func removeDataWithKey(_ key: String){
    
    if let defaults = UserDefaults(suiteName: suitIdentifier){
        
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    
}



public func loadObjectFromUserDefaults(_ key: String) -> AnyObject?{
    
    if let defaults = UserDefaults(suiteName: suitIdentifier){
        
        if let result = defaults.object(forKey: key) {
            
            return result as AnyObject
            
        }else {
            
            return nil
        }
    }
    
    return nil
    
    
}

public func isKeyLoaded(_ key:String) -> Bool {

    let obj = loadFromNSUserDefaults(key)
    return obj != nil
}

public func saveObjectToNSUserDefaults(_ key: String, value: AnyObject){
    
    if let defaults = UserDefaults(suiteName: suitIdentifier){
        
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
}
