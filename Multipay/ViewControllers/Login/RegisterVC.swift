//
//  RegisterVC.swift
//  MultiU
//
//  Created by  on 24/05/16.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

//import FBSDKLoginKit

class RegisterVC: BaseVC {
    
    
    @IBOutlet weak var personalInfoLabel: UILabel!
    @IBOutlet weak var nameView: InputTextView!
    @IBOutlet weak var lastNameView: InputTextView!
    @IBOutlet weak var emailView: InputTextView!

    @IBOutlet weak var securityInfoLabel: UILabel!
    @IBOutlet weak var phoneView: InputTextView!
    @IBOutlet weak var passwordView: InputTextView!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    
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
    
    @IBOutlet weak var buttonfacebook: UIButton!
    @IBOutlet weak var buttonRegister: UIButton!
    
    @IBOutlet weak var scrolllView: UIScrollView!
    var registerResponseData = [String:AnyObject]()
    
    var requestParameter: [String:AnyObject]?
    var isAgreementAgreed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hasKeyboard = true
        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType
        self.hasKeyboard = true
        self.title = Localization.RegisterHeader.local
        self.keyboardScrollView = self.scrolllView
        self.analyticsScreenName = "Kullanıcı kaydı (Register)"
        
        initViewStyles()
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initViewStyles() {
        self.view.backgroundColor = ColorPalette.vcBackground

        //Fonts
        self.personalInfoLabel.font = FontHelper.register.personalInfoLabel
        self.personalInfoLabel.textColor = ColorPalette.register.personalInfoLabel
        self.personalInfoLabel.text = Localization.RegisterPersonalInfoLabelText.local
        
        self.securityInfoLabel.font = FontHelper.register.securityInfoLabel
        self.securityInfoLabel.textColor = ColorPalette.register.securityInfoLabel
        self.securityInfoLabel.text = Localization.RegisterSecurityInfoLabelText.local

        self.passwordInfoLabel.font = FontHelper.register.registerInfoLabel
        self.passwordInfoLabel.textColor = ColorPalette.register.passwordInfoLabel
        self.passwordInfoLabel.text = Localization.ChangePasswordPasswordInfo.local
        
        self.contractHeaderLabel.font = FontHelper.register.contractHeaderLabel
        self.contractTextLabel.font = FontHelper.register.contractTextLabel
        self.contractHeaderLabel.textColor = ColorPalette.register.contractHeaderLabel
        self.contractTextLabel.textColor = ColorPalette.register.contractTextLabel

        self.informHeaderLabel.font = FontHelper.register.informHeaderLabel
        self.informTextLabel.font = FontHelper.register.informTextLabel
        self.informHeaderLabel.textColor = ColorPalette.register.informHeaderLabel
        self.informTextLabel.textColor = ColorPalette.register.informTextLabel

        self.kvkkHeaderLabel.font = FontHelper.register.informHeaderLabel
        self.kvkkTextLabel.font = FontHelper.register.informTextLabel
        self.kvkkHeaderLabel.textColor = ColorPalette.register.informHeaderLabel
        self.kvkkTextLabel.textColor = ColorPalette.register.informTextLabel

        self.buttonRegister.titleLabel!.font =  FontHelper.register.registerBtnTitle
        self.buttonRegister.backgroundColor = ColorPalette.register.buttonRegisterBackground
        
        self.buttonfacebook.layer.cornerRadius = 5
        self.buttonRegister.layer.cornerRadius = 5
        
        contractSwitch.onTintColor = ColorPalette.register.switchBtnsSelectedBackground
        contractSwitch.tintColor = ColorPalette.register.switchBtnsUnSelectedBackground
        
        informSwitch.onTintColor = ColorPalette.register.switchBtnsSelectedBackground
        informSwitch.tintColor = ColorPalette.register.switchBtnsUnSelectedBackground
        
        //Localization
        self.buttonfacebook.setTitle(Localization.RegisterFacebook.local, for: UIControl.State())
        self.buttonRegister.setTitle(Localization.LoginRegister.local, for: UIControl.State())
        
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
                          editionType:.inputEditionTypeBlack,
                          toolbarType:.next)
        
        nameView.txtInput.autocapitalizationType = UITextAutocapitalizationType.words
        nameView.txtInput.autocorrectionType = UITextAutocorrectionType.no
        
        lastNameView.initView(placeholder:Localization.RegisterLastname.local,
                              minValu: 2,
                              maxValue: 50,
                              regex: Regex.kName,
                              delegate:self,
                              errorMessage:Localization.ValidationSurname.local,
                              editionType:.inputEditionTypeBlack,
                              toolbarType:.next)
        
        
        lastNameView.txtInput.autocapitalizationType = UITextAutocapitalizationType.words
        lastNameView.txtInput.autocorrectionType = UITextAutocorrectionType.no
        
        emailView.initView(placeholder:Localization.RegisterEmail.local,
                           regex: Regex.kEmail,
                           delegate:self,
                           errorMessage:Localization.ValidationEmail.local,
                           inputFieldType:InputFieldType.inputEmail,
                           editionType:.inputEditionTypeBlack,
                           toolbarType:.next)
        
