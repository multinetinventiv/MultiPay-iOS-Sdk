
import UIKit

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


enum InputFieldType:Int {
    case inputText
    case inputEmail
    case inputPhone
    case inputPassword
    case inputEmailWithPhone
    case inputAmount
    case inputDate
    case inputExpirationDate
    case inputGender
    case inputNumaric
    case inputButton
}


enum InputEditionType {
    case inputEditionTypeWhite
    case inputEditionTypeBlack
    case inputEditionSdk
    case inputEditionSDkAddcard
}



enum TextFieldShouldChangeCharactersInRangeType:Int {
    case notImplemented = 0
    case runningFalse   = 1
    case runningTrue    = 2
   
}


//MARK: InputTextView Delegate Methods
@objc protocol InputTextViewDelegate :class {
    
    @objc optional func inputTextTappedWith(textView:InputTextView)
    @objc optional func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String,textView:InputTextView) -> Int
    
    @objc optional func textFieldDidBeginEditing(_ textField: MTextField,textView:InputTextView?)
    @objc optional func textFieldDidEndEditing(_ textField: MTextField,textView:InputTextView?)
    @objc optional func textFieldShouldReturn(textField: MTextField,textView:InputTextView?)
    @objc optional func textFieldShouldNext(textField: MTextField,textView:InputTextView?)
    
    @objc optional func textFieldChanged(textView:UITextField)
}

//MARK:

class InputTextView: BaseView {
    
    enum ErrorType:Int {
        case empty
        case inValid
        case valid
    }
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var txtInput: MTextField!
    @IBOutlet var lineImageView: UILabel!
    
    @IBOutlet var selectableImageView: UIImageView!
    @IBOutlet var selectableImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var maskButton: UIButton!
    
    
    var tapGesture: UITapGestureRecognizer?
    
    var minimumLength:Int?
    var maximumLength:Int?
    var validRegex:String?
    var errorMessage:String?
    var currency:String?
    var rightView:MTLabel?
    var isActiveTextField = false {
        didSet {
            self.decideMaskButtonVisibility()
            if isActiveTextField{
                addShadows()
            }
            else{
                removeShadows()
            }
        }
    }
    
    var inputToolBar:InputToolBar?
    var inputToolBarType:InputToolBarType?
    var inputFieldType = InputFieldType.inputText
    var isShadowActive = true
    var isBackgroundColorWhite = false
    
    weak var delegate: InputTextViewDelegate?
    
    var shadows:UIView?

    func addShadows(){

        if !self.isShadowActive{
            removeShadows()
            return
        }
        
        shadows = UIView()
        
        var emaiFrame = self.bounds
        emaiFrame.size.width = emaiFrame.size.width
        shadows!.frame = emaiFrame

        shadows!.clipsToBounds = false

        self.addSubview(shadows!)
        
        self.sendSubviewToBack(shadows!)

        let shadowPath0 = UIBezierPath(roundedRect: shadows!.bounds, cornerRadius: 0)

        let layer0 = CALayer()

        layer0.shadowPath = shadowPath0.cgPath

        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor

        layer0.shadowOpacity = 1

        layer0.shadowRadius = 5

        layer0.shadowOffset = CGSize(width: 0, height: 1)

        layer0.bounds = shadows!.bounds

        layer0.position = shadows!.center

        shadows!.layer.addSublayer(layer0)


        let shadowPath1 = UIBezierPath(roundedRect: shadows!.bounds, cornerRadius: 0)

        let layer1 = CALayer()

        layer1.shadowPath = shadowPath1.cgPath

        layer1.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).cgColor

        layer1.shadowOpacity = 1

        layer1.shadowRadius = 4

        layer1.shadowOffset = CGSize(width: 0, height: 3)

        layer1.bounds = shadows!.bounds

        layer1.position = shadows!.center

        shadows!.layer.addSublayer(layer1)

        let shadowPath2 = UIBezierPath(roundedRect: shadows!.bounds, cornerRadius: 0)

        let layer2 = CALayer()

        layer2.shadowPath = shadowPath2.cgPath

