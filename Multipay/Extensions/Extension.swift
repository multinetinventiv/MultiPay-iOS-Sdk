//
//  MultipayManager.swift
//  Multipay
//
//  Created by ilker sevim on 3.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

protocol ClassIdentifier {
    
    static func getIdentifier() -> String
}

//MARK: - EXTENSION STRING
extension String{
    
    func formatAmountToDisplay(symbol:String? = nil, isDigits:Bool? = true) -> String {
     
        let amount = Double(self)!
        let formattedAmount = formatCurrency(value: amount, symbol: symbol, isDigits:isDigits)
        
        if (symbol != nil) {
            return formattedAmount + symbol!
        }else{
            return formattedAmount
        }
    }
    
    func formatCurrency(value: Double, symbol:String? = nil, isDigits:Bool? = true) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.maximumFractionDigits = (isDigits == true ? 2 : 0)
        formatter.locale = Locale(identifier: CoreManager.getLocaleIdentifier())
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    
    var local : String {
        return Localization.getLocalizedString(self)
    }
    
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    var length: Int {
        return self.count
    }
    
    func contains(_ text: String, caseInSensitive : Bool? = true) -> Bool{

        var option : NSString.CompareOptions = NSString.CompareOptions.caseInsensitive

        if !caseInSensitive!{
            option = NSString.CompareOptions.literal
        }

        if self.range(of: text, options: option, range: nil, locale: nil) != nil{
            return true
        }

        return false
    }
    
    func textWidth(_ font: UIFont) -> CGFloat {
        
        
        let label = UILabel()
        label.text = self
        label.font = font
        label.sizeToFit()
        let frame = label.frame
        return frame.width
    }
    
