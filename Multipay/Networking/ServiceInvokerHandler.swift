//
//  ServiceInvokerHandler.swift
//  MTGeneral
//
//  Created by ilker sevim on 6.08.2020.
//  Copyright © 2020 inventiv. All rights reserved.
//

import Foundation
import Alamofire

public let authTokenKey = "authToken"
public let walletTokenKey = "walletToken"
public let languageCodeKey = "languageCode"
public let appTokenKey = "appToken"
public let newAppTokenKey = "walletAppToken"
public let requestIdKey = "requestId"
public let referenceNumberKey = "referenceNumber"
public let paymentAppTokenKey = "paymentAppToken"
public let merchantReferenceNumberKey = "merchantReferenceNumber"
public let terminalReferenceNumberKey = "terminalReferenceNumber"
public let transferReferenceNumberKey = "transferReferenceNumber"
public let transactionDetailsKey = "transactionDetails"
public let signKey = "sign"

public let accountKey = "account"
public let terminalIdKey = "terminalId"
public let rollbackReferenceNumberKey = "rollbackReferenceNumber"
public let reasonKey = "reason"

public let resultCodeKey = "resultCode"
public let resultMessageKey = "resultMessage"
public let resultKey = "result"

public let sendAppTokenToRequests = true
public let sendRequestIdToRequests = true

open class ServiceInvokerHandler {
    
    public enum ServiceInvokerHandlerApplicationType {
        case multiPay
    }
    
    public static let sharedInstance = ServiceInvokerHandler()
    
    private init(){    }
    
    func post(_ serviceName: String,
              isSdkService: Bool = true,
              isForPoEditor: Bool = false,
              parameters: [String: AnyObject],
              isCancelable:Bool,
              isSecure: Bool = false,
              applicationType: ServiceInvokerHandlerApplicationType = .multiPay,
              supportCodable: Bool = false,
              httpMethod: HTTPMethod = .post,
              sendRequestIdToRequestsParam: Bool = true,
              callback: @escaping SuccessCallBack,
              errorCallback:@escaping ErrorCallBack)
    {
        
        var serviceParameters = parameters
        
        let languageRegion = CoreManager.shared.getLanguageRegion()
        
        serviceParameters[languageCodeKey] = languageRegion as AnyObject
        
        let token = ServiceUrl.getToken()
        
        if sendAppTokenToRequests, token.count > 0{
            serviceParameters[appTokenKey] = token as AnyObject
            serviceParameters[newAppTokenKey] = token as AnyObject
        }
        
        if sendRequestIdToRequests, sendRequestIdToRequestsParam{
            let requestId = UUID().uuidString.lowercased()
            serviceParameters[requestIdKey] = requestId as AnyObject
        }
        
        NetworkClient.post(serviceName, isSdkService: isSdkService, isForPoEditor: isForPoEditor, parameters: serviceParameters, displayError: false, isSecure: true, httpMethod: httpMethod, callback: callback, errorCallback: errorCallback)
    }
    
}
