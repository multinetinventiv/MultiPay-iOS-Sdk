//
//  RegisterVC.swift
//  MultiU
//

import UIKit

class RegisterVC: BaseVC {
    
    @IBOutlet weak var infoTitleLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var nameView: InputTextView!
    @IBOutlet weak var lastNameView: InputTextView!
    @IBOutlet weak var emailView: InputTextView!

    @IBOutlet weak var securityInfoLabel: UILabel!
    @IBOutlet weak var phoneView: InputTextView!
    
    @IBOutlet weak var contractContainerView: UIView!
    @IBOutlet weak var contractHeaderLabel: UILabel!
    @IBOutlet weak var contractTextLabel: UILabel!
    @IBOutlet weak var contractSwitch: UISwitch!

    @IBOutlet weak var kvkkHeaderLabel: UILabel!
    @IBOutlet weak var kvkkTextLabel: UILabel!
    @IBOutlet weak var kvkkSwitch: UISwitch!
    
    @IBOutlet weak var informContainerView: UIView!
    @IBOutlet weak var informHeaderLabel: UILabel!
    @IBOutlet weak var informTextLabel: UILabel!
    @IBOutlet weak var informSwitch: UISwitch!
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var scrolllView: UIScrollView!
    
    var loginResponseModel: LoginResponseModel?
    
    var requestParameter: [String:AnyObject]?
    var isAgreementAgreed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hasKeyboard = true
        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType
        
        self.updateStatusBarStyle(forStyle: .default)
        
        self.title = Localization.RegisterHeader.local
        self.keyboardScrollView = self.scrolllView
        self.analyticsScreenName = "Kullanıcı kaydı (Register)"
        
        initViewStyles()
        initView()
        setWithUserPreset()
        
        self.decideRegisterButtonState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setWithUserPreset(){
        
        if let userPreset = Auth.userPreset{
            self.nameView.setTextValue(userPreset.name)
            self.lastNameView.setTextValue(userPreset.surname)
            self.emailView.setTextValue(userPreset.email)
            self.phoneView.setTextValue(userPreset.gsm)
        }
        
    }
    
    func initViewStyles() {
        
        self.infoLbl.text = Localization.RegisterInfo.local
        self.infoLbl.textColor = ColorPalette.commonTextColorGrayish2()
        self.infoLbl.font = FontHelper.login.bottomLbl
        
        self.infoTitleLbl.text = Localization.RegisterInfoTitle.local
        self.infoTitleLbl.textColor = ColorPalette.login.titleColor
        self.infoTitleLbl.font = FontHelper.login.titleLbl
        
        //Fonts
        self.personalInfoLabel.font = FontHelper.login.bottomLbl
        self.personalInfoLabel.textColor = ColorPalette.commonTextColorGrayish2()
        self.personalInfoLabel.text = Localization.RegisterPersonalInfoLabelText.local
        
        self.securityInfoLabel.font = FontHelper.login.bottomLbl
        self.securityInfoLabel.textColor = ColorPalette.commonTextColorGrayish2()
        self.securityInfoLabel.text = Localization.RegisterSecurityInfoLabelText.local
        
        self.contractHeaderLabel.font = FontHelper.register.contractHeaderLabel
        self.contractTextLabel.font = FontHelper.register.contractTextLabel
        self.contractHeaderLabel.textColor = ColorPalette.commonTextColor()
        self.contractTextLabel.textColor = ColorPalette.commonTextColor()

        self.informHeaderLabel.font = FontHelper.register.informHeaderLabel
        self.informTextLabel.font = FontHelper.register.informTextLabel
        self.informHeaderLabel.textColor = ColorPalette.commonTextColor()
        self.informTextLabel.textColor = ColorPalette.commonTextColor()

        self.kvkkHeaderLabel.font = FontHelper.register.informHeaderLabel
        self.kvkkTextLabel.font = FontHelper.register.contractTextLabel
        self.kvkkHeaderLabel.textColor = ColorPalette.commonTextColor()
        self.kvkkTextLabel.textColor = ColorPalette.commonTextColor()

        self.buttonRegister.titleLabel!.font =  FontHelper.register.registerBtnTitle
        self.buttonRegister.backgroundColor = ColorPalette.register.buttonRegisterPassiveBackground
        
        self.buttonRegister.layer.cornerRadius = 10
        
        //Localization
        self.buttonRegister.setTitle(Localization.RegisterButtonText.local, for: UIControl.State())
        
        self.contractHeaderLabel.text = Localization.RegisterContract.local
        let underlineAttribute = [convertFromNSAttributedStringKey(NSAttributedString.Key.underlineStyle): NSUnderlineStyle.single.rawValue]
        let underlineAttributedString = NSAttributedString(string: Localization.RegisterContractText.local, attributes: convertToOptionalNSAttributedStringKeyDictionary(underlineAttribute))
        self.contractTextLabel.attributedText = underlineAttributedString
        
        self.informHeaderLabel.text = Localization.RegisterInformHeaderLabel.local
        self.informTextLabel.text = Localization.RegisterInformTextLabel.local
        
        self.kvkkHeaderLabel.text = Localization.RegisterKVKKHeaderLabel.local
        let kvkkUnderlineAttributedString = NSAttributedString(string: Localization.RegisterKVKKTextLabel.local, attributes: convertToOptionalNSAttributedStringKeyDictionary(underlineAttribute))
        self.kvkkTextLabel.attributedText = kvkkUnderlineAttributedString
    }
    
