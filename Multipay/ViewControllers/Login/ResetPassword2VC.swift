
import UIKit

enum ResetPasswordCalledType {
    case remindPassword
    case changePassword
}

let kAnimationTime = 0.0

class ResetPassword2VC: BaseVC {
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var oldTextView: InputTextView!
    @IBOutlet weak var oldTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var resetTextView: InputTextView!
    @IBOutlet weak var resetTextViewTop: NSLayoutConstraint!
    @IBOutlet weak var reset2TextView: InputTextView!
    @IBOutlet weak var passwordInfoLabel: UILabel!
    @IBOutlet weak var btnReset: UIButton!


    var pinValue: String = ""
    // Variable
    var verificationcode:String?
    
    var resetPasswordCalledType = ResetPasswordCalledType.changePassword
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType
        self.keyboardScrollView = containerView
        self.title =  Localization.ChangePasswordHeader.local
        self.hasKeyboard = true
        
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initViewStyles()
    }
    
    //MARK: - Initialize
    fileprivate func initViewStyles() {
        self.view.backgroundColor = ColorPalette.colorGrayMako
        self.containerView.backgroundColor = ColorPalette.colorGrayWildSand
        self.btnReset.actionStyle(title: Localization.ForgotPasswordButton.local)
        self.btnReset.backgroundColor = ColorPalette.resetPassword2.resetBtnBackground
        self.btnReset.titleLabel?.textColor = ColorPalette.resetPassword2.resetBtnTitleColor
        self.btnReset.titleLabel?.font = FontHelper.resetPassword2.resetBtnTitle
        self.passwordInfoLabel.font = FontHelper.resetPassword2.passwordInfoLabel
        self.passwordInfoLabel.textColor = ColorPalette.resetPassword2.passwordInfoLabelText
        self.passwordInfoLabel.text = Localization.ChangePasswordPasswordInfo.local
        
        if (ResetPasswordCalledType.remindPassword == self.resetPasswordCalledType) {
            resetTextViewTop.constant = 0
            oldTextViewHeight.constant = 0
            oldTextView.isHidden = true
        }

        oldTextView.txtInput.text = ""
        resetTextView.txtInput.text = ""
        reset2TextView.txtInput.text = ""
        
    }
    
    fileprivate func initView() {
        oldTextView.initView(
            placeholder: Localization.ChangePasswordPassword.local,
            minValu: Regex.kPasswordMin,
            maxValue: Regex.kPasswordMax,
            delegate: self,
            errorMessage: Localization.ValidationPassword.local,
            secureField: true,
            inputFieldType: .inputPassword,
            editionType: .inputEditionTypeBlack,
            toolbarType: .next
        )
        
        resetTextView.initView(
            placeholder: Localization.ChangePasswordNewPassword.local,
            minValu: Regex.kPasswordMin,
            maxValue: Regex.kPasswordMax,
            lastFieldOnForm: false,
            delegate: self,
            errorMessage: Localization.ValidationPassword.local,
            secureField: true,
            inputFieldType: .inputPassword,
            editionType: .inputEditionTypeBlack,
            toolbarType: .next
        )

        reset2TextView.initView(
            placeholder: Localization.ChangePasswordReNewPassword.local,
            minValu: Regex.kPasswordMin,
            maxValue: Regex.kPasswordMax,
            lastFieldOnForm: false,
            delegate: self,
            errorMessage: Localization.ValidationPassword.local,
            secureField: true,
            inputFieldType: .inputPassword,
            editionType: .inputEditionTypeBlack,
            toolbarType: .done
        )

        if resetPasswordCalledType == ResetPasswordCalledType.changePassword {
            oldTextView.editionType = InputEditionType.inputEditionTypeBlack
            resetTextView.editionType = InputEditionType.inputEditionTypeBlack
            reset2TextView.editionType = InputEditionType.inputEditionTypeBlack
        }

    }
    
    
    // MARK: UIButton Action
    @IBAction func buttonClicked(_ sender: UIButton) {
        guard isValid() else {
            return
        }
        
        if (ResetPasswordCalledType.changePassword == self.resetPasswordCalledType) {
            
            let vc = PinVC.instantiate()
            vc.pinCodeType = PinCodeType.single
            vc.askPin = true
            vc.enteredPin = {[weak self]
                (data) in
                if let weakSelf = self {
                    if data != nil {
                        
                        weakSelf.pinValue = data!
                        weakSelf.callChangePasswordService()
                    }
                    
                }
            }
            
            self.presentModal(vc, animated: true, completion: nil)
            
        }else{
            
            callChangePasswordService()
            
        }
    }
    
    fileprivate func isValid() -> Bool
    {
        if (resetPasswordCalledType == ResetPasswordCalledType.changePassword) {
        
            let oldText = oldTextView.textValue()
            guard oldText.count > 0  else {
                showMessage(MessageType.error, message: Localization.ChangePasswordErrorPasswordLengthIsNotSuitable.local)
                return false
            }
            
        }
        
        let pwdText = resetTextView.textValue()
        guard pwdText.count > 0  else {
            showMessage(MessageType.error, message: Localization.ChangePasswordErrorPasswordLengthIsNotSuitable.local)
            return false
        }
        
        guard pwdText == reset2TextView.textValue()  else {
            showMessage(MessageType.error, message: Localization.ChangePasswordErrorPasswordsIsNotEqual.local)
            return false
        }
            
        return true
    }
    
    fileprivate func callChangePasswordService(){
    
        var parameters:[String:Any]?
        
        if (ResetPasswordCalledType.remindPassword == self.resetPasswordCalledType) {
            parameters = ["changePasswordViaRemindPasswordInfo" :   ["Password"         : resetTextView.textValue(),
                                                                     "VerificationCode" : verificationcode!]]
        }else{
            guard CoreManager.Instance().user != nil else {
                showMessage(MessageType.error, message: "USER_INFO_NOT_FOUND".local)
                return
            }
            
            parameters = ["ChangePasswordInfo" : ["NewPassword"  : resetTextView.textValue(),
                                                  "OldPassword"  : oldTextView.textValue(),
                                                  "PinCode" :  pinValue ]]
            
        }
        
        let serviceName = ResetPasswordCalledType.remindPassword == self.resetPasswordCalledType ? ServiceConstants.ServiceName.changePasswordviaRemind
            : ServiceConstants.ServiceName.changePassword
        
        
        post(serviceName, parameters: parameters as [String : AnyObject]?, displayError: false, callback:
            {
                [weak self](data:[String:AnyObject]?, rawData)
                
                in
                if let strongSelf = self
                {
                    if let data  = data {
                        
                        log.debug("data : \(data)")
                        
                        
                        if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                            return
                        }
                        
                        
                        if let result = data[resultKey],  let message = result["UserMessage"]
                        {
                            strongSelf.showMessage(MessageType.info, message: message as! String,block: {
                                
                                if (ResetPasswordCalledType.remindPassword == strongSelf.resetPasswordCalledType) {
                                    //strongSelf.gotoDashboard()
                                    strongSelf.navigationController?.popViewController(animated: true)
                                }else{
                                    
                                    if (ServiceUrl.isPROD()) {
                                        
                                        if !(ResetPasswordCalledType.remindPassword == self!.resetPasswordCalledType){
                                            
                                            if (result["UserMessage"]) != nil {
                                                strongSelf.navigationController?.popViewController(animated: true)
                                                
                                            }
                                        }else{
                                            let vc  = OTPVC.instantiate()
                                            //vc.registerData = data[resultKey] as? [String:AnyObject]
                                            vc.loginRequestParameters = parameters as [String : AnyObject]?
                                            vc.otpCalledType = OTPCalledType.changePassword
                                            vc.title = self?.title
                                            vc.navigationViewType =  .withLeftButton
                                            vc.resendServiceName = serviceName
                                            
                                            strongSelf.navigationController?.pushViewController(vc, animated: true)
                                            
                                        }
                                    }else{
                                        if !(ResetPasswordCalledType.remindPassword == strongSelf.resetPasswordCalledType){
                                            
                                            if (result["UserMessage"]) != nil {
                                                strongSelf.navigationController?.popViewController(animated: true)
                                                
                                            }
                                        }else {
                                            strongSelf.showMessage(MessageType.info, message:  (result["SmsMessage"] as? String)!,block: {
                                                let vc  = OTPVC.instantiate()
                                                //vc.registerData = data[resultKey] as? [String:AnyObject]
                                                vc.loginRequestParameters = parameters as [String : AnyObject]?
                                                vc.otpCalledType = OTPCalledType.changePassword
                                                vc.title = self?.title
                                                vc.navigationViewType =  .withLeftButton
                                                vc.resendServiceName = serviceName
                                                strongSelf.navigationController?.pushViewController(vc, animated: true)
                                            })
                                        }
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                            })
                        }
                    }
                }
                
            },errorCallback: {
                [weak self] (data: ErrorModel, rawData) in
                if Config.LOCAL {
                    if let strongSelf = self {
                        strongSelf.perform(#selector(BaseVC.gotoDashboard), with: nil, afterDelay: 0.2)
                    }
                    
                }
                log.error("error : \(data.description)")
            })
        
    }
    
    
}


//MARK: - InputTextView Delegates

extension ResetPassword2VC {
    
    override func textFieldShouldNext(textField: MTextField,textView:InputTextView? = nil) {

        if (oldTextView == textView) {
            resetTextView.becomeFirstResponder()
            
        }else if (resetTextView == textView) {
            reset2TextView.becomeFirstResponder()
            
        }else if(reset2TextView == textView) {
            textView?.resignFirstResponder()
        }
    }
   
}

//MARK: - StoryboardInstantiable Delegates

extension ResetPassword2VC: StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "ResetPassword2VC" }
}
