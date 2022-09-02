
import Foundation

public class ErrorModel :GenericErrorModel  {
    
    override init(result: String?, code: String?, message: String?, additionalData: Dictionary<String, String>?){
        super.init(result: result, code: code, message: message, additionalData: additionalData)
    }
    
    override init(code: String?, message: String?) {
        super.init(code: code, message: message)
        
        self.message = code! + " - " + (message ?? self.getSystemError(code!))
    }
    
    deinit{
        //LoggerHelper.logger.debug(self.description)
    }
    
    override func getSystemError(_ code:String) -> String {
        
        var message = ""
        
        if code == "-1005" {
            message = Localization.Error1005.local
            
        }else if code == "-1001" {
            message = Localization.Error1001.local
            
        }else{
            
            message = Localization.ErrorHttp.local
        }
        
        return message
    }
    
}