        layer2.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.14).cgColor

        layer2.shadowOpacity = 1

        layer2.shadowRadius = 4

        layer2.shadowOffset = CGSize(width: 0, height: 2)

        layer2.bounds = shadows!.bounds

        layer2.position = shadows!.center

        shadows!.layer.addSublayer(layer2)
        
    }
    
    func removeShadows(){
        self.shadows?.removeFromSuperview()
        self.shadows = nil
    }
    
    var editionType:InputEditionType? {
        didSet {
            if editionType == InputEditionType.inputEditionSdk
            {
                txtInput.placeHolderColor           = ColorPalette.login.usernamePlaceholderTextColor
                txtInput.selectedPlaceHolderColor   = ColorPalette.login.usernameSelectedPlaceholderTextColor
                txtInput.textColor                  = ColorPalette.login.usernameInputColor
                txtInput.clearButtonColor           = ColorPalette.inputTextView.blackTxtInputClearButtonColor
                txtInput.originalTextColor          = ColorPalette.login.usernameInputColor
                txtInput.lineColor                  = ColorPalette.inputTextView.txtInputLineColor
                txtInput.selectedLineColor          = ColorPalette.inputTextView.txtInputSelectedLineColor
            }
            
            else if editionType == .inputEditionSDkAddcard{
                txtInput.placeHolderColor           = ColorPalette.commonTextColor()
                txtInput.selectedPlaceHolderColor   = ColorPalette.commonTextColor()
                txtInput.textColor                  = ColorPalette.login.usernameInputColor
                txtInput.clearButtonColor           = ColorPalette.inputTextView.blackTxtInputClearButtonColor
                txtInput.originalTextColor          = ColorPalette.login.usernameInputColor
                txtInput.lineColor                  = ColorPalette.inputTextView.txtInputLineColor
                txtInput.selectedLineColor          = UIColor.clear
            }
        }
    }
    
    @objc func togglePasswordVisibility(_ button: UIButton) {
        if self.txtInput.isSecureTextEntry{
            self.maskButton.setBackgroundImage(UIImage(named: "maskButton2", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil), for: .normal)
        }
        else{
            self.maskButton.setBackgroundImage(UIImage(named: "maskButton", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil), for: .normal)
        }
        self.txtInput.isSecureTextEntry = !self.txtInput.isSecureTextEntry
    }
    
    //keyboard type çıkacak
    //MARK: Inizialize View
    func  initView (placeholder:String!,
                    minValu:Int? = nil,
                    maxValue:Int? = 120,
                    tag:Int? = 0,
                    regex:String? = nil ,
                    lastFieldOnForm:Bool = false,
                    delegate:BaseVC,
                    errorMessage:String? = nil,
                    secureField:Bool? = false,
                    textAlignment: NSTextAlignment? = .left,
                    inputFieldType:InputFieldType? = InputFieldType.inputText,
                    editionType:InputEditionType = .inputEditionTypeWhite,
                    toolbarType:InputToolBarType = .done,
                    currency:String? = nil)
    {
        
        
        self.maximumLength = maxValue
        self.minimumLength = minValu
        self.tag = tag!
        self.validRegex = regex
        self.txtInput.placeholder = placeholder
        self.setLastInputOnForm(lastFieldOnForm)
        self.txtInput.parentView = self
        self.txtInput.delegate = self
        self.errorMessage = errorMessage
        self.txtInput.isSecureTextEntry = secureField!
        self.txtInput.textAlignment = textAlignment!
        self.inputToolBarType = toolbarType
        self.delegate =  delegate
        self.currency = currency
        self.inputFieldType = inputFieldType!
        
        if isBackgroundColorWhite{
            self.backgroundView.backgroundColor = .clear
        }
        else{
            self.backgroundView.backgroundColor = ColorPalette.login.inputBackground()
        }
        
        self.txtInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        setupFont()
        setupFieldType()
        setupKeyboardToolBar()
        
        self.maskButton.addTarget(self, action: #selector(InputTextView.togglePasswordVisibility(_:)), for: .touchUpInside)
        
        self.editionType = editionType
        self.txtInput.autocorrectionType = UITextAutocorrectionType.no
        if #available(iOS 10.0, *) {
            self.txtInput.textContentType = UITextContentType(rawValue: "")
        } else {
            // Fallback on earlier versions
        }
       
    
    }
    
    
    func setupFont(_ font:UIFont = FontHelper.inputTextView.font, textFont:UIFont = FontHelper.inputTextView.textFont, textColor:UIColor = ColorPalette.login.usernameInputColor, titleTextColor:UIColor = ColorPalette.inputTextView.titleText) {
        
        txtInput.placeHolderColor = titleTextColor
        txtInput.textColor = textColor
        txtInput.originalTextColor = titleTextColor
        txtInput.font = textFont
    }
    
    private func setupFieldType() {
        
        if(inputFieldType == .inputEmail){
            self.txtInput.keyboardType = .emailAddress
            
        }else if(inputFieldType == .inputPhone || inputFieldType == .inputNumaric) {
            self.txtInput.keyboardType = .numberPad
            
        }else if (inputFieldType == InputFieldType.inputAmount) {
            self.txtInput.keyboardType = .numberPad
            
            rightView = MTLabel(frame: CGRect(x: 0,y: 20, width: 60, height: 30))
            rightView!.sizeToFit()
            rightView!.textColor = ColorPalette.inputTextView.rightView
            rightView!.font = txtInput.font
            rightView!.backgroundColor = ColorPalette.inputTextView.rightViewBG
            rightView!.text = currency
            self.txtInput.rightViewMode  = UITextField.ViewMode.unlessEditing
            self.txtInput.rightView = rightView
            setTextAlignment(NSTextAlignment.right)
            
            txtInput.placeholderAligment(textAlig: NSTextAlignment.left)
            
        }else{
            self.txtInput.keyboardType = .default
        }
        
        self.txtInput.keyboardAppearance = .default
        
       
        if inputFieldType == .inputDate || inputFieldType == .inputGender || inputFieldType == .inputExpirationDate || inputFieldType == .inputButton {
            self.selectableImageViewWidth.constant = 20
            UIView.animate(withDuration: 0.0, animations: {
                self.setNeedsLayout()
            })
            
            self.txtInput.isEnabled = false
            addGestureRecognizer()
        }
        
        
    }
    
    func setupKeyboardToolBar()  {
        
        self.inputToolBar = InputToolBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        self.inputToolBar?.initView(type: self.inputToolBarType)
        
        self.inputToolBar?.completionHandlerNextButton = {
            self.delegate?.textFieldShouldNext?(textField: self.txtInput, textView: self)
        }
        
        self.inputToolBar?.completionHandlerDoneButton = {
            self.delegate?.textFieldShouldReturn!(textField: self.txtInput, textView: self)
        }
        
        txtInput.inputAccessoryView = inputToolBar
        
    }
        
    func placeholderAligment(_ textAlig:NSTextAlignment = .left )  {
        txtInput.placeholderAligment(textAlig: textAlig)
    }
    
    
    //MARK: GET TextValue
    func textValue() -> String{
        
        guard let text = txtInput.text, txtInput.text != nil && txtInput.text?.count > 0 else {
            return ""
        }
        
        
        if  (inputFieldType != .inputDate ){
            return text
        }else{
            let formatter = CoreManager.dateFromatter(formatStr: "dd.MM.yyyy")
            let date = formatter.date(from: text)
            formatter.dateFormat = "yyyyMMdd"
            return formatter.string(from: date!)
        }
    }
    
    //SET TextValue
    func setTextValue(_ string:String?) {
        
        guard let string = string else{
            return
        }
        
        if  (inputFieldType != .inputDate){
            txtInput.text = string
        }else{
            let formatter = CoreManager.dateFromatter(formatStr: "yyyyMMdd")
            let date = formatter.date(from: string)
            formatter.dateFormat = "dd.MM.yyyy"
            txtInput.text = formatter.string(from: date!)
        }
    }
    
    func setTextAlignment(_ textAlignment:NSTextAlignment)  {
        self.txtInput.textAlignment = textAlignment
    }
    
    func setLastInputOnForm(_ lastInput:Bool)  {
        self.txtInput.isLastInform = lastInput
    }

    
    class func height() -> CGFloat {
        return 58.0;
    }
    
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        return txtInput.becomeFirstResponder()
    }
    
    @discardableResult override func resignFirstResponder() -> Bool {
        return txtInput.resignFirstResponder()
    }

    func getErrorMessage() -> String {
        
        
        if let message = self.errorMessage {
            return message
        }else{
            
            if let message = self.txtInput.placeholder {
                return String(format: Localization.ErrorMessage.local, message)
            }else{
                if let message = self.txtInput.placeholder {
                    return String(format: Localization.ErrorMessage.local, message)
                }else{
                    return String(format: Localization.ErrorMessage.local, "FIELD_NAME_NOT_FOUND")
                }
            }
            
        }
    }
    
    
    

    
    //MARK: Button Actions
    
    func buttonClicked() {
        guard let _ = delegate?.inputTextTappedWith?(textView: self)  else {
            return
        }
    }
    
    

    //kalkacak
    @IBAction func textEditingChanged(_ sender: AnyObject) {
        
        //log.debug("text: \(txtInput.text)")
        
        return
        
//        var isValid = true
//        if (InputFieldType.InputPassword == inputFieldType)
//        {
//            isValid = textValue().validatePassword()
//        } else   if (InputFieldType.InputPhone == inputFieldType)
//        {
//            isValid = textValue().validatePhoneNumber()
//        }else if (InputFieldType.InputEmailWithPhome == inputFieldType)
//        {
//            let text  =  textValue()
//            if(text.contains("@") && text.contains(".")){ //email
//                isValid = validate()
//            }else {
//                
//                isValid = text.validatePhoneNumber()
//            }
//            
//        }else {
//            isValid = validate()
//        }
//        
//        txtInput.setErrorMessage(isValid ? "" : txtInput.getFieldTitle())
        
    }
}


