//
//  PoTermsListResponse.swift
//  Multipay
//
//  Created by ilker sevim on 8.12.2020.
//

import Foundation

public struct Term: Codable {
    
    struct Translation: Codable {
        
        let content: String?
        let updated: String?
        let proofread: Bool?
        let fuzzy: Int?
        
    }
    
    let translation: Translation?
    
    let updated: String?
    let reference: String?
    let created: String?
    let comment: String?
    let term: String?
    let plural: String?
    let tags: [String]?
    let context: String?
    
    func giveTranslation() -> String? {
        return translation?.content
    }
    
}

struct PoTermsListResponse: Codable {
    
    struct Response: Codable {
        
        let status: String?
        let code: String?
        let message: String?
        
    }
    
    let response: Response?
    
    struct Result: Codable {
        
        let terms: [Term]?
        
    }
    
    let result: Result?
    
    func getTranslation(forKey:String) -> String {
        
        var translation = ""
        
        if let result = result{
            result.terms?.forEach({ (term) in
                if term.term == forKey || term.term == forKey.lowercased().replacingOccurrences(of: ".", with: "_") || term.term == forKey.replacingOccurrences(of: ".", with: "_") || term.term == forKey.replacingOccurrences(of: "_", with: ".") || term.term == forKey.lowercased() || term.term == forKey.uppercased(){
                    translation = term.giveTranslation() ?? ""
                }
            })
        }
        
        return translation
    }
    
    func getTranslationInBackground(forKey:String, completion: @escaping (_ translation: String) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var translation = forKey
            
            if let result = result{
                result.terms?.forEach({ (term) in
                    if term.term == forKey || term.term == forKey.lowercased().replacingOccurrences(of: ".", with: "_") || term.term == forKey.replacingOccurrences(of: ".", with: "_") || term.term == forKey.replacingOccurrences(of: "_", with: ".") || term.term == forKey.lowercased() || term.term == forKey.uppercased(){
                        translation = term.giveTranslation() ?? forKey
                    }
                })
            }
            
            DispatchQueue.main.async {
                completion(translation)
            }
        }
    }
    
}
