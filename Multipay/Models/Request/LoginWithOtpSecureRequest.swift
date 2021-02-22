//
//  LoginWithOtpSecureRequest.swift
//  Multipay
//
//  Created by ilker sevim on 7.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import UIKit

final class LoginWithOtpSecureRequest: Codable {
    
    var Email: String
    var Password:String
    var GSM:String

    init(email: String, password:String, gsm:String) {
        self.Email = email
        self.Password = password
        self.GSM = gsm
    }
}

final class LoginInfo: BaseModel {
    
    var LoginInfo:LoginWithOtpSecureRequest?
    
     init(loginInfo: LoginWithOtpSecureRequest) {
        super.init()
        self.LoginInfo = loginInfo
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}
