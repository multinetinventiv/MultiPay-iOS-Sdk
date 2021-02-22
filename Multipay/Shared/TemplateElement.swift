//
//  TemplateElement.swift
//  MultiU
//
//  Created by  on 25/05/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

class TemplateElement {
    
    struct Constants {
        static let seperatorPredecessor: Character = "~"
        static let maskedPredecessor: Character = "*"
    }
    
    enum ElementType {
        case separator
        case constant
        case definition
    }
    
    var char: Character?
    
    var elementType: ElementType?
    
    var isMasked: Bool
    
    init(char: Character?, elementType: ElementType?, isMasked: Bool = false) {
        self.char = char
        self.elementType = elementType
        self.isMasked = isMasked
    }
}
