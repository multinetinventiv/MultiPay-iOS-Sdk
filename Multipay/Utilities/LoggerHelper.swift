//
//  LoggerHelper.swift
//  Multipay
//
//  Created by Ramazan Oz on 2.09.2022.
//  Copyright © 2022 multinet. All rights reserved.
//

import Foundation

public class LoggerHelper {
    public static let logger = LoggerHelper()
    
    public func debug(_ message: Any) {
        debugPrint(message)
    }
    
    public func info(_ message: Any) {
        print(message)
    }
    
    public func warning(_ message: Any) {
        print(message)
    }
    
    public func error(_ message: Any) {
        print(message)
    }
}

