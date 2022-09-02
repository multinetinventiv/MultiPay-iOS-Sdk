//
//  LoginVC.swift
//  Multipay
//
//  Created by ilker sevim on 7.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    private let hideForgotPasswordAndRegister = true
    
    @IBOutlet weak var rememberView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnLoginWithActivation: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var emailPhoneView: InputTextView!
    @IBOutlet weak var passwordView: InputTextView!
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var lblVersion: MTLabel!
    @IBOutlet weak var lblForgetPassword: MTLabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!
    
    private var loginParameters: [String: Any] = [String: Any]()
    
    private enum LoginButtonState {
        case passive
        case active
    }
    
    private var selectedState = LoginButtonState.passive {
        didSet {
            stateChanged()
        }
    }
    
    fileprivate func stateChanged(){
        
        //LoggerHelper.logger.debug("Login button state changed to \(selectedState)")
        
        switch selectedState {
        case .passive:
            btnLogin.setTitleColor(ColorPalette.login.loginBtnTitlePassive, for: .normal)
            btnLogin.backgroundColor = ColorPalette.login.girisYapPassiveBackground
            btnLogin.isUserInteractionEnabled = false
            break
        case .active:
            btnLogin.setTitleColor(ColorPalette.login.girisYapActiveText, for: .normal)
            btnLogin.backgroundColor = ColorPalette.login.girisYapActiveBackground
            btnLogin.isUserInteractionEnabled = true
            break
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkToken()
        
        self.hasKeyboard = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationViewType = .withRightButton
        self.navigationEditionType = .whiteEditionType
        
        
        self.updateStatusBarStyle(forStyle: .default)
        
        initViewStyles()
        initView()
        getMultiMobilUserInfo()
        stateChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func presentModalWillDismiss(animated: Bool = true){
        //Multipay.delegate?.multipayLoginDidCancel?()
        super.presentModalWillDismiss(animated: true)
    }
    
    //MARK: - InitializeView
    fileprivate func initViewStyles()  {
        if btnRegister != nil{
            btnRegister.roundedCorners(cornerRadius: 0.5, borderWidth: 1.0, borderColor: UIColor.lightGray.withAlphaComponent(0.75))
            btnRegister.setTitle(Localization.LoginRegister.local, for: UIControl.State())
            btnRegister.titleLabel!.font = FontHelper.login.registerBtn
            btnRegister.setTitleColor(ColorPalette.login.forgotPasswordLblTitle(), for: .normal)
            btnRegister.clipsToBounds = true
            btnRegister.layer.backgroundColor = UIColor.clear.cgColor
            btnRegister.layer.cornerRadius = 16
            btnRegister.layer.borderWidth = 2
            btnRegister.layer.borderColor = ColorPalette.login.registerButtonBorder().cgColor
            btnRegister.isHidden = false
            
            btnRegister.backgroundColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0)
            
            btnRegister.layer.backgroundColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0).cgColor
            
            btnRegister.layer.borderColor = ColorPalette.getirBorder.cgColor
            
            btnRegister.setTitleColor(ColorPalette.tintColor(), for: UIControl.State.normal)
        }
        
        rememberView.isHidden = hideForgotPasswordAndRegister
        
        if (btnLoginWithActivation != nil){
            btnLoginWithActivation.roundedCorners(cornerRadius: 0.5, borderWidth: 1.0, borderColor: UIColor.lightGray.withAlphaComponent(0.5))
            btnLoginWithActivation.setTitle(Localization.LoginWithActivationCodeBtnText.local, for: UIControl.State())
            btnLoginWithActivation.titleLabel!.font = FontHelper.login.activationBtn
            btnLoginWithActivation.setTitleColor(ColorPalette.login.activationBtnTitle, for: .normal)
        }
        
        btnLogin.setTitle(Localization.LoginButton.local, for: UIControl.State())
        btnLogin.titleLabel!.font = FontHelper.login.loginBtn
        btnLogin.setTitleColor(ColorPalette.login.loginBtnTitlePassive, for: .normal)
        btnLogin.backgroundColor = ColorPalette.login.loginBtnBackgroundPassive
        btnLogin.isUserInteractionEnabled = false
        btnLogin.layer.cornerRadius = 10
        btnLogin.clipsToBounds = true
        forgetPasswordLabel()
        
        if titleLbl != nil{
            titleLbl.font = FontHelper.login.titleLbl
            titleLbl.textColor = ColorPalette.login.titleColor
            titleLbl.text = Localization.LoginTopTitle.local
        }
        if infoLbl != nil
        {
            infoLbl.font = FontHelper.login.bottomLbl
            infoLbl.textColor = ColorPalette.login.infoColor
            infoLbl.text = Localization.LoginTopInfoTitle.local
        }
        
    }
    
    fileprivate func forgetPasswordLabel(){
        lblForgetPassword.attributedText = Localization.LoginForgetPasswordText.local.htmlAttributed(withRegularFont: FontHelper.login.forgotPassword!, andBoldFont: FontHelper.login.forgotPasswordBoldPart)
        lblForgetPassword.textColor = ColorPalette.login.forgotPasswordLblTitle()
    }
    
    fileprivate func getMultiMobilUserInfo(){
        
        if let user = User.loadMultiMobilUser() {
            
            if let mail = user.email {
                emailPhoneView.setTextValue(mail)
            }
            if let pwd = user.password {
                passwordView.setTextValue(pwd)
            }
        }
        
//        if ServiceUrl.readApiType() == APIType.dev{
//            emailPhoneView.setTextValue("hilmeh@gmail.com")
//            passwordView.setTextValue("test1234")
//            decideForLoginState()
//        }
        
//        if ServiceUrl.readApiType() == APIType.test || ServiceUrl.readApiType() == APIType.dev
//        {
//            emailPhoneView.setTextValue("hilmeh@gmail.com")
//            passwordView.setTextValue("test1234")
//            decideForLoginState()
//        }
    }
    
    fileprivate func initView()  {
        
        emailPhoneView.initView(placeholder:Localization.LoginEmailOrGSM.local,
                                regex: Regex.kEmail,
                                delegate:self,
                                errorMessage:Localization.ValidationEmailOrGSM.local,
                                inputFieldType:InputFieldType.inputEmailWithPhone,
                                editionType:InputEditionType.inputEditionSdk,
                                toolbarType:.next)
        
        
        passwordView.initView(placeholder:Localization.LoginPassword.local,
                              minValu: Regex.kPasswordMin,
                              maxValue: Regex.kPasswordMax,
                              lastFieldOnForm:true,
                              delegate:self,
                              errorMessage:Localization.ValidationPassword.local,
                              secureField:true,
                              inputFieldType:InputFieldType.inputPassword,
                              editionType:InputEditionType.inputEditionSdk,
                              toolbarType:.next)
    }
    
    //MARK: - UIButton Actions
    
    func  isValid() -> Bool {
        
        if (!emailPhoneView.validate())
        {
            showMessage(MessageType.error, message: emailPhoneView.getErrorMessage())
            return false
        }
        
        if (!passwordView.validate())
        {
            showMessage(MessageType.error, message: passwordView.getErrorMessage())
            return false
        }
        
        
        return  true
    }
    
    private var loginResponseModel: LoginResponseModel?
    
    @IBAction func loginClicked(_ sender: AnyObject) {
        
        if Multipay.offlineModeActive{
            self.loginResponseModel = LoginResponseModel(result: LoginResponseModel.Result(gsm: emailPhoneView.textValue(), remainingTime: 30, verificationCode: "asd"), resultCode: 200, resultMessage: nil)
            performSegue(withIdentifier: "verifySegue", sender: self)
            return
        }
        
        if (!isValid())
        {
            return
        }
        
        let serviceName = ServiceConstants.ServiceName.SdkLogin
        
        let emailText:String = emailPhoneView.textValue()
        
        let isEmail = emailText.length > 0 && emailText.isContainsLetterChars()
        let gsm:String = emailText.clearNonNumeric().getGsmNumber()
        
        var parameters:[String:String] = [:]
        
        if isEmail{
            parameters["email"] = emailText
        }
        else{
            parameters["gsm"] = gsm
        }
        
        self.loginParameters = parameters
        
        post(serviceName, parameters: parameters as [String : AnyObject], displayError: false, isSecure: false, callback:
                {
                    [weak self](data:[String:AnyObject]?, rawData)
                    
                    in
                    
                    guard let strongSelf = self else { return }
                    
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
                        
                        //LoggerHelper.logger.debug("data : \(data)")
                        
                        if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                            return
                        }
                        
                        //To show two factor authentication screen
                        strongSelf.performSegue(withIdentifier: "verifySegue", sender: strongSelf)
                    }
                    
                },errorCallback: {
                    [weak self] (data, rawData)  in
                        //Multipay.delegate?.multipayLoginDidFail?(errorReason: data.message)
                            print("error: \(data)")
                })
        
    }
    
}

