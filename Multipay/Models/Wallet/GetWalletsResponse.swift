//
//  GetWalletsResponse.swift
//  Multipay
//
//  Created by ilker sevim on 9.11.2020.
//

import Foundation

class GetWalletsResponse: Codable {
    
    class Result: Codable {
        var wallets: [Wallet]?
    }
    
    var result: Result?
    var resultCode: Int?
    var resultMessage: String?
}

open class Wallet: Codable {
    var balance: String?
    var name: String?
    var image: String?
    var token: String?
    var maskedNumber: String?
    //To indicate that wallet is selected in UI
    var isChecked:Bool? = false
    //To indicate that wallet is already chosen by user before and current active wallet.
    var isSelected:Bool? = false
    
    required public init(from decoder: Decoder) throws {
        balance = try decoder.decodeIfPresent("balance")
        name = try decoder.decodeIfPresent("name")
        image = try decoder.decodeIfPresent("image")
        
        token = try decoder.decodeIfPresent("token")
        maskedNumber = try decoder.decodeIfPresent("maskedNumber")
        isChecked = try decoder.decodeIfPresent("isChecked")
        isSelected = try decoder.decodeIfPresent("isSelected")
    }
    
    
}
