//
//  FormatUtil.swift
//  MultiU
//
//  Created by  on 25/05/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation

class FormatUtil
{
    struct Constants
    {
        static let maskDefinition = Character("*")
        static let definitions: [Character: CharacterSet] = [
            "9": NSMutableCharacterSet.numericCharacterSet() as CharacterSet,
            "a": NSMutableCharacterSet.legalLetterCharacterSetWithoutTurkishLetters() as CharacterSet,
            "?": NSMutableCharacterSet.legalAlphanumericCharacterSetWithoutTurkishLetters() as CharacterSet
        ]
        
        static let numberFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = "."
            return formatter
        }()
        
        static let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter
        }()
        
        static let dateTimeFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            return formatter
        }()
        
        static let timeFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter
        }()
        
        static let doubleFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.decimal
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = "."
            formatter.maximumFractionDigits = 2
            formatter.roundingMode = NumberFormatter.RoundingMode.down
            return formatter
        }()
        
        static let amountFormatter: NumberFormatter = {
            var formatter = NumberFormatter()
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.maximumFractionDigits = 2
            formatter.currencySymbol = ""
            formatter.currencyDecimalSeparator = ","
            formatter.currencyGroupingSeparator = "."
            formatter.roundingMode = NumberFormatter.RoundingMode.down
            return formatter
        }()
        
        struct LicensePlate {
            static let minLength = 7
            static let maxLength = 8
            static let part0ExactLength = 2
            static let part1MaxLength = 3
            static let part2MaxLength = 5
        }
    }
    
    fileprivate class func getTemplateElements(_ template: String) -> [TemplateElement] {
        var templateElements: [TemplateElement] = []
        for char in template {
            if char == TemplateElement.Constants.seperatorPredecessor {
                templateElements.append(TemplateElement(char: nil, elementType: .separator))
            } else if char == TemplateElement.Constants.maskedPredecessor {
                templateElements.append(TemplateElement(char: nil, elementType: nil, isMasked: true))
            } else {
                if (templateElements.last != nil && templateElements.last!.char == nil) {
                    templateElements.last!.char = char
                } else {
                    templateElements.append(TemplateElement(char: char, elementType: nil))
                }
                
                if (templateElements.last != nil && templateElements.last!.elementType == nil) {
                    if Constants.definitions[char] == nil {
                        templateElements.last!.elementType = .constant
                    } else {
                        templateElements.last!.elementType = .definition
                    }
                }
            }
        }
        return templateElements
    }
    
    fileprivate class func isCharMatched(_ char: Character, definition: CharacterSet) -> Bool {
        return String(char).components(separatedBy: definition).joined(separator: "").isEmpty
        
    }
    
    class func format(_ text: String?, template: String, isMasked: Bool = false) -> String? {
        if text == nil || text!.isEmpty {
            return text
        }
        
        let templateElements = getTemplateElements(template)
        var templateElementIndex = templateElements.startIndex
        var textIndex = text!.startIndex
        var formattedText = ""
        
        /*
         gelen text içinde imleç barındırıyorsa imlecin pozisyonu korunur
         her text karakteri için şablonda arama yapılır
         şablonda sıradaki karakter bir sabit ya da ayraç ise formatlanmış texte eklenir
         şablonda sıradaki karater bir definition ise text içinde uygun karakter bulunana kadar aranır
         */
        
        while textIndex < text!.endIndex {
            // sıradaki karakter cursor ise ekle ve atla
            if text![textIndex] == "|" {
                formattedText.append(text![textIndex])
                textIndex = (text?.index(after: textIndex))!
                continue
            }
            
            while templateElementIndex < templateElements.endIndex {
                if let definition = Constants.definitions[templateElements[templateElementIndex].char!] {
                    // sıradaki karakter bir definition ise
                    if isCharMatched(text![textIndex], definition: definition as CharacterSet) || text![textIndex] == Constants.maskDefinition {
                        formattedText.append(isMasked && templateElements[templateElementIndex].isMasked ? Constants.maskDefinition : text![textIndex])
                        templateElementIndex += 1
                    }
                    break // bir sonraki textChar
                } else {
                    // sıradaki karakter bir definition değil ise (seperator ya da constant)
                    formattedText.append(templateElements[templateElementIndex].char!)
                    if text![textIndex] == templateElements[templateElementIndex].char! {
                        templateElementIndex += 1
                        break // bir sonraki textChar
                    }
                }
                templateElementIndex += 1
            }
            textIndex = (text?.index(after: textIndex))!
        }
        
        return formattedText
    }
    
    class func clear(_ text: String?, template: String) -> String? {
        if text == nil || text!.isEmpty {
            return text
        }
        
        let templateElements = getTemplateElements(template)
        var clearedText = ""
        var textIndex = text!.startIndex
        
        for templateElement in templateElements {
            if textIndex == text!.endIndex {
                break
            }
            
            if templateElement.elementType != TemplateElement.ElementType.separator {
                clearedText.append(text![textIndex])
            }
            textIndex = (text?.index(after: textIndex))!
            
        }
        
        return clearedText
    }
    
    class func clear(_ text: String?, chars: [Character]) -> String? {
        if (text == nil) {
            return text
        }
        
        var text = text
        for char in chars {
            text = text!.replacingOccurrences(of: String(char), with: "")
        }
        
        return text
    }
    
    class func formatNumber(_ number: Double?, precision: Int = 0) -> String? {
        if number == nil {
            return nil
        }
        
        let formatter = Constants.numberFormatter
        formatter.minimumFractionDigits = precision
        formatter.maximumFractionDigits = precision
        return formatter.string(from: number! as NSNumber)
    }
    
    class func clearNumber(_ text: String?) -> Double? {
        if text == nil {
            return nil
        }
        
        let formatter = Constants.numberFormatter
        if let number = formatter.number(from: text!) {
            return Double(truncating: number)
        } else {
            return nil
        }
    }
    
    class func formatNumber(_ text: String?, cursorPosition: inout Int) -> String? {
        if text == nil || text!.isEmpty {
            return text
        }
        
        var number = ""
        /* use 'text!' instead of 'text!.characters' */
        for char in text! {
            if char == "." {
                cursorPosition -= 1
            } else {
                number.append(char)
            }
        }
        
        if number.count <= 3 {
            return number
        }
        
        var dotCount = number.count / 3
        if number.count % 3 == 0 {
            dotCount -= 1
        }
        
        var remainingCharCount = number.count % 3
        if remainingCharCount == 0 {
            remainingCharCount = 3
        }
        
        var formattedText = ""
        for i in 0 ..< dotCount {
       /* (Old Format)
        formattedText = "." + number.substring(with: Range<String.Index>(number.index(number.endIndex, offsetBy: (i+1) * -3) ..< number.characters.index(number.endIndex, offsetBy: i * -3))) + formattedText */
            
         /* Range.init(start:end:) constructor was removed in Swift 3.0 */
            let range = number.index(number.startIndex, offsetBy: (i+1) * -3)..<number.index(number.startIndex, offsetBy: i * -3)
         /* which returns a half-open range of type <String.Index> */
            formattedText = "." + number[range] + formattedText
            cursorPosition += 1
        }
        // before swift 5 - formattedText = number.substring(to: number.index(number.startIndex, offsetBy: remainingCharCount)) + formattedText
        formattedText = number[...number.index(number.startIndex, offsetBy: remainingCharCount)] + formattedText

        return formattedText
    }
    
    class func stringFromDate(_ date: Date?, withTime: Bool = false, onlyTime: Bool = false) -> String? {
        if date == nil {
            return nil
        }
        
        let formatter = withTime ? (onlyTime ? Constants.timeFormatter : Constants.dateTimeFormatter) : Constants.dateFormatter
        return formatter.string(from: date!)
    }
    
    class func dateFromString(_ string: String?) -> Date? {
        if string == nil {
            return nil
        }
        
        let formatter = Constants.dateFormatter
        return formatter.date(from: string!)
    }
    
    class func dayOfWeekFromDate(_ date: Date?) -> String? {
        if date == nil {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: CoreManager.shared.language)
        formatter.dateFormat = "EEEE"
        
        return formatter.string(from: date!)
    }
    
    class func stringWithDayOfWeekFromDate(_ date: Date?) -> String? {
        if date == nil {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: CoreManager.shared.language)
        formatter.dateFormat = "EEEE dd/MM/yyyy"
        
        return formatter.string(from: date!)
    }
    
    class func stringFromAmount(_ amount: Double?, currencyCode: String?) -> String? {
        if amount == nil || currencyCode == nil {
            return nil
        }
        
        let formatter = Constants.amountFormatter
        let string = "\(formatter.string(from: amount! as NSNumber)!) \(currencyCode!)"
        return string
    }
    
    class func amountFromString(_ text: String?, precision: Int? = nil) -> Double? {
        if text == nil {
            return nil
        }
        
        let formatter = Constants.amountFormatter
        if precision != nil{
            formatter.maximumFractionDigits = precision!
        }
        if let number = formatter.number(from: text!) {
            return Double(truncating: number)
        } else {
            return nil
        }
    }
    
    class func stringFromDouble(_ double: Double?, precision: Int? = nil) -> String? {
        if double == nil {
            return nil
        }
        
        let formatter = Constants.doubleFormatter
        if let precision = precision {
            formatter.minimumFractionDigits = precision
            formatter.maximumFractionDigits = precision
        }
        return formatter.string(from: double! as NSNumber)
    }
    
    
    class func stringFromDoubleWithRoundingMode(_ double: Double?, roundingMode: NumberFormatter.RoundingMode!, precision: Int? = nil) -> String? {
        if double == nil {
            return nil
        }
        
        let formatter = Constants.doubleFormatter
        
        formatter.roundingMode = roundingMode
        
        if let precision = precision {
            formatter.minimumFractionDigits = precision
            formatter.maximumFractionDigits = precision
        }
        return formatter.string(from: double! as NSNumber)
    }
    
    class func doubleFromString(_ string: String?) -> Double? {
        if string == nil {
            return nil
        }
        
        let formatter = Constants.doubleFormatter
        
        // remove grouping seperator character from string before conversion to handle strings like "1.2345"
        if let double = formatter.number(from: string!.replacingOccurrences(of: formatter.groupingSeparator!, with: "")) {
            return Double(truncating: double)
        } else {
            return nil
        }
    }
    
    class func removeTurkishChars(_ string: String?) -> String? {
        
        if string == nil {
            return nil
        }
        var modifiedString = string
        
        let turkishChars = ["ı", "İ", "ş", "Ş", "ğ", "Ğ", "ü", "Ü", "ö", "Ö", "ç", "Ç"]
        let replaceChars = ["i", "I", "s", "S", "g", "G", "u", "U", "o", "O", "c", "C"]
        
        for (index,char) in turkishChars.enumerated() {
            modifiedString = modifiedString?.replacingOccurrences(of: char, with: replaceChars[index])
        }
        
        return modifiedString
    }
    