    func initView()  {
        
        nameView.initView(placeholder:Localization.RegisterName.local,
                          minValu: 2,
                          maxValue: 50,
                          regex: Regex.kName,
                          delegate:self,
                          errorMessage:Localization.ValidationName.local,
                          editionType:.inputEditionSdk,
                          toolbarType:.next)
        
        nameView.txtInput.autocapitalizationType = UITextAutocapitalizationType.words
        nameView.txtInput.autocorrectionType = UITextAutocorrectionType.no
        
        lastNameView.initView(placeholder:Localization.RegisterLastname.local,
                              minValu: 2,
                              maxValue: 50,
                              regex: Regex.kName,
                              delegate:self,
                              errorMessage:Localization.ValidationSurname.local,
                              editionType:.inputEditionSdk,
                              toolbarType:.next)
        
        
        lastNameView.txtInput.autocapitalizationType = UITextAutocapitalizationType.words
        lastNameView.txtInput.autocorrectionType = UITextAutocorrectionType.no
        
        emailView.initView(placeholder:Localization.RegisterEmail.local,
                           regex: Regex.kEmail,
                           delegate:self,
                           errorMessage:Localization.ValidationEmail.local,
                           inputFieldType:InputFieldType.inputEmail,
                           editionType:.inputEditionSdk,
                           toolbarType:.next)
        
        phoneView.initView(placeholder:Localization.RegisterGsm.local,
                           minValu: 10,
                           maxValue: 10,
                           regex: Regex.kGSM,
                           delegate:self,
                           errorMessage:Localization.ValidationPhone.local,
                           inputFieldType:InputFieldType.inputPhone,
                           editionType:.inputEditionSdk,
                           toolbarType:.next)
        
        
        
        contractSwitch.isOn = false
        informSwitch.isOn = false
        
    }
    
    @IBAction func contractButtonClicked(_ sender: AnyObject) {
        let vc = AgreementVC.instantiate()
        vc.delegate = self
        vc.agreementViewType = AgreementViewType.register
        self.presentModal(vc, animated: true, completion: nil)
    }

    @IBAction func kvkkButtonClicked(_ sender: AnyObject) {
        let vc = AgreementVC.instantiate()
        vc.delegate = self
        vc.agreementViewType = AgreementViewType.kvkkRegister
        self.presentModal(vc, animated: true, completion: nil)
    }
    
    @IBAction func informButtonClicked(_ sender: AnyObject) {
        
        if informSwitch.isOn {
            informSwitch.setOn(false, animated: true)
        }else{
            informSwitch.setOn(true, animated: true)
        }
    }
    
