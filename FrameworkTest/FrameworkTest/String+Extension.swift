//
//  String+Extension.swift
//  FrameworkTest
//
//  Created by ilker sevim on 22.01.2021.
//  Copyright © 2021 multinet. All rights reserved.
//

import Foundation
import CommonCrypto.CommonHMAC

extension String {
    var sha256PaymentConfirmation:String? {
        guard let stringData = self.data(using: String.Encoding.utf8) else { return nil }
        return digest(input: stringData as NSData).base64EncodedString(options: [])
    }

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
}
