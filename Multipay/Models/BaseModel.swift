//
//  BaseModel.swift
//  Multipay
//
//  Created by ilker sevim on 7.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import SwiftyJSON

class BaseModel: SessionDelegate {
    
    var manager : Session!
    
    init() {
        super.init()
        manager = NetworkClient.shared.session
    }
    
    func serviceHeader() -> [String:String] {
        
        let deviceModel = UIDevice.current.modelName
        return ["device-info-model":deviceModel]
    }
    
    
    func post(_ serviceName: String, parameters: [String: AnyObject]?, displayError: Bool = true, displaySpinner: Bool = true,callback: @escaping SuccessCallBack,errorCallback:@escaping ErrorCallBack) -> Void
    {
        
        
        let url = ServiceUrl.getURL(serviceName)
        
        var serviceParameter:[String:Any] = [languageCodeKey :  CoreManager.Instance().getLanguageRegion(),
                                             appTokenKey     : ServiceUrl.getToken()  ]
        
        
        if let paramdictionary  = parameters {
            for (k, v) in paramdictionary {
                serviceParameter[k] = v
            }
        }
        
        log.debug("\(serviceName) -> \(serviceParameter)")
        
        let httpHeaders = HTTPHeaders(Auth.shared.getHeader())
        
        // manager?.request(.POST, url, parameters: serviceParameter, encoding: .JSON ,headers: ServiceInvoker.sharedInstance.getHeader()).responseJSON {response in
        manager.request(url, method: .post, parameters: serviceParameter, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { response in
            
            guard response.error == nil else {
                // Display Error Alert
                
                let code = "\(ServiceConstants.SSL_PINNING_VALIDATION_ERROR)"
                let message = Localization.ErrorSystem
                let errorModel = GenericErrorModel(code: code, message: message)
                log.error("Result Pinning validation failed for \(url)\n\n\(response.error.debugDescription)")
                errorCallback(errorModel as! ErrorModel, response.data)
                return
            }
            
            switch response.result {
            case .success(let value):
                
                    let json = JSON(value)
                    
                    callback(json.dictionaryObject as [String : AnyObject]?, nil)
                
                break
                
            case .failure:
            
            break
                
            }
            
            
            
           
        }
        
    }
    
    
}
