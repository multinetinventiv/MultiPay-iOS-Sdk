//
//  ResetPasswordVC.swift
//  MultiU
//
//  Created by  on 27/05/16.
//  Copyright © 2016 . All rights reserved.
//

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



class ResetPasswordVC: BaseVC {

    
    @IBOutlet weak var btnEmailLogin: UIButton!
    @IBOutlet weak var inputTextView: InputTextView!
    @IBOutlet weak var lblDesc: MTLabel!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var logoImageViewTop: NSLayoutConstraint!
    var userID:String?
    
    deinit{
        LoggerHelper.logger.debug("")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType
        self.hasKeyboard = true
        self.title = Localization.ForgotPasswordHeader.local
        
        inputTextView.initView(placeholder:Localization.LoginEmailOrGSM.local,
                               regex: Regex.kEmail,
                               lastFieldOnForm:true,
                               delegate:self,
                               errorMessage:Localization.ValidationEmail.local,
                               inputFieldType:InputFieldType.inputEmailWithPhone,
                               editionType:InputEditionType.inputEditionTypeBlack)
        
        self.btnEmailLogin.setTitle(Localization.ForgotPasswordButton.local, for: UIControl.State())
        self.btnEmailLogin.titleLabel!.font = FontHelper.resetPassword.emailBtnTitle
        self.btnEmailLogin.titleLabel?.textColor = ColorPalette.resetPassword.emailBtnTitleColor
        self.btnEmailLogin.backgroundColor = ColorPalette.resetPassword.emailBtnBackground
        self.lblDesc.text = Localization.ForgotPasswordDescription.local
        self.lblDesc.textColor = ColorPalette.resetPassword.descriptionLbl
        self.lblDesc.font = FontHelper.resetPassword.desc
        self.view.backgroundColor = ColorPalette.resetPassword.background
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = userID {
            inputTextView.txtInput.text = id
        }
        if (DeviceType.IS_IPHONE_4_OR_LESS) {
            UIView.animate(withDuration: 0.1, animations: {
                
                self.logoImageViewTop.constant = 30
                self.view.layoutIfNeeded()
                
                }, completion: { (finished) in
            })
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputTextView.becomeFirstResponder()
    }
    
    //MARK: - Buttons
    @IBAction func buttonClicked(_ sender: UIButton) {
        resetClicked(sender)
    }
    

    
    override func keybordWillBeShow(_ notification: Notification)
    {
        super.keybordWillBeShow(notification)
        if(DeviceType.IS_IPHONE_4_OR_LESS) {
            UIView.animate(withDuration: 0.3, animations: {
                self.logoImageView.alpha = 0.2
            }) 
        }
    }
    
    override func keyboardWillHide(_ notification: Notification)
    {
        super.keyboardWillHide(notification)
        if(DeviceType.IS_IPHONE_4_OR_LESS) {
            UIView.animate(withDuration: 0.3, animations: {
                self.logoImageView.alpha = 1
            }) 
        }
    }
        
}

extension ResetPasswordVC  {
    
    override func textFieldShouldReturn(textField: UITextField,textView:InputTextView? = nil) {
        inputTextView.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard textField.text != nil else {
            return true
        }
        
        if(string == "") {
            return true
        }
        
        let mtextField = textField as! MTextField
        
        if(Localization.LoginEmailOrGSM.local == mtextField.getFieldTitle())
        {
            
            if string.contains("|") || string.contains("*") || string.contains("~") {
                return false
            }
            
            if (string.isContainsLetterChars() || (mtextField.text?.isContainsLetterChars())!)
            {
                mtextField.text = textField.text?.remove("~").remove("(").remove(")").remove("*").remove("|").remove(" ")
                mtextField.replaceNSRange(range: range, withText: string)
                
                
            }else{
                var text = mtextField.text
                text = text?.clearNonNumeric()
                if (text?.length > 9 && string != ""){
                    return false
                }
                
                
                mtextField.textWithCaret = FormatUtil.format(textField.textWithCaret.uppercased(), template: Constants.FormatTemplate.mobilePhoneTemplate)!
                return  text?.length <= 9
                
            }
            
            return false
            
        }
        return true
    }

    func  isValid() -> Bool {
        
        if (!inputTextView.validate())
        {
            showMessage(inputTextView.getErrorMessage())
            return false
        }
        
        return  true
    }

    
    
    func resetClicked(_ sender: AnyObject) {
        
        if (!isValid()) {
            return
        }
        
        
        let emailText = inputTextView.textValue()
        let isEmail = emailText.length > 0 && emailText.isContainsLetterChars()
        
        
        let reset = ["Email"   : isEmail ? inputTextView.textValue() : "",
                       "Gsm"     : emailText.clearNonNumeric().getGsmNumber()
        ]
        let parameters = ["remindPasswordInfo" : reset]
        
        
        post(ServiceConstants.ServiceName.RemindPassword, parameters: parameters as [String : AnyObject] , displayError: false, callback:
            {
                [weak self](data:[String:AnyObject]?, rawData)
                
                in
                if let strongSelf = self
                {
                    if let data  = data {
                        
                        LoggerHelper.logger.debug("data : \(data)")
                        
                        if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                            return
                        }
                        
                        if let result = data[resultKey],  let message = result["UserMessage"]  {
                            strongSelf.navigationController?.popViewController(animated: true)
                            strongSelf.showMessage( message as! String)
                            strongSelf.navigationController?.popViewController(animated: true)
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
                LoggerHelper.logger.error("error : \(data.description)")
            })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
}
extension ResetPasswordVC: StoryboardInstantiable {
    
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "ResetPasswordVC" }
}