//MARK: - Others
extension InputTextView {
    
    func disableTextView() {
        txtInput.isUserInteractionEnabled = false
        txtInput.textColor = UIColor.lightGray
        rightView?.textColor = txtInput.textColor
    }
    
    func hideRightView(_ hide:Bool) {
       
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            DispatchQueue.main.async {
                self.rightView?.isHidden =  hide
            }
        }

    }

    
    func enableTextView() {
        txtInput.isUserInteractionEnabled = true
        txtInput.textColor = UIColor.black
        rightView?.textColor = txtInput.textColor
    }
    
    func addGestureRecognizer() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputTextView.tapped(_:)))
        tapGesture!.cancelsTouchesInView    = false
        self.addGestureRecognizer(tapGesture!)
        
    }
    
    func titleLableColor(_ color:UIColor)  {
        //self.txtInput.titleLabel.textColor = color
        self.txtInput.placeHolderColor = color
    }
    
    @objc func tapped(_ gesture:UITapGestureRecognizer) {
        
        if let dd =  delegate{
            dd.inputTextTappedWith?(textView: self)
        }else{
            return
        }
    }
    
    class func removeSpecialCharsFromString(_ str: String) -> String {
        struct Constants {
            static let validChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890@_.-")
        }
        return String(str.filter { Constants.validChars.contains($0) })
    }

    
    fileprivate func phoneTextCheckerWithEmail(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var text = textField.text
        text = text?.clearNonNumeric()
        if (text?.length > 10 && string != ""){
            return false
        }
        
        if string.contains("|") || string.contains("*") || string.contains("~") {
            return false
        }
        
        textField.replaceNSRange(range: range, withText: string)
        
        // text formatlanır
        textField.textWithCaret = FormatUtil.format(textField.textWithCaret.uppercased(), template: Constants.FormatTemplate.mobilePhoneTemplate)!
        textField.text =  textField.text?.remove("|")
        return false
    }
    
}