    func NSRangeFromRange(_ range : Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)!
        return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to:from), utf16view.distance(from: from, to: to))
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func capitalizedStringWithLocaleIdentifier() -> String{
        
        //i karakterinden yaşanan sıkıntıdan dolayı eklendi.
        return self.capitalized(with: Locale(identifier: CoreManager.getLocaleIdentifier()))
    }
    
    
    
    func clearNonNumeric() -> String {
        return  self.replacingOccurrences(of: "[^0-9]", with: "", options: NSString.CompareOptions.regularExpression, range:nil)
    }
    
    func isContainsLetterChars() -> Bool {
        
        let letters = CharacterSet.letters
        let range = self.rangeOfCharacter(from: letters)
        
        if let _ = range {
            return true
        }
        return false
    }
    
    
    
    func insert(_ string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    
    
    
    func getGsmNumber() -> String
    {
        
        var gsm = ""
        let emailText = self
        let isEmail = emailText.length > 0 && emailText.isContainsLetterChars()
        
        if(!isEmail) {
            gsm = emailText.clearNonNumeric()
            if(emailText.hasPrefix("0")) {
                gsm = (emailText as NSString).substring(from: 1)
            }
        }
        return gsm
    }
    //MARK: Validation
    
    func codeFormat() -> String {
        let newStr = NSMutableString()
        for i in 0..<self.count {
            if (i > 0 && i % 4 == 0){
                newStr.append(" ")
            }
            var c = (self as NSString).character(at: i)
            newStr.append(NSString(characters: &c, length: 1) as String)
        }
        return newStr as String
    }
    
    func validateEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func validatePhoneNumber() -> Bool {
        
        var clearPhone = self.removeWhitespace().clearNonNumeric()
        
        
        if(clearPhone.hasPrefix("0")) {
            clearPhone = (clearPhone as NSString).substring(from: 1)
        }
        let valid  = NSPredicate(format: "SELF MATCHES %@", Regex.kGSM).evaluate(with: clearPhone)
        return valid
    }
    
    func validatePassword() -> Bool {
        
        var valid  = false
        let valid1 = NSPredicate(format: "SELF MATCHES %@", Regex.kPassword1).evaluate(with: self)
        let valid2 = NSPredicate(format: "SELF MATCHES %@", Regex.kPassword2).evaluate(with: self)
        
        valid = valid1 || valid2
        
        if (valid)
        {
            valid  = NSPredicate(format: "SELF MATCHES %@", Regex.kPassword3).evaluate(with: self)
        }else
        {
            return valid
        }
        
        
        if (valid) {
            
            valid = self.count >= Regex.kPasswordMin &&  self.count <=  Regex.kPasswordMax
        }
        
        
        return valid
        
    }
    
    //MARK: Format
    
    
    func formatAmount(_ currency:String) -> String {
        var formattedAmount = ""
        formattedAmount = currency + self + ",00"
        return formattedAmount
    }
    
    var asLocaleCurrency:String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        
        return formatter.string( from: (Double(self)! / 100) as NSNumber)!
        
        
        //        let formatter = NSNumberFormatter()
        //        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        //        formatter.locale = NSLocale(localeIdentifier: "en_MY")
        //        let numberFromField = (NSString(string: currentString).doubleValue)/100
        //        self.amountField.text = formatter.stringFromNumber(numberFromField)
    }
    
    var asLocaleCurrencyForTextInput:String {
        
        var tmp = self
        
        if tmp.contains(",") {
            tmp = tmp.replacingOccurrences(of: ",", with: ".")
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        
        return formatter.string( from: Double(tmp)! as NSNumber)!
    }
    
    
    func mask(_ from:Int,to:Int) -> String {
        
        let myNSString = self as NSString
        let maskable =   myNSString.substring(with: NSRange(location: from, length: to))
        return self.replace(maskable, replacement: "*****")
    }
    
    
    func remove(_ string:String) -> String {
        return self.replace(string, replacement: "")
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
    func removeLineBreaksWithReturnChar() ->String {
        
        return self.replacingOccurrences(of: "\r\n", with: "")
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }

    subscript(value: NSRange) -> String {
        self[value.lowerBound..<value.upperBound]
    }

    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }

    var htmlAttributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }

    func htmlAttributed(withRegularFont regularFont: UIFont, andBoldFont boldFont: UIFont) -> NSMutableAttributedString {
        var attributedString = NSMutableAttributedString()
            guard let data = self.data(using: .utf8) else { return NSMutableAttributedString() }
            do {
                attributedString = try NSMutableAttributedString(data: data,
                                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                                           .characterEncoding:String.Encoding.utf8.rawValue],
                                                                 documentAttributes: nil)
                let range = NSRange(location: 0, length: attributedString.length)
                attributedString.enumerateAttribute(NSAttributedString.Key.font, in: range, options: .longestEffectiveRangeNotRequired) { value, range, _ in
                    let currentFont: UIFont         = value as! UIFont
                    var replacementFont: UIFont?    = nil

                    if currentFont.fontName.contains("bold") || currentFont.fontName.contains("Bold") {
                        replacementFont             =   boldFont
                    } else {
                        replacementFont             =   regularFont
                    }

                    let replacementAttribute        =   [NSAttributedString.Key.font:replacementFont!]
                    attributedString.addAttributes(replacementAttribute, range: range)
                }
            } catch let e {
                print(e.localizedDescription)
            }
           return attributedString
    }
}

//MARK: - STRING.INDEX
extension String.Index{
    func successor(in string:String)->String.Index{
        return string.index(after: self)
    }
    
    func predecessor(in string:String)->String.Index{
        return string.index(before: self)
    }
    
    func advance(_ offset:Int, `for` string:String)->String.Index{
        return string.index(self, offsetBy: offset)
    }
    
}

