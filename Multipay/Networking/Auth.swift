//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import UIKit

class Auth {
    
    private init() { }
    static let shared = Auth()
    static let sharedInstance = Auth.shared
    
    
    let defaults = UserDefaults.standard
    static let defaultsKey = "MY-API-KEY"

    
    static var authToken: String?
    static var referenceNumber: String?
    static var walletToken: String?
    internal static var appToken: String?
    internal static var obfuscationSalt: String?
    static let isOnlyWalletTokenEnoughForAuthentication = true
    static var userPreset: UserPreset?
    
    
    let headerInstance = Header.sharedInstance
    
    open func getHeader() -> HeaderType{
    
        return headerInstance.getHeader()
    }
    
    //MARK: Login and logout
    
  func logout() {
    Auth.authToken = nil
  }
}
