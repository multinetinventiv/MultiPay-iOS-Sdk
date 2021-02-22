//
//  ErrorModel.swift
//  MultiPay
//
//  Created by  on 16/11/2016.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

open class GenericErrorModel :CustomStringConvertible {
    open var result: String?
    open var code: String?
    open var message: String?
    open var additionalData: Dictionary<String, String>?
    
    public init(result: String?, code: String?, message: String?, additionalData: Dictionary<String, String>?){
        self.result = result
        self.code = code
        self.message = message
        self.additionalData = additionalData
    }

    public init(code: String?, message: String?) {
        self.code = code
        self.message = message
    }

    
    open var description: String {
        var result = ""
        
        if let code = self.code {
            let message = getSystemError(code)
            result += code + " - " + message
        }
    
        return result
    }
    
    func getSystemError(_ code:String) -> String {
        
        var message = ""
        
        if code == "-1005" {
            message = "The network connection was lost."
        
        }else if code == "-1001" {
            message = "The request timed out."
        
        }else{
            
            message = "Connection error"
        }
        
        return message
    }
    
}
