//
//  LoginResponseModel.swift
//  Multipay-Multipay
//
//  Created by ilker sevim on 4.11.2020.
//

import Foundation

struct LoginResponseModel: Codable {
    
    struct Result: Codable {
        let remainingTime: Int?
        let verificationCode: String?
        var gsm: String?
        init(gsm: String?, remainingTime: Int?, verificationCode: String?) {
            self.gsm = gsm
            self.remainingTime = remainingTime
            self.verificationCode = verificationCode
        }
    }
    
    var result: Result?
    let resultCode: Int?
    var resultMessage: String?
    init(result: Result?, resultCode: Int?, resultMessage: String?) {
        self.result = result
        self.resultCode = resultCode
        self.resultMessage = resultMessage
    }
}
