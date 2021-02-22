//
//  SingleWalletResponse.swift
//  Multipay
//
//  Created by ilker sevim on 9.11.2020.
//

import Foundation

class SingleWalletResponse: Codable {

    class Result: Codable {
        var wallet: Wallet?
    }

    var result: Result?
    var resultCode: Int?
    var resultMessage: String?
}
