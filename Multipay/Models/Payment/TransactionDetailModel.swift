//
//  TransactionDetailModel.swift
//  Multipay
//
//  Created by ilker sevim on 22.01.2021.
//

import Foundation

public struct TransactionDetailModel: Codable {
    public var amount:String
    public var productId:String
    public var referenceNumber:String
    
    public init(amount: String, productId: String, referenceNumber: String) {
        self.amount = amount
        self.productId = productId
        self.referenceNumber = referenceNumber
    }
    
}
