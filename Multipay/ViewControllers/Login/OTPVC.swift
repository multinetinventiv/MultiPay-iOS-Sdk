
import UIKit

enum OTPState
{
    case normal
    case reSend
    case reSendNormal
}

enum OTPCalledType {
    case register         //goToDashboard
    case userUpdate      //POP
    case changePassword  //Dashboard
    case pinDefinition   //Dashboard
    case pinSettings   //POP
    case verifyGsm       //goToDashboard
    case resetPassword  //goto Login
    case pinLimit      //POP
    case loginWithOTP // Login With OTP
    case addCard
}


@objc protocol OTPVCDelegate :AnyObject{
    
    func otpDidFinishSuccess(_ otpVC:OTPVC,result:[String:AnyObject]?)
    //func orderDidFinishFailed(orderVc:OrderSecureVC)
}

class OTPVC: BaseVC {
    
    @IBOutlet weak var onayKoduLbl: UILabel!
    
    @IBOutlet weak var digitInputView: DigitInputView!
    
    @IBOutlet weak var btnResendSms: UIButton!
    
    @IBOutlet weak var otpView: InputTextView!
    
    @IBOutlet weak var lblDescription: MTLabel!
    
    @IBOutlet weak var lblTimer: MTLabel!
    
    var loginResponseModel:LoginResponseModel?
    
    var loginRequestParameters:[String:AnyObject]?
    
    fileprivate var timer : Timer?
    fileprivate var timeCount = 0
    
    weak var delegate: OTPVCDelegate?
    
    var resendServiceName:String = ServiceConstants.ServiceName.LoginWithOtpSecure
    
    var otpCalledType = OTPCalledType.register
    var smsCode:String?
    
    private let verificationCodeKey = "verificationCode"
    private let smsCodeKey = "smsCode"
    
    private var otpConfirmResponse: OtpConfirmResponse?
    
    fileprivate var state:OTPState = .normal {
        willSet(newValue)
        {
            //let isResend = OTPState.reSend == newValue
            
            //lblTimer.isHidden           = isResend
            otpView.txtInput.isEnabled  = OTPState.normal == newValue
            otpView.txtInput.isEnabled  = true
            // serviceType = .ConfirmOtp
            
            if (OTPState.normal == newValue) {
                initializeTimer()
                btnResendSms.isHidden = true
            }
            
            else{
                //initializeTimer()
                btnResendSms.isHidden = false
            }
        }
    }
    
    var serviceName:String = ServiceConstants.ServiceName.registerUser
    
    deinit{
        log.debug("")
        delegate = nil 
        timer?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationViewType = NavigationType.withLeftButton
        self.navigationEditionType = NavigationEditionType.whiteEditionType
        self.hasKeyboard = true
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(!(ServiceUrl.isPROD())) {
            if(smsCode != nil) {
                otpView.setTextValue(smsCode!)
            }
        }
        
        if otpCalledType == .loginWithOTP || otpCalledType == .register {
            //otpView.becomeFirstResponder()
            _ =  digitInputView.becomeFirstResponder()
        }
    }
    
    
    fileprivate func setupView()  {
        
        otpView.initView(placeholder:Localization.OTPSMSCode.local,
                         minValu: 4,
                         maxValue: 6,
                         delegate:self,
                         errorMessage:Localization.ValidationOTP.local,
                         inputFieldType:InputFieldType.inputNumaric,
                         editionType:InputEditionType.inputEditionTypeBlack,
                         toolbarType:.done)
        
        self.digitInputView.translatesAutoresizingMaskIntoConstraints = false
        self.digitInputView.numberOfDigits = 6
        self.digitInputView.bottomBorderColor = ColorPalette.OTP.bottomBorderColor()
        self.digitInputView.nextDigitBottomBorderColor = UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        self.digitInputView.textColor = ColorPalette.commonTextColor() //UIColor(red: 39 / 255, green: 60 / 255, blue: 47 / 255, alpha: 1.0)
        self.digitInputView.acceptableCharacters = "0123456789"
        self.digitInputView.keyboardType = .decimalPad
        self.digitInputView.animationType = .spring
        self.digitInputView.delegate = self
        
        self.btnResendSms.setTitle(Localization.OTPResendButton.local, for: UIControl.State())
        self.btnResendSms.titleLabel!.font =  FontHelper.otp.loginBtnTitle
        self.btnResendSms.setTitleColor(ColorPalette.commonTextColor(), for: UIControl.State.normal)
        self.btnResendSms.layer.backgroundColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0).cgColor
        self.btnResendSms.layer.cornerRadius = 16
        self.btnResendSms.layer.borderWidth = 1
        self.btnResendSms.layer.borderColor = ColorPalette.getirBorder.cgColor
        self.btnResendSms.clipsToBounds = true
        self.btnResendSms.isHidden = true
        