//MARK: - TextField Delegate
extension InputTextView:UITextFieldDelegate {
    
    func decideMaskButtonVisibility(){
        if self.textValue().count > 0 && self.inputFieldType == .inputPassword && self.isActiveTextField{
            self.maskButton.isHidden = false
        }
        else{
            self.maskButton.isHidden = true
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        decideMaskButtonVisibility()
        self.delegate?.textFieldChanged?(textView: textField)
    }
    
    //shouldChangeCharactersInRange
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
   
        guard let textFieldShouldChange = delegate?.textField?(textField: textField, shouldChangeCharactersInRange: range, replacementString: string, textView: self), textFieldShouldChange != TextFieldShouldChangeCharactersInRangeType.notImplemented.rawValue else {
           
            if(string == "") {
                return true
            }
            
            if (InputFieldType.inputEmailWithPhone == self.inputFieldType) {
                
                if string.contains("|") || string.contains("*") || string.contains("~") {
                    return false
                }
                
                let str  = InputTextView.removeSpecialCharsFromString(string)
                
                if (str.count == 0) {
                    return false
                }
                
                if (string.isContainsLetterChars() || (textField.text?.isContainsLetterChars())! || string == "@" || string == "_" || string == ".")
                {
                    textField.text =  textField.text?.remove("~").remove("(").remove(")").remove("*").remove("|").remove(" ")
                    textField.replaceNSRange(range: range, withText: string)
                    
                }else{
                    return phoneTextCheckerWithEmail(textField, shouldChangeCharactersInRange: range, replacementString: string)
                }
                
                return false
            }
            
            
            if ( InputFieldType.inputPhone == self.inputFieldType) {
                return phoneTextCheckerWithEmail(textField, shouldChangeCharactersInRange: range, replacementString: string)
            }
            
            if let maxVal = self.maximumLength {
                return textField.text!.count < maxVal
            }
            
            
            return true
            
        }
        
        
        return textFieldShouldChange == TextFieldShouldChangeCharactersInRangeType.runningFalse.rawValue ? false : true
    }
    
