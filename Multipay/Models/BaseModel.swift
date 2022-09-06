//
//  BaseModel.swift
//  Multipay
//
//  Created by ilker sevim on 7.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation

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
        
        var serviceParameter: [String : Any] = [
            languageCodeKey : CoreManager.getLocaleIdentifier(),
            walletAppTokenKey : ServiceUrl.getWalletAppToken()
        ]
        
        if let paramdictionary  = parameters {
            for (k, v) in paramdictionary {
                serviceParameter[k] = v
            }
        }
        
        LoggerHelper.logger.debug("\(serviceName) -> \(serviceParameter)")
        
        let httpHeaders = HTTPHeaders(Auth.shared.getHeader())
        
        manager.request(url, method: .post, parameters: serviceParameter, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { response in
            
            guard response.error == nil else {
                // Display Error Alert
                
                let code = "\(ServiceConstants.SSL_PINNING_VALIDATION_ERROR)"
                let message = Localization.ErrorSystem
                let errorModel = GenericErrorModel(code: code, message: message)
                LoggerHelper.logger.error("Result Pinning validation failed for \(url)\n\n\(response.error.debugDescription)")
                errorCallback(errorModel as! ErrorModel, response.data)
                return
            }
            
            switch response.result {
            case .success(let value):
                let result = value as? [String : AnyObject] ?? [:]
                
                callback(result, nil)
                
                break
                
            case .failure:
                
                break
                
            }
        }
        
    }
}