        self.onayKoduLbl.text = Localization.OTPApproveLabel.local
        self.onayKoduLbl.textColor = ColorPalette.commonTextColor()
        
        self.lblDescription.font =  FontHelper.otp.timerLbl
        self.lblDescription.textColor = ColorPalette.commonTextColor()
        
        if let regData = loginResponseModel?.result, let gsm = regData.gsm{
            
            var tempGsm = gsm
            
            tempGsm = FormatUtil.format(gsm.uppercased(), template: Constants.FormatTemplate.mobilePhoneTemplate, isMasked: true)!
            tempGsm = tempGsm.remove("|")
            
            let tempStr = Localization.OTPDescriptionWithGsm.local.replace("%1$s", replacement: tempGsm)
            
            let attText = tempStr.htmlAttributed(withRegularFont: FontHelper.otp.timerLbl, andBoldFont: UIFont(name: "Montserrat-Bold", size: 14)!)
            
            let range = (tempStr as NSString).range(of: tempStr)
            
            //attText.addAttribute(.foregroundColor, value: ColorPalette.commonTextColor(), range: range)
            
            self.lblDescription.attributedText = attText
            
            self.lblDescription.textColor = ColorPalette.commonTextColor()
        }
        
        self.lblTimer.textColor = ColorPalette.commonTextColorGrayishInDarkmode()//ColorPalette.otp.lblTimer
        self.lblTimer.font =  FontHelper.otp.timerLbl
        
        initializeTimer()
        
        self.title = Localization.OTPTitle.local
    }
    
    @objc func updateTimeUI()
    {
        if (self.timeCount > 0){
            self.timeCount -= 1
            lblTimer.text = Localization.OTPSecondText.local.replace("%1$s", replacement: String(self.timeCount))
        }else{
            timer?.invalidate()
            self.state = .reSend
        }
    }
    
    
    fileprivate func initializeTimer(){
        
        let constantTime: Int = Multipay.testModeActive ? 10 : 180
        
        if let data = loginResponseModel?.result ,  let remainTime  = data.remainingTime{
            self.timeCount = (remainTime < 1) ? constantTime : remainTime
        }
        
        else{
            self.timeCount = constantTime
        }
        
        lblTimer.text = Localization.OTPSecondText.local.replace("%1$s", replacement: String(self.timeCount))
        log.debug("time \(self.timeCount) - \(String(describing: self.lblTimer.text))")
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(showKeyboard), userInfo: nil, repeats: false)
    }
    
    @objc func showKeyboard() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeUI), userInfo: nil, repeats: true)
    }
    
    //Confirm Otp Sms
    @IBAction func confirmOtp(_ sender: AnyObject) {
        
        if (!otpView.validate()) {
            self.state = OTPState.reSend
            return
        }
        
        if Multipay.testModeActive{
            self.otpEndProcess(nil, otpResponseModel:nil)
            return
        }
        
        //MARK : validation
        let parameters = [verificationCodeKey   : loginResponseModel?.result?.verificationCode,
                          smsCodeKey : smsCode]
        
        post(ServiceConstants.ServiceName.SdkOtpConfirm, isSdkService: true, parameters: parameters  as [String:AnyObject], displayError: false, isSecure: false , callback: { [weak self](data: [String:AnyObject]?, rawData) in
            if let strongSelf = self{
                //log.debug("data : \(String(describing: data))")
                
                if let rawData = rawData{
                    do{
                        let modelObject = try rawData.decoded() as OtpConfirmResponse
                        strongSelf.otpConfirmResponse = modelObject
                        if let authToken = modelObject.result?.authToken{
                            //Multipay.delegate?.multipayLoginDidComplete(authToken: authToken)
                        }
                    }
                    catch{
                        print("error: \(error)")
                    }
                }
                
                if let responseData  = data {
                    let serviceResultCodeType = strongSelf.checkResultCodeAndShowError(responseData,showMessage: Multipay.testModeActive ? false : true)
                    
                    if serviceResultCodeType == .maxRetryCountReached {
                        strongSelf.timer?.invalidate()
                        strongSelf.state = .reSend
                        strongSelf.otpView.txtInput.text = ""
                    }
                    
                    if serviceResultCodeType != ServiceResultCodeType.continue {
                        if Multipay.testModeActive {
                            strongSelf.otpEndProcess(nil, otpResponseModel:nil)
                        }
                        return
                    }
                    
                    strongSelf.otpEndProcess(responseData,otpResponseModel:strongSelf.otpConfirmResponse)
                }
            }
            
        },errorCallback: {
            [weak self] (data, rawData) in
            
            guard let self = self else {
                return
            }
            
            if Multipay.testModeActive{
                self.otpEndProcess(nil, otpResponseModel:nil)
            }
            
            log.error("error : \(data.description)")
        })
    }
    
    fileprivate func otpEndProcess(_ responseData:[String:AnyObject]?, otpResponseModel: OtpConfirmResponse?){
        
        // self.view.userInteractionEnabled = false
        var message:String? = nil
        
        if let responseModel = otpResponseModel, let result = responseModel.result {
            if let usermessage =  responseModel.resultMessage {
                message = usermessage
            }
            
            if let authToken = result.authToken{
                Auth.authToken = authToken
            }
        }
        
        if let informMessage = message, informMessage.count > 0
        {
            showMessage(MessageType.info, message: message!, block: {
                self.navigate(otpResponseModel)
            })
        }else{
            self.navigate(otpResponseModel)
        }
    }
    
    fileprivate func navigate(_ responseData:OtpConfirmResponse?){
        
        if(responseData != nil){
            if let result = responseData!.result
            {
                if let authToken = result.authToken{
                    Auth.authToken = authToken
                }
            }
        }
        
        if ( OTPCalledType.loginWithOTP == self.otpCalledType) {
            gotoDashboard()
            return
        }
        
        else if ( OTPCalledType.register == self.otpCalledType) {
            gotoAddCard()
            return
        }
        
        self.navigationController?.viewControllers[0].dismiss(animated: true, completion: nil)
    }
    
}