    @IBAction func registerButtonClicked(_ sender: AnyObject) {
        
        if Multipay.testModeActive{
            self.loginResponseModel = LoginResponseModel(result: LoginResponseModel.Result(gsm: "5321765109", remainingTime: 30, verificationCode: "asd"), resultCode: 200, resultMessage: nil)
            performSegue(withIdentifier: "otpSegue", sender: self)
            return
        }
        
        if (!isValid()){
            return
        }
        
        let email = emailView.textValue()
        let gsm = phoneView.textValue().clearNonNumeric().getGsmNumber()
        let name = nameView.textValue()
        let lastname = lastNameView.textValue()
    
        var registerUserInfo = [String: AnyObject]()
        registerUserInfo["email"] = email as AnyObject
        registerUserInfo["gsm"] = gsm as AnyObject
        registerUserInfo["name"] = name as AnyObject
        registerUserInfo["surname"] = lastname as AnyObject
        registerUserInfo["isNotificationAccepted"] = String(informSwitch.isOn) as AnyObject
        
        self.requestParameter = registerUserInfo
        
        post(ServiceConstants.ServiceName.SdkRegister, parameters: self.requestParameter , displayError: true, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            
            guard let strongSelf = self else { return }

            log.debug("data : \(String(describing: data))")
            
            if let data = rawData {
                do{
                    let modelObject = try data.decoded() as LoginResponseModel
                    strongSelf.loginResponseModel = modelObject
                }
                catch{
                    print("error: \(error)")
                }
            }
            
            if let data  = data {
                
                //log.debug("data : \(data)")
                
                if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                    return
                }
                
                //To show two factor authentication screen
                strongSelf.performSegue(withIdentifier: "otpSegue", sender: self)
            }
            
            },errorCallback: {
                 (data: ErrorModel, rawData) in
                log.error("error : \(data.description)")
            })
        
    }
        
    
    func  isValid(shouldShowMessage: Bool = true) -> Bool
    {
        if (!nameView.validate())
        {
            if shouldShowMessage {
                showMessage(MessageType.error, message: nameView.getErrorMessage())
            }
            return false
        }
        
        if (!lastNameView.validate())
        {
            if shouldShowMessage {
            showMessage(MessageType.error, message: lastNameView.getErrorMessage())
            }
            return false
        }
        
        if (!emailView.validate())
        {
            if shouldShowMessage {
            showMessage(MessageType.error, message: emailView.getErrorMessage())
            }
            return false
        }
        
        if (!phoneView.textValue().validatePhoneNumber())
        {
            if shouldShowMessage {
                showMessage(MessageType.error, message: phoneView.getErrorMessage())
            }
            return false
        }
        
        if (!contractSwitch.isOn)
        {
            if shouldShowMessage {
                showMessage(MessageType.error, message: Localization.ValidationContract.local)
            }
            return false
        }

        if !kvkkSwitch.isOn {
            if shouldShowMessage {
                showMessage(.error, message: Localization.ValidationKVKK.local)
            }
            return false
        }

        return  true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "otpSegue"
        {
            let vc = segue.destination as! OTPVC
            vc.loginResponseModel = self.loginResponseModel
            vc.loginRequestParameters  = self.requestParameter
            vc.resendServiceName = ServiceConstants.ServiceName.registerUser
            vc.otpCalledType = OTPCalledType.register
        }
    }
}

//MARK: - RegisterButton Active State
extension RegisterVC {
    func decideRegisterButtonState(){
        let isValid = Multipay.testModeActive ? true : isValid(shouldShowMessage: false)
        
        if isValid {
            buttonRegister.setTitleColor(ColorPalette.login.girisYapActiveText, for: .normal)
            buttonRegister.backgroundColor = ColorPalette.register.buttonRegisterActiveBackground
        }
        else{
            buttonRegister.setTitleColor(ColorPalette.login.loginBtnTitlePassive, for: .normal)
            buttonRegister.backgroundColor = ColorPalette.register.buttonRegisterPassiveBackground
        }
        
        self.buttonRegister.isEnabled = isValid
    }
    
    @IBAction func contractSwitchChanged(_ sender: Any) {
        self.decideRegisterButtonState()
    }
    
    @IBAction func kvkkSwitchChanged(_ sender: Any) {
        self.decideRegisterButtonState()
    }
}

//MARK: - AgreementView Delegate
extension RegisterVC {
    override func agreedUserAgreementClicked(type: AgreementViewType) {
        if type == AgreementViewType.register {
            contractSwitch.setOn(true, animated: true)
        } else {
            kvkkSwitch.setOn(true, animated: true)
        }
    }
    override func disagreedUserAgreementClicked(type: AgreementViewType) {
        if type == AgreementViewType.register {
            contractSwitch.setOn(false, animated: true)
        } else {
            kvkkSwitch.setOn(false, animated: true)
        }
    }
}


//MARK: - UITextField Delegate
extension RegisterVC{
    
    func textFieldChanged(textView: UITextField) {
        self.decideRegisterButtonState()
    }
    
    override func textFieldShouldNext(textField: UITextField,textView:InputTextView? = nil) {
        guard textField.text != nil else {
            return
        }
  
        if(self.nameView == textView ){
            self.lastNameView.becomeFirstResponder()
        } else if(textView == lastNameView){
            self.emailView.becomeFirstResponder()
        } else if(textView == emailView){
            self.phoneView.becomeFirstResponder()
        } else if(textView == phoneView){
            textField.resignFirstResponder()
        }else{
            textField.resignFirstResponder()
            self.registerButtonClicked(self.buttonRegister)
        }
    }
    
}


//MARK: - StoryboardInstantiable
extension RegisterVC: StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "RegisterVC" }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