//MARK: - EXTENSION NSMutableCharacterSet
extension NSMutableCharacterSet {
    class func legalLetterCharacterSet() -> NSMutableCharacterSet {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: legalLetterCharacterSetWithoutTurkishLetters() as CharacterSet)
        characterSet.formUnion(with: specialTurkishLetterCharacterSet() as CharacterSet)
        return characterSet
    }
    
    class func legalLetterCharacterSetWithoutTurkishLetters() -> NSMutableCharacterSet {
        return NSMutableCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
    }
    
    class func specialTurkishLetterCharacterSet() -> NSMutableCharacterSet {
        return NSMutableCharacterSet(charactersIn: "ÇĞİÖŞÜçğıöşü")
    }
    
    class func numericCharacterSet() -> NSMutableCharacterSet {
        return NSMutableCharacterSet(charactersIn: "0123456789")
    }
    
    class func legalPunctuationCharacterSet() -> NSMutableCharacterSet {
        return NSMutableCharacterSet(charactersIn: "-_?!.,:@()&/=*")
    }
    
    class func legalWhiteSpaceCharacterSet() -> NSMutableCharacterSet {
        return NSMutableCharacterSet(charactersIn: " ")
    }
    
    class func legalCharacterSet() -> NSMutableCharacterSet {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: legalLetterCharacterSet() as CharacterSet)
        characterSet.formUnion(with: numericCharacterSet() as CharacterSet)
        characterSet.formUnion(with: legalPunctuationCharacterSet() as CharacterSet)
        characterSet.formUnion(with: legalWhiteSpaceCharacterSet() as CharacterSet)
        return characterSet
    }
    
    class func legalAlphanumericCharacterSet() -> NSMutableCharacterSet {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: legalLetterCharacterSet() as CharacterSet)
        characterSet.formUnion(with: numericCharacterSet() as CharacterSet)
        return characterSet
    }
    
    class func legalAlphanumericCharacterSetWithoutTurkishLetters() -> NSMutableCharacterSet {
        let characterSet = NSMutableCharacterSet()
        characterSet.formUnion(with: legalLetterCharacterSetWithoutTurkishLetters() as CharacterSet)
        characterSet.formUnion(with: numericCharacterSet() as CharacterSet)
        return characterSet
    }
    
}

private protocol Mergable {
    func mergeWithSame<T>(_ right: T) -> T?
}



public extension Dictionary {
    
    /**
     Merge Dictionaries
     
     - Parameter left: Dictionary to update
     - Parameter right:  Source dictionary with values to be merged
     
     - Returns: Merged dictionay
     */
    
    
    func merge(_ right:Dictionary) -> Dictionary {
        var merged = self
        for (k, rv) in right {
            
            // case of existing left value
            if let lv = self[k] {
                
                if let lv = lv as? Mergable, type(of: lv) == type(of: rv) {
                    let m = lv.mergeWithSame(rv)
                    merged[k] = m
                }
                    
                else if lv is Mergable {
                    assert(false, "Expected common type for matching keys!")
                }
                    
                else if !(lv is Mergable), let _ = lv as? NSArray {
                    assert(false, "Dictionary literals use incompatible Foundation Types")
                }
                    
                else if !(lv is Mergable), let _ = lv as? NSDictionary {
                    assert(false, "Dictionary literals use incompatible Foundation Types")
                }
                    
                else {
                    merged[k] = rv
                }
            }
                
                // case of no existing value
            else {
                merged[k] = rv
            }
        }
        
        return merged
    }
}


extension UIDevice {
    
    var modelName: String {
        
        let DEVICE_IS_SIMULATOR:Bool?
        
        #if targetEnvironment(simulator)
            DEVICE_IS_SIMULATOR = true
        #else
            DEVICE_IS_SIMULATOR = false
        #endif
        
        var machineString : String = ""
        
        if DEVICE_IS_SIMULATOR == true
        {
            
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                machineString = dir
            }
            
        }else {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            machineString = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        }
        return machineString
    }
}