extension OTPVC {
    
    //ResendOtpSms
    @IBAction func resendOTP() {
        
        let postDict = loginRequestParameters!
        
        post(resendServiceName, parameters: postDict as [String:AnyObject], displayError: false, isSecure: false, callback: { [weak self](data: [String:AnyObject]?, rawData) in
            if let strongSelf = self
            {
                log.debug("data : \(data!)")
                strongSelf.processResendService(postDict: postDict, data: data, rawData: rawData)
            }
            
        },errorCallback: {
            [weak self] (data, rawData) in
            log.error("error : \(data.description)")
            if let strongSelf = self{
                if Multipay.testModeActive{
                    strongSelf.processResendService(postDict: postDict, data: nil, rawData: nil)
                }
                else{
                    strongSelf.showMessage(MessageType.error, message: data.description)}
            }
        })
    }
    
    private func processResendService(postDict: [String:AnyObject]?, data: [String:AnyObject]?, rawData: Data?){
        
        if let responseData  = data {
            
            if  self.checkResultCodeAndShowError(responseData, showMessage: false) == ServiceResultCodeType.exit {
                return
            }
            
            if let data = rawData {
                do{
                    let modelObject = try data.decoded() as LoginResponseModel
                    self.loginResponseModel = modelObject
                    self.loginRequestParameters = postDict
                }
                catch{
                    print("error: \(error)")
                }
            }
        }
        
        self.state = .normal
    }
}

extension OTPVC {
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, textView: InputTextView) -> Int {
        
        guard textField.text != nil  else {
            return TextFieldShouldChangeCharactersInRangeType.runningFalse.rawValue
        }
        
        if(string == "") || textField.text!.count <= 5 {
            return TextFieldShouldChangeCharactersInRangeType.runningTrue.rawValue
        }
        
        return TextFieldShouldChangeCharactersInRangeType.runningFalse.rawValue
        
    }
    
    override func textFieldDidEndEditing(_ textField: MTextField, textView: InputTextView?) {
        
        if textField.text?.length == 6{
            // Send user's entered pin to server
            confirmOtp(self)
        }else{
            
        }
    }
    
    override func textFieldShouldReturn(textField: MTextField,textView:InputTextView?) {
        
        self.view.endEditing(true)
    }
    
}

//MARK: - StoryboardInstantiable
extension OTPVC: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "OTPVC" }
}


//MARK: DigitInputView
extension OTPVC: DigitInputViewDelegate {
    
    public func digitsDidChange(digitInputView: DigitInputView) {
        let code = digitInputView.text
        
        smsCode = code
        
        if code.count == 6 {
            confirmOtp(self)
        }
    }
    
}
