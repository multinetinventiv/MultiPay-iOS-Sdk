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
    
    
    let headerInstance = Header.sharedInstance
    
    open func getHeader() -> HeaderType{
    
        return headerInstance.getHeader()
    }
    
    //MARK: Login and logout
    
  func logout() {
    Auth.authToken = nil
  }

    /*
  func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    let path = "\(NetworkConstants.baseURLPath)/api/users/login"
    let credentialHeader = HTTPHeader.authorization(username: username, password: password)
    AF.request(path, method: .post, headers: [credentialHeader]).validate().responseDecodable(of: BaseModel.self) { response in
      switch response.result {
      case .success(let token):
        //self.token = token.token
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
    */
}
