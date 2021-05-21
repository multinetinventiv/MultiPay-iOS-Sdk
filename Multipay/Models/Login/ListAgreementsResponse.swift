//
//  ListAgreementsResponse.swift
//  Multipay
//
//  Created by ilker sevim on 18.05.2021.
//

import Foundation

struct ListAgreementsResponse: Codable {
    
    struct Result: Codable {
        
        let userAgreementUrl: String?
        var gdprUrl: String?
        init(userAgreementUrl: String?, gdprUrl: String?){
            self.userAgreementUrl = userAgreementUrl
            self.gdprUrl = gdprUrl
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


/*
{
    "resultCode": 0,
    "resultMessage": null,
    "result": {
        "userAgreementUrl": "https://statictest.ipara.com/opy/terms/term-l1-ch32-t1-v1.0.html",
        "gdprUrl": "https://statictest.ipara.com/opy/terms/term-l1-ch32-t2-v1.0.html"
    }
}
*/
