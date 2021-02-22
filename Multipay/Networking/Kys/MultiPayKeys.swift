//
//  Keys.swift
//  Multipay
//
//  Created by ilker sevim on 8.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation

private let https = "https://"

private let v1 = Obfuscator().reveal(key: ObfsctfConstants.v1)

private enum ObfsctfConstants {
    static let DevAPI_BASE_DOMAIN_URL: [UInt8] = [6, 86, 16, 26, 8, 17, 84, 17, 92, 11, 80, 77, 25, 84, 4, 21, 93, 79, 5, 29, 28, 3, 21, 91, 27, 22, 82, 10, 84, 2, 77, 86, 3, 94, 72, 94, 11, 18, 93, 11, 65, 12, 67, 23, 71, 86, 23, 23, 81, 91, 1, 23]

    static let TestAPI_BASE_DOMAIN_URL: [UInt8] = [22, 86, 21, 67, 72, 9, 77, 9, 65, 12, 91, 92, 64, 30, 2, 0, 76, 93, 19, 5, 72, 79, 4, 66, 95, 72, 90, 10, 70, 6, 87, 71, 11, 69, 72, 68, 0, 22, 78, 12, 86, 0, 70]
    
    static let PilotAPI_BASE_DOMAIN_URL: [UInt8] = [18, 90, 10, 88, 17, 73, 95, 4, 65, 0, 66, 88, 77, 94, 16, 13, 76, 81, 10, 1, 69, 79, 4, 66, 95, 72, 90, 10, 70, 6, 87, 71, 11, 69, 72, 68, 0, 22, 78, 12, 86, 0, 70]
    
    static let ProdAPI_BASE_DOMAIN_URL: [UInt8] = [5, 82, 18, 82, 18, 5, 65, 72, 84, 21, 92, 23, 89, 70, 9, 21, 81, 86, 1, 16, 31, 1, 10, 95, 24, 18, 65]
    
    static let v1: [UInt8] = [77, 94, 19, 91, 17, 13, 72, 4, 76, 72, 70, 93, 95, 28, 19, 80]
}

public class DevSdkConfig{
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.DevAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)\(v1)"
    public static let API_TYPE=4
}

public class TestSdkConfig{
    
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.TestAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)\(v1)"
    public static let API_TYPE=3
}

public class PilotSdkConfig{
    
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.PilotAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)\(v1)"
    public static let API_TYPE=2
}

public class ProdSdkConfig{
    
    public static let API_BASE_DOMAIN_URL = Obfuscator().reveal(key: ObfsctfConstants.ProdAPI_BASE_DOMAIN_URL)
    public static let API_BASE_PATH="\(https)\(API_BASE_DOMAIN_URL)\(v1)"
    public static let API_TYPE=1
}
