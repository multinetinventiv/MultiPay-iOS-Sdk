
import UIKit

class User: NSObject,NSCoding {

    var  userId :String?
    var  firstName :String?
    var  lastName :String?
    var  email :String?
    var  password :String?
    
     func encode(with aCoder: NSCoder) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.userId = aDecoder.decodeObject(forKey: "userId") as? String
        self.firstName = aDecoder.decodeObject(forKey: "firstName") as? String
        self.lastName = aDecoder.decodeObject(forKey: "lastName") as? String
        self.email = aDecoder.decodeObject(forKey: "email") as? String
        self.password = aDecoder.decodeObject(forKey: "password") as? String
    }
    
    
    class func loadMultiMobilUser() -> User? {
        
        let defaults  = UserDefaults.standard
        var userMobil:User? = nil

        if let userData  = defaults.object(forKey: "user") as? Data {
            
            NSKeyedUnarchiver.setClass(User.self, forClassName: "User")
            let unData  = NSKeyedUnarchiver(forReadingWith: userData)
            userMobil = unData.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? User
            print("USerMobil :  \(userMobil!)")
        }
        
        return userMobil
       
    }
    
    class func removeDefaults() {
        let defaults  = UserDefaults.standard
        if let _ = defaults.object(forKey: "user") as? Data {
            defaults.removeObject(forKey: "user")
            defaults.synchronize()
        }
    }
}