extension UIImage {
    func resize(_ scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    func resizeToWidth(_ width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func sizeImageTo(_ targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func toBase64() -> String{
        let imageData = self.pngData()!
        //return imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
    func myfixOrientation() -> UIImage {
        
        
        // No-op if the orientation is already correct
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity
        
        if (self.imageOrientation == UIImage.Orientation.down
            || self.imageOrientation == UIImage.Orientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if (self.imageOrientation == UIImage.Orientation.left
            || self.imageOrientation == UIImage.Orientation.leftMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }
        
        if (self.imageOrientation == UIImage.Orientation.right
            || self.imageOrientation == UIImage.Orientation.rightMirrored) {
            
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-(Double.pi / 2)));
        }
        
        if (self.imageOrientation == UIImage.Orientation.upMirrored
            || self.imageOrientation == UIImage.Orientation.downMirrored) {
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if (self.imageOrientation == UIImage.Orientation.leftMirrored
            || self.imageOrientation == UIImage.Orientation.rightMirrored) {
            
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx:CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                                     bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                                     space: self.cgImage!.colorSpace!,
                                                     bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!
        
        
        ctx.concatenate(transform)
        
        
        if (self.imageOrientation == UIImage.Orientation.left
            || self.imageOrientation == UIImage.Orientation.leftMirrored
            || self.imageOrientation == UIImage.Orientation.right
            || self.imageOrientation == UIImage.Orientation.rightMirrored
            ) {
            
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)
        
        return imgEnd
    }
}


extension Double {
    var asLocaleCurrency:String {
        let formatter = NumberFormatter()
        //formatter.numberStyle = .CurrencyStyle //amount + currency
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        formatter.locale = Locale.current
        return formatter.string(from: self as NSNumber)!
    }
    
    mutating func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

extension Int {
    
    func toBool () -> Bool {
        
        switch self {
        case 1:
            return true
            
        default:
            return false
            
        }
        
    }
    
}



extension UIImage {
    
    fileprivate func convertToGrayScaleNoAlpha() -> CGImage {
        let colorSpace = CGColorSpaceCreateDeviceGray();
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context!.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return context!.makeImage()!
    }
    
    
    /**
     Return a new image in shades of gray + alpha
     */
    //    func convertToGrayScale() -> UIImage {
    //        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Only.rawValue)
    //        let context = CGBitmapContextCreate(nil, Int(size.width), Int(size.height), 8, 0, nil, bitmapInfo.rawValue)
    //        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);
    //        let mask = CGBitmapContextCreateImage(context)
    //        return UIImage(CGImage: CGImageCreateWithMask(convertToGrayScaleNoAlpha(), mask)!, scale: scale, orientation:imageOrientation)
    //    }
}


extension UIView {
    
    fileprivate func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        
        if CoreManager.systemVersionLessThanIOS10() {
            
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            
        }
        
    }
    
    func roundViewsTop(_ radius: CGFloat){
        
        self.roundCorners([.topLeft, .topRight], radius: radius)
    }
    
    func roundAllCorners(_ radius: CGFloat){
       // self.roundCorners([.TopLeft, .TopRight, .BottomLeft, .BottomRight], radius: radius)
       self.layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func layerGradient4MerchantDetail() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint.zero
        
        let color0 = ColorPalette.RGBA(255, green: 255, blue: 255, alpa: 1).cgColor
        let color1 = ColorPalette.RGBA(220, green: 220, blue: 220, alpa: 1).cgColor
        
        
        
        layer.colors = [color0,color1]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint.zero
        
        let color0 = ColorPalette.RGBA(2, green: 17, blue: 65, alpa: 1).cgColor
        let color1 = ColorPalette.RGBA(2, green: 18, blue: 70, alpa: 1).cgColor
        let color2 = ColorPalette.RGBA(14, green: 30, blue: 99, alpa: 1).cgColor
        let color3 = ColorPalette.RGBA(28, green: 40, blue: 121, alpa: 1).cgColor
        let color4 = ColorPalette.RGBA(55, green: 47, blue: 125, alpa: 1).cgColor
        let color5 = ColorPalette.RGBA(33, green: 25, blue: 80, alpa: 1).cgColor
        let color6 = ColorPalette.RGBA(19, green: 17, blue: 60, alpa: 1).cgColor
        let color7 = ColorPalette.RGBA(12, green: 12, blue: 47, alpa: 1).cgColor
        
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6,color7]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func layerGradient4CardAdd() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint.zero
        
        let color0 = ColorPalette.RGBA(19, green: 30, blue: 69, alpa: 1).cgColor
        let color1 = ColorPalette.RGBA(24, green: 36, blue: 82, alpa: 1).cgColor
        let color2 = ColorPalette.RGBA(38, green: 49, blue: 103, alpa: 1).cgColor
        let color3 = ColorPalette.RGBA(45, green: 50, blue: 118, alpa: 1).cgColor
        let color4 = ColorPalette.RGBA(48, green: 44, blue: 109, alpa: 1).cgColor
        let color5 = ColorPalette.RGBA(46, green: 40, blue: 97, alpa: 1).cgColor
        let color6 = ColorPalette.RGBA(40, green: 34, blue: 83, alpa: 1).cgColor
        let color7 = ColorPalette.RGBA(41, green: 39, blue: 89, alpa: 1).cgColor
        
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6,color7]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func cardSuccessGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint.zero
        
        let color0 = ColorPalette.RGBA(44, green: 57, blue: 72, alpa: 1).cgColor
        let color1 = ColorPalette.RGBA(60, green: 75, blue: 85, alpa: 1).cgColor
        let color2 = ColorPalette.RGBA(117, green: 138, blue: 133, alpa: 1).cgColor
        let color3 = ColorPalette.RGBA(153, green: 159, blue: 159, alpa: 1).cgColor
        let color4 = ColorPalette.RGBA(212, green: 215, blue: 219, alpa: 1).cgColor
        let color5 = ColorPalette.RGBA(218, green: 219, blue: 224, alpa: 1).cgColor
        let color6 = ColorPalette.RGBA(215, green: 216, blue: 220, alpa: 1).cgColor
        
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func cardBlockedGradient(message: String, textColor: UIColor, fontSize: Int, backgroundColor: UIColor = ColorPalette.darkishPink){
        
        self.backgroundColor = backgroundColor
        
        let warnLabel = UILabel()
        warnLabel.textAlignment = .center
        warnLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(warnLabel)
        warnLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        warnLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        warnLabel.textColor = textColor
        warnLabel.text = message
        warnLabel.font = FontHelper.TextFont
        
        layer.cornerRadius = 4.0
        
        let gradientMask = CAGradientLayer()
        gradientMask.startPoint = CGPoint(x:0.0,y: 0.5)
        gradientMask.endPoint = CGPoint(x:1.0,y: 0.5)

        let lightColor = UIColor.white

        gradientMask.colors = [lightColor.withAlphaComponent(0.0).cgColor,
                       lightColor.withAlphaComponent(0.3).cgColor,
                       lightColor.withAlphaComponent(0.8).cgColor,
                       lightColor.withAlphaComponent(0.3).cgColor,
                       lightColor.withAlphaComponent(0.0).cgColor]
        gradientMask.locations = [NSNumber(value: 0.0),NSNumber(value: 0.1), NSNumber(value:0.5), NSNumber(value: 0.9),NSNumber(value: 1.0)]
        gradientMask.frame = CGRect(x: 40, y: 0, width: self.width - 80, height: 40)
        layer.mask = gradientMask
    }
    
    func addConstraints(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: self.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1, constant: 0)
        
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        topConstraint.isActive = true
        bottomConstraint.isActive = true
        
        self.superview?.addConstraint(leadingConstraint)
        self.superview?.addConstraint(trailingConstraint)
        self.superview?.addConstraint(topConstraint)
        self.superview?.addConstraint(bottomConstraint)
    }
    
    
    func constraintForIdentifier(_ identifier: String) -> NSLayoutConstraint?{
        for item in self.constraints {
            if identifier == item.identifier {
                return item
            }
            
        }
        
        return nil
    }
    
    
    func addConstSuperViewHeightEqualToSelf(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self.superview, attribute: .height, multiplier: 1, constant: 0)
        
        height.isActive = true
        self.addConstraint(height)
    }
    
    
    func heightConstraintSetToZero(){
        
        for constraint in self.constraints as [NSLayoutConstraint] {
            if constraint.identifier == "kHeightConstraint" {
                constraint.constant = 0
            }
        }
        
    }
    
    func heightConstraintSetTo(_ constant: CGFloat){
        
        for constraint in self.constraints as [NSLayoutConstraint] {
            if constraint.identifier == "kHeightConstraint" {
                constraint.constant = constant
            }
        }
        
    }
    
}

extension UIView{
    
    func getPosition(_ inView: UIView) -> CGRect{
        
        return  self.convert(self.bounds, to: inView)
    }
    
    
    
}

extension UILabel{
    
    func setFont(_ font: UIFont, range: NSRange?) {
        guard let range = range else { return }
        let text = mutableAttributedString()
        text.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedText = text
    }
    
    func setFont(_ font: UIFont, string: String) {
        setFont(font, range: rangeOf(string))
    }
    
    func rangeOf(_ string: String) -> NSRange? {
        let range = NSString(string: text ?? "").range(of: string)
        return range.location != NSNotFound ? range : nil
    }
    
    fileprivate func mutableAttributedString() -> NSMutableAttributedString {
        if attributedText != nil {
            return NSMutableAttributedString(attributedString: attributedText!)
        } else {
            return NSMutableAttributedString(string: text ?? "")
        }
    }
    
}


extension UIView{
    
    func addShadow(){
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6
    }
    
    
}


extension UIViewController{
    
    
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    
    //    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
    //        let tracker = GAI.sharedInstance().defaultTracker
    //        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
    //        tracker.send(trackDictionary.build() as [NSObject : AnyObject])
    //    }
    
    class func topMostViewController() -> UIViewController? {
        return UIViewController.topViewControllerForRoot(UIApplication.shared.keyWindow?.rootViewController)
    }
    
    class func topViewControllerForRoot(_ rootViewController:UIViewController?) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        
        guard let presented = rootViewController.presentedViewController else {
            return rootViewController
        }
        
        switch presented {
        case is UINavigationController:
            let navigationController:UINavigationController = presented as! UINavigationController
            return UIViewController.topViewControllerForRoot(navigationController.viewControllers.last)
            
        case is UITabBarController:
            let tabBarController:UITabBarController = presented as! UITabBarController
            return UIViewController.topViewControllerForRoot(tabBarController.selectedViewController)
            
        default:
            return UIViewController.topViewControllerForRoot(presented)
        }
    }
    
}


// MARK: - open url, for now we use openUrl because SafariViewController do not open the correct link, it has bug.
extension UIViewController{
    