//    class func seperateLicensePlate(licensePlate: String) -> (part0: String?, part1: String?, part2: String?) {
//        // plaka 7 ya da 8 karakter olabilir
//        if Constants.LicensePlate.minLength <= licensePlate.characters.count && licensePlate.characters.count <= Constants.LicensePlate.maxLength {
//            
//            // ilk 2 hanesi rakamlardan oluşmalıdır
//            var i = licensePlate.startIndex
//            var part0 = ""
//            while i < licensePlate.startIndex.advancedBy(Constants.LicensePlate.part0ExactLength) {
//                if licensePlate[i].isDigit {
//                    part0 += String(licensePlate[i])
//                } else {
//                    return (nil, nil, nil)
//                }
//                i = i.successor()
//            }
//            
//            // harfler sırayla alınıyor
//            var part1 = ""
//            while i < licensePlate.endIndex {
//                if licensePlate[i].isLetter {
//                    part1 += String(licensePlate[i])
//                } else {
//                    break
//                }
//                i = i.successor()
//            }
//            
//            // harf alanı en az 1 en fazla 3 karakterden oluşabilir
//            if part1.characters.count == 0 || part1.characters.count > Constants.LicensePlate.part1MaxLength {
//                return (nil, nil, nil)
//            }
//            
//            // son kısımdaki rakamlar sırayla alınıyor
//            var part2 = ""
//            while i < licensePlate.endIndex {
//                if licensePlate[i].isDigit {
//                    part2 += String(licensePlate[i])
//                } else {
//                    // bu kısımda artık harf beklenmiyor
//                    return (nil, nil, nil)
//                }
//                i = i.successor()
//            }
//            
//            return (part0, part1, part2)
//        }
//        
//        return (nil, nil, nil)
//    }
}