    //textFieldDidBeginEditing
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.isActiveTextField = true
        self.txtInput.setErrorMessage(isValid: false)
        
        let mtextField = textField as! MTextField
        delegate?.textFieldDidBeginEditing!(mtextField, textView: self)
        
        self.becomeFirstResponder()
    }
    
    //textFieldDidEndEditing
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.isActiveTextField = false
        let mtextField = textField as! MTextField
        delegate?.textFieldDidEndEditing!(mtextField, textView: self)
        validateWhenExit()
        self.resignFirstResponder()
    }
    
    //textFieldShouldReturn
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let mtextField = textField as! MTextField
        delegate?.textFieldShouldReturn!(textField: mtextField, textView: self)
        return true
    }
    
    internal func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.txtInput.setErrorMessage(isValid: false)
        textField.text = ""
        self.lineImageView.backgroundColor =  UIColor.clear
        decideMaskButtonVisibility()
        self.delegate?.textFieldChanged?(textView: textField)
        return false
    }
    
    //MARK: - Validation
    
    fileprivate func validateWhenExit() {
//        var isValid = true
//        if (InputFieldType.inputPassword == inputFieldType) {
//
//            isValid = textValue().validatePassword()
//
//        }else if (InputFieldType.inputPhone == inputFieldType) {
//
//            isValid = textValue().validatePhoneNumber()
//
//        }else if (InputFieldType.inputEmailWithPhone == inputFieldType) {
//
//            let text  =  textValue()
//            if(text.contains("@") && text.contains(".")){ //email
//                isValid = validate()
//            }else {
//                isValid = text.validatePhoneNumber()
//            }
//
//        }else {
//            isValid = validate()
//        }
        
        let isValid = validate()
        txtInput.setErrorMessage(isValid: isValid)
        self.lineImageView.backgroundColor = isValid ? UIColor.clear : ColorPalette.colorRedCinnabar
    }
    
    func validate() -> Bool {
        
        
        let text = textValue().removeWhitespace()
        
        if (text.isEmpty) {
            return true
        }
        
        if let minVal = self.minimumLength {
            
            if text.count < minVal {
                return false
            }
        }
        
        
//        if let maxVal = self.maximumLength {
//
//            if text.characters.count > maxVal
//            {
//                self.errorType = ErrorType.inValid
//                return false
//            }
//        }
        
        if (InputFieldType.inputPassword == inputFieldType) {
            
            return textValue().validatePassword()
            
        }else if (InputFieldType.inputPhone == inputFieldType) {
            
            return textValue().validatePhoneNumber()
            
        }else if (InputFieldType.inputEmailWithPhone == inputFieldType) {
            
            let text  =  textValue()
            if(text.contains("@") && text.contains(".")){ //email
                return text.validateEmail()
            }else {
                return text.validatePhoneNumber()
            }
            
        }
        
        
        if let regex  = self.validRegex
        {
            let valid  = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
            return valid
        }
        return true
    }
}
