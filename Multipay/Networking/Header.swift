
import Foundation

//private let HeaderSharedInstance = Header()

public typealias HeaderType = [String : String]

class Header{
    
    internal static let sharedInstance: Header = Header()
    
    fileprivate var deviceModel: String?
    fileprivate var header: [String: String] = [String: String]()
    
    fileprivate init() {
    }
    
    fileprivate func getVersion() -> String{
    
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        }
        
        return ""
    }
    
    func getHeader() -> HeaderType{
    
        self.header = HeaderType()

        /*
        header["device-app-version"] = getVersion()
        header["device-os-info"] = "iOS"
        header["device-os-version"] = UIDevice.current.systemVersion
        
        let deviceModel = UIDevice.current.modelName
        
        header["device-info-model"] = deviceModel
        */
        header["Content-Type"] = "application/json"
        header["Accept"] = "*/*"
        
        return header
    }
}