//MARK: - UITextField Delegate
extension LoginVC {
    override func textFieldShouldNext(textField: UITextField,textView:InputTextView? = nil) {
        if(self.emailPhoneView == textView) {
            passwordView.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    private func decideForLoginState(){
        if self.emailPhoneView.textValue().count > 0{
            self.selectedState = .active
        }
        else{
            self.selectedState = .passive
        }
    }
    
    func textFieldChanged(textView: UITextField) {
        decideForLoginState()
    }
    
}

//MARK: - Auth Validation
extension LoginVC {
    func checkToken(){
        
        let nav = self.navigationController as! MyNavigationController
        
        if let token = Auth.authToken, token.count > 0
        {
            nav.openWalletFromLogin()
        }
        
        else if Auth.isOnlyWalletTokenEnoughForAuthentication, let walletToken = Auth.walletToken, walletToken.count > 0{
            nav.openWalletFromLogin()
        }
    }
}

//MARK: - PreapareSegue
extension LoginVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifySegue" {
            let vc = segue.destination as! OTPVC
            vc.loginResponseModel = self.loginResponseModel
            vc.loginRequestParameters = self.loginParameters as [String : AnyObject]
            vc.resendServiceName = ServiceConstants.ServiceName.SdkLogin
            vc.otpCalledType = OTPCalledType.loginWithOTP
        } else if segue.identifier == "RegisterSegue" {
            _ = segue.destination as! RegisterVC
        } else if segue.identifier == "activationSegue" {
            //_ = segue.destination as! LoginWithCodeVC
        }
        
        else if segue.identifier == "showAddCard" {
            LoggerHelper.logger.debug("show add card or needed vc after login")
        }
    }
}

//MARK: - StoryboardInstantiable
extension LoginVC: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "LoginVC" }
}

