//
//  PaymentConfirmResponseModel.swift
//  Multipay
//
//  Created by ilker sevim on 22.01.2021.
//

import Foundation

struct RollbackPaymentResponseModel: Codable {

        struct Result: Codable {
            let rollbackServerReferenceNumber: String?
            let sign: String?
        }

        let result: Result?

        let resultCode: Int?
        let resultMessage: String?
}