        phoneView.initView(placeholder:Localization.RegisterGsm.local,
                           minValu: 10,
                           maxValue: 10,
                           regex: Regex.kGSM,
                           delegate:self,
                           errorMessage:Localization.ValidationPhone.local,
                           inputFieldType:InputFieldType.inputPhone,
                           editionType:.inputEditionTypeBlack,
                           toolbarType:.next)
        
        
        passwordView.initView(placeholder:Localization.RegisterPassword.local,
                              minValu: Regex.kPasswordMin,
                              maxValue: Regex.kPasswordMax,
                              lastFieldOnForm:false,
                              delegate:self,
                              errorMessage:Localization.ValidationPassword.local,
                              secureField:true,
                              inputFieldType:InputFieldType.inputPassword,
                              editionType:.inputEditionTypeBlack,
                              toolbarType:.next)
        
        contractSwitch.isOn = false
        informSwitch.isOn = false
        
    }
    
    
    //MARK: - UIButton Clicked
    
//    @IBAction func facebookButtonClicked(sender: AnyObject) {
//        
//        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
//        
//        fbLoginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self, handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//            }
//            else if result.isCancelled {
//                // Handle cancellations
//            }
//            else {
//                let fbloginresult : FBSDKLoginManagerLoginResult = result
//                if(fbloginresult.grantedPermissions.contains("email"))
//                {
//                    self.returnUserData()
//                    fbLoginManager.logOut()
//                }
//            }
//            
//        })
//        
//    }
//    
//    func returnUserData()
//    {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email, picture.type(large)"])
//        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
//            
//            if ((error) != nil)
//            {
//                // Process error
//                log.debug("Error: \(error)")
//            }
//            else
//            {
//                let userFirstName : NSString = result.valueForKey("first_name") as! String
//                let userLastName  : NSString = result.valueForKey("last_name") as! String
//                let userEmail : NSString = result.valueForKey("email") as! String
//                
//                self.nameView .setTextValue(userFirstName as String)
//                self.lastNameView.setTextValue(userLastName as String)
//                self.emailView.setTextValue(userEmail as String)
//                
//        
//            }
//        })
//    }
    
    
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
        if (!isValid()){
            return
        }
        
        
        let registerUserInfo = ["Email"   : emailView.textValue(),
                                "Password"   : passwordView.textValue(),
                                "Gsm" : phoneView.textValue().clearNonNumeric().getGsmNumber(),
                                "Name" :nameView.textValue(),
                                "SurName" : lastNameView.textValue(),
                                "ContractVersion":"1.0",
                                "IsNotificationAccepted":"true",
                                "IsKvkkAccepted": String(informSwitch.isOn),
                                "IsClarificationText": String(kvkkSwitch.isOn)
        ]
        
        self.requestParameter = ["registerInfo" : registerUserInfo as AnyObject]
        
        
        post(ServiceConstants.ServiceName.registerUser, parameters: requestParameter , displayError: false, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            
            guard let strongSelf = self else { return }

            log.debug("data : \(String(describing: data))")
                
                if let responseData  = data {
                    
                    if  strongSelf.checkResultCodeAndShowError(responseData) == ServiceResultCodeType.exit {
                        return
                    }
                    
                    if let result = responseData[resultKey]  {
                        
                        if ((ServiceUrl.isPROD()) || (ServiceUrl.isPILOT())) {
                            strongSelf.registerResponseData = result as! [String : AnyObject]
                            strongSelf.performSegue(withIdentifier: "otpSegue", sender: self)
                        }else{
                            strongSelf.showMessage(MessageType.info, message:  (result["SmsMessage"] as? String)!,block: {
                                strongSelf.registerResponseData = result as! [String : AnyObject]
                                strongSelf.performSegue(withIdentifier: "otpSegue", sender: self)
                            })
                        }
                    }
                    
                }
            
            
            },errorCallback: {
                 (data: ErrorModel, rawData) in
                log.error("error : \(data.description)")
            })
        
    }
        
    
    func  isValid() -> Bool
    {
        if (!nameView.validate())
        {
            showMessage(MessageType.error, message: nameView.getErrorMessage())
            return false
        }
        
        if (!lastNameView.validate())
        {
            showMessage(MessageType.error, message: lastNameView.getErrorMessage())
            return false
        }
        
        if (!emailView.validate())
        {
            showMessage(MessageType.error, message: emailView.getErrorMessage())
            return false
        }
        
        if (!phoneView.textValue().validatePhoneNumber())
        {
            showMessage(MessageType.error, message: phoneView.getErrorMessage())
            return false
        }
        
        if (!passwordView.textValue().validatePassword())
        {
            showMessage(MessageType.error, message: passwordView.getErrorMessage())
            return false
        }
        
        if (!contractSwitch.isOn)
        {
            showMessage(MessageType.error, message: Localization.ValidationContract.local)
            return false
        }

        if !kvkkSwitch.isOn {
            showMessage(.error, message: Localization.ValidationKVKK.local)
            return false
        }

        return  true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "otpSegue"
        {
            let vc = segue.destination as! OTPVC
            //vc.registerData = self.registerResponseData //as? [String : AnyObject]
            vc.resendServiceName = ServiceConstants.ServiceName.registerUser
            vc.otpCalledType = OTPCalledType.register
            vc.loginRequestParameters  = self.requestParameter
        }
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
extension RegisterVC {
    
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
            self.passwordView.becomeFirstResponder()
        }else if(textView == passwordView){
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
