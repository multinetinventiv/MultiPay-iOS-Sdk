//
//  AddCardVC.swift
//  Multipay
//
//  Created by ilker sevim on 27.10.2020.
//

import Foundation
import UIKit

enum CvvRequiredInfo {
    case unknown
    case necessary
    case unnecessary
}

class AddCardVC: BaseVC {
    
    static let cardNumberKey = "number"
    static let cvvKey = "cvv"
    static let aliasKey = "alias"
    
    
    @IBOutlet weak var cardNameTextView: InputTextView!
    @IBOutlet weak var cardNumberTextView: InputTextView!
    @IBOutlet weak var cvvTextView: InputTextView!
    @IBOutlet weak var cvvInfoLbl: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    
    var cvvRequiredInfo: CvvRequiredInfo = .unknown
    fileprivate var running = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationViewType = NavigationType.withLeftButton
        self.navigationEditionType = NavigationEditionType.whiteEditionType
        self.hasKeyboard = true
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cardNameTextView.becomeFirstResponder()
    }
    
    func setupView(){
        
        self.title = Localization.AddCardTitle.local
        let inputTextColor = ColorPalette.commonTextColor()
        
        cardNameTextView.layer.cornerRadius = 6
        cardNameTextView.layer.borderWidth = 1
        cardNameTextView.layer.borderColor = UIColor(red: 0.949, green: 0.941, blue: 0.992, alpha: 1).cgColor
        cardNameTextView.isBackgroundColorWhite = true
        cardNameTextView.isShadowActive = false
        cardNameTextView.clipsToBounds = true
        cardNameTextView.initView(placeholder:Localization.AddCardCardName.local,
                                  delegate:self,
                                  errorMessage:"",
                                  inputFieldType:InputFieldType.inputText,
                                  editionType:InputEditionType.inputEditionSDkAddcard,
                                  toolbarType:.done)
        
        cardNameTextView.setupFont(UIFont(name: "OpenSans-SemiBold", size: 15)!, textFont: UIFont(name: "OpenSans-SemiBold", size: 15)!, textColor: inputTextColor, titleTextColor: inputTextColor)
        
        
        cardNumberTextView.layer.cornerRadius = 6
        cardNumberTextView.layer.borderWidth = 1
        cardNumberTextView.layer.borderColor = UIColor(red: 0.949, green: 0.941, blue: 0.992, alpha: 1).cgColor
        cardNumberTextView.isBackgroundColorWhite = true
        cardNumberTextView.isShadowActive = false
        cardNumberTextView.clipsToBounds = true
        cardNumberTextView.initView(placeholder:Localization.AddCardCardNumber.local,
                                    minValu: 16,
                                    maxValue: 16,
                                    lastFieldOnForm:false,
                                    delegate:self,
                                    errorMessage:Localization.ValidationCardNumber.local,
                                    inputFieldType:InputFieldType.inputNumaric,
                                    editionType:InputEditionType.inputEditionSDkAddcard,
                                    toolbarType:.done)
        
        cardNumberTextView.setupFont(UIFont(name: "OpenSans-SemiBold", size: 15)!, textFont: UIFont(name: "OpenSans-SemiBold", size: 15)!, textColor: inputTextColor, titleTextColor: inputTextColor)
        
        cvvTextView.layer.cornerRadius = 6
        cvvTextView.layer.borderWidth = 1
        cvvTextView.layer.borderColor = UIColor(red: 0.949, green: 0.941, blue: 0.992, alpha: 1).cgColor
        cvvTextView.isShadowActive = false
        cvvTextView.isBackgroundColorWhite = true
        cvvTextView.clipsToBounds = true
        cvvTextView.initView(placeholder:"CVV",
                             minValu: 3,
                             maxValue: 4,
                             tag: 102030,
                             lastFieldOnForm: true,
                             delegate: self,
                             errorMessage: Localization.WalletAddCardCvvInformation.local,
                             textAlignment: .left,
                             inputFieldType: .inputNumaric,
                             editionType: .inputEditionSDkAddcard,
                             toolbarType: .done)
        
        cvvTextView.setupFont(UIFont(name: "OpenSans-SemiBold", size: 15)!, textFont: UIFont(name: "OpenSans-SemiBold", size: 15)!, textColor: inputTextColor, titleTextColor: inputTextColor)
        
        
        cvvInfoLbl.backgroundColor = .clear
        cvvInfoLbl.textColor = ColorPalette.commonTextColorGrayish2()
        cvvInfoLbl.font = UIFont(name: "OpenSans-SemiBold", size: 13)
        cvvInfoLbl.numberOfLines = 0
        cvvInfoLbl.lineBreakMode = .byWordWrapping
        cvvInfoLbl.textAlignment = .left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.alignment = .left
        let cvvInfoText = Localization.AddCardCVVInfoLabel.local
        cvvInfoLbl.attributedText = NSMutableAttributedString(string: cvvInfoText, attributes: [NSAttributedString.Key.kern: 0.2, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        continueBtn.backgroundColor = .clear
        continueBtn.layer.backgroundColor = UIColor(red: 0.365, green: 0.694, blue: 0.522, alpha: 1).cgColor
        let cornerRadiues:CGFloat = 8
        continueBtn.layer.cornerRadius = cornerRadiues
        continueBtn.roundedCorners(cornerRadius: cornerRadiues)
        continueBtn.setTitle(Localization.Continue.local, for: .normal)
        continueBtn.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        continueBtn.titleLabel?.font = UIFont(name: "OpenSans-SemiBold", size: 17)
        
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        self.addCardOperations()
        
        log.debug("Continue btn clicked in addCard")
    }
    
}

//MARK: - Request
extension AddCardVC {
    
    fileprivate func checkCvvRequirement(cardNumber: String, completion: @escaping (Bool) -> ()){
        
        let cardNumberTrimmed = cardNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let params = ["CvvRequiredInfo": ["cardNumber": cardNumberTrimmed]]
        
        post(ServiceConstants.ServiceName.GetCvvRequiredInfo, parameters: params as [String : AnyObject], callback: { [weak self] data, rawData in
            
            if let strongSelf = self{
                
                if let responseData = data{
                    
                    //let errorCode = responseData[resultCodeKey] as! Int
                    
                    if strongSelf.checkResultCodeAndShowError(responseData) == ServiceResultCodeType.exit {
                        return
                    }
                    
                    if let result = responseData[resultKey] as? [String: Bool], let cvvRequirement = result["IsCvvRequired"] {
                        
                        log.debug("result >> \(result) ")
                        completion(cvvRequirement)
                        
                    }
                }
            }
            
        }) { [weak self] (data: ErrorModel, rawData) in
            if let strongSelf = self
            {
                self?.showMessage(MessageType.error, message: data.message ?? "")
                strongSelf.running = false
            }
        }
    }
    
    
    fileprivate func createCardService(cvv: String? = nil) {
        
        log.debug("createCardService is called")
        
        let cardNumber =  cardNumberTextView.textValue().removeWhitespace()
        
        if(self.running) {
            return
        }
        
        self.running = true
        
        let cardName:String = cardNameTextView.textValue().count > 0 ? cardNameTextView.textValue() : "Multinet"
        
        var parameter = [ AddCardVC.aliasKey : cardName,
                          AddCardVC.cardNumberKey : String(cardNumber),
                          AddCardVC.cvvKey : cvv ?? cvvTextView.textValue().removeWhitespace(),
                          referenceNumberKey : Auth.referenceNumber
        ]
        
        if let walletToken = Auth.walletToken {
            parameter[walletTokenKey] = walletToken
        }
        else{
            parameter[authTokenKey] = Auth.authToken
        }
        
        log.debug("Parameter >> \(parameter) ")
        
        post(ServiceConstants.ServiceName.SdkAddWallet, parameters: parameter as [String : AnyObject], displayError: true, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            if let strongSelf = self
            {
                defer{
                    strongSelf.running = false
                    log.debug("data : \(String(describing: data))")
                }
                
                if let responseData  = data {
                    
                    if  strongSelf.checkResultCodeAndShowError(responseData) == ServiceResultCodeType.exit {
                        return
                    }
                    
                    strongSelf.endProcess()
                }
            }
        }
        ,errorCallback: {
            [weak self] (data: ErrorModel, rawData) in
            
            if let strongSelf = self
            {
                strongSelf.running = false
            }
        })
    }
    
    fileprivate func endProcess(_ result:AnyObject? = nil){
        self.view.endEditing(true)
        showMessage(MessageType.info, message: Localization.Success.local)
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func onlyNumbersFromString(_ string: String) -> String {
        let set = CharacterSet.decimalDigits.inverted
        let numbers = string.components(separatedBy: set)
        return numbers.joined(separator: "")
    }
    
    fileprivate func validateString(_ string: String) -> Bool {
        let numbers = onlyNumbersFromString(string)
        if numbers.count < 9 {
            return false
        }
        
        var reversedString = ""
        //  let range = (numbers.characters.indices)
        let range = numbers.startIndex ..< numbers.endIndex
        numbers.enumerateSubstrings(in: range, options: [NSString.EnumerationOptions.reverse, NSString.EnumerationOptions.byComposedCharacterSequences]) { (substring, substringRange, enclosingRange, stop) -> () in
            reversedString += substring!
        }
        
        var oddSum = 0, evenSum = 0
        let reversedArray = reversedString
        let i = 0
        
        for s in reversedArray {
            
            let digit = Int(String(s))!
            let k = i + 1
            if k % 2 == 0 {
                evenSum += digit
            } else {
                oddSum += digit / 5 + (2 * digit) % 10
            }
        }
        return (oddSum + evenSum) % 10 == 0
    }
    
    func addCardOperations(){
        self.view.endEditing(true)
        if validateFields() == false{
            return
        }
        self.createCardService()
    }
    
}


//MARK: - Validations
extension AddCardVC {
    
    func validateFields() -> Bool {
        
        switch self.cvvRequiredInfo {
        case .unknown, .unnecessary:
            return validateCardNumberField()
        case .necessary:
            return (validateCVVField() && validateCardNumberField())
        }
    }
    
    func validateCardNumberField() -> Bool {
        
        if (!cardNumberTextView.validate()) || (cardNumberTextView.textValue().isEmpty) {
            showMessage(MessageType.error, message: cardNumberTextView.getErrorMessage())
            return false
        }
        
        return true
    }
    
    func validateCVVField() -> Bool {
        
        if (!cvvTextView.validate()) || (cvvTextView.textValue().isEmpty) {
            showMessage(MessageType.error, message: cvvTextView.getErrorMessage())
            return false
        }
        
        return true
    }
}

//MARK: - UITextField
extension AddCardVC {
    
    override func textFieldShouldReturn(textField: MTextField,textView:InputTextView?) {
        if textView != cardNameTextView{
            self.addCardOperations()
        }
        else{
            self.view.endEditing(true)
        }
    }
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, textView: InputTextView) -> Int {
        
        if textView == self.cardNumberTextView {
            
            textField.replaceNSRange(range: range, withText: string)
            textField.textWithCaret = FormatUtil.format(textField.textWithCaret.uppercased(), template: Constants.FormatTemplate.multinetCardTemplate)!
            textField.text =  textField.text?.remove("|")
            //self.lblCardNumber.text = textField.text
            //self.cvvInfoStackView.isHidden = true
            self.cvvTextView.setTextValue("")
            self.cvvRequiredInfo = .unknown
            return TextFieldShouldChangeCharactersInRangeType.runningFalse.rawValue
        }else{
            return TextFieldShouldChangeCharactersInRangeType.notImplemented.rawValue
        }
    }
}

//MARK: - StoryboardInstantiable
extension AddCardVC: StoryboardInstantiable {
    static var storyboardName: String { return "Cards" }
    static var storyboardIdentifier: String? { return "AddCardVC" }
}
