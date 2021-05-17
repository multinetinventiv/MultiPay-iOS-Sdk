//
//  UserPreset.swift
//  Multipay
//
//  Created by ilker sevim on 17.05.2021.
//

import Foundation

public struct UserPreset: Codable {
    
    var name: String?
    var surname: String?
    var email: String?
    var gsm: String?
    
    public init(name: String? = nil, surname: String? = nil, email: String? = nil, gsm: String? = nil) {
        self.name = name
        self.surname = surname
        self.email = email
        self.gsm = gsm
    }
}
