//
//  TransactionDetailModel.swift
//  Multipay
//
//  Created by ilker sevim on 22.01.2021.
//

import Foundation

public struct ReferenceToRollbackModel{
    
    public static let referenceNumberTypeKey = "referenceNumberType"
    public static let refNoKey = "refNo"
    
    public enum ReasonRollback: Int{
        case Cancel = 2
        case Reversal = 3
        case Refund = 4
    }
    
    public enum ReferenceNumberType: Int{
        case Client = 0
        case Server = 1
    }
    
    
}