    func openOnSafari(urlString:String){
        
        if let url = URL(string:urlString){
            
            if #available(iOS 10.0, *) {

                let svc = SFSafariViewController(url: url)

                self.navigationController?.present(svc, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
        }
    }
    
    func openAppStore(urlString: String){
        if let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }
    
}

extension UITableView{
    
    func registerCell<T: UITableViewCell>(_ cellClass: T.Type) where T: ClassIdentifier{
        
        let nib = UINib(nibName: T.getIdentifier(), bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.getIdentifier())
    }
}

extension UICollectionView{
    
    
    func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) where T: ClassIdentifier{
        
        let nib = UINib(nibName: T.getIdentifier(), bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: T.getIdentifier())
        
    }
    
    func registerSection<T: UICollectionReusableView>(_ sectionClass: T.Type) where T: ClassIdentifier{
        
        let nib = UINib(nibName: T.getIdentifier(), bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.getIdentifier())
    }
    
}

extension Date{

    func addDays(_ number: Int) -> Date? {
    
        let today = Date()
        
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: number, to: today, options: [])

    }
    
    func equalOrLessThan(_ dateToCompare: Date) -> Bool {
        
        let order = (Calendar.current as NSCalendar).compare(dateToCompare, to: self,
                                                         toUnitGranularity: .day)
        
        var isEqualTo = false
        
        
        switch order {
        case .orderedSame, .orderedDescending:
            isEqualTo = true
        default:
            isEqualTo = false
        }
    
        return isEqualTo
    }
    
}

//MARK: - Array
extension Array {
    func takeElements(elementCount: Int) -> Array {
        if (elementCount > count) {
            return Array(self[0..<count])
        }
        return Array(self[0..<elementCount])
    }
}

//MARK: - Array Merge Extension
extension Array where Element : Equatable {
    
    public mutating func mergeElements<C : Collection>(newElements: C) where C.Iterator.Element == Element{
        let filteredList = newElements.filter({!self.contains($0)})
        self.append(contentsOf: filteredList)
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

