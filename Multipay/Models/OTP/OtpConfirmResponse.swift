//
//  OtpConfirmResponse.swift
//  Multipay-Multipay
//
//  Created by ilker sevim on 5.11.2020.
//

import Foundation

struct OtpConfirmResponse: Codable {

    struct Result: Codable {
        let authToken: String?
    }

    let result: Result?
    let resultCode: Int?
    let resultMessage: String?
}
