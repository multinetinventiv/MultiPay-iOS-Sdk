//
//  TransactionDetailModel.swift
//  Multipay
//
//  Created by ilker sevim on 22.01.2021.
//

import Foundation

public let referenceNumberTypeKey = "referenceNumberType"


public let refNoKey = "refNo"

public enum ReferenceNumberType: Int{
    case Client = 0
    case Server = 1
}

public enum ReasonRollback: Int{
    case Cancel = 2
    case Reversal = 3
    case Refund = 4
}
