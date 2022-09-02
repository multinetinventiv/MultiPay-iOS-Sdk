//
//  ValidateActivationCodeVC.swift
//  MultiPay
//
//  Created by Orhan Aykut Kardeş on 8.08.2019.
//  Copyright © 2019 inventiv. All rights reserved.
//

import UIKit

class LoginWithCodeSetPasswordVC: BaseVC {
    @IBOutlet weak var userInfoHeadLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userGsmLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!

    @IBOutlet weak var passwordView: InputTextView!
    @IBOutlet weak var repasswordView: InputTextView!

    @IBOutlet weak var btnSetPassword: UIButton!

    var user: UserInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType

        self.view.backgroundColor = ColorPalette.vcBackground
        self.title = Localization.LoginWithActivationSetPasswordTitle.local

        initInfoLabels()
        initInputViews()

        btnSetPassword.roundedCorners(cornerRadius: 5.0)
        btnSetPassword.titleLabel?.font = FontHelper.LoginWithActivation.setPasswordBtn
        btnSetPassword.setTitle(Localization.LoginWithActivationSetPasswordSetButton.local, for: .normal)
        btnSetPassword.titleLabel?.textColor = ColorPalette.ActivationWithCode.setPasswordSetButton
        btnSetPassword.backgroundColor = ColorPalette.ActivationWithCode.setPasswordSetButtonBackground
    }

    fileprivate func initInfoLabels() {
        userInfoHeadLabel.font = FontHelper.LoginWithActivation.userInfoHeader
        userInfoHeadLabel.text = Localization.LoginWithActivationSetPasswordInfoLabel.local
        userInfoHeadLabel.textColor = ColorPalette.ActivationWithCode.setPasswordUserInfoLabel

        var userName = ""

        if let name = user?.name {
            userName += name
        }

        if let surname = user?.surname {
            userName += " " + surname
        }

        userNameLabel.font = FontHelper.LoginWithActivation.setPasswordNormalForLabels
        userNameLabel.textColor = ColorPalette.ActivationWithCode.setPasswordUserInfoLabel
        userNameLabel.attributedText = getAttributedStringWithEditedPart(
            of: String(format: Localization.LoginWithActivationSetPasswordUsernameLabel.local, userName),
            partToEdit: Localization.LoginWithActivationSetPasswordUsernameLabelBold.local,
            withFont: FontHelper.LoginWithActivation.setPasswordBoldForLabels
        )

        if let gsm = user?.gsm {
            userGsmLabel.font = FontHelper.LoginWithActivation.setPasswordNormalForLabels
            userGsmLabel.textColor = ColorPalette.ActivationWithCode.setPasswordUserInfoLabel
            userGsmLabel.attributedText = getAttributedStringWithEditedPart(
                of: String(format: Localization.LoginWithActivationSetPasswordGSMLabel.local, gsm),
                partToEdit: Localization.LoginWithActivationSetPasswordGSMLabelBold.local,
                withFont: FontHelper.LoginWithActivation.setPasswordBoldForLabels
            )
        }

        if let mail = user?.email {
            userEmailLabel.font = FontHelper.LoginWithActivation.setPasswordNormalForLabels
            userEmailLabel.textColor = ColorPalette.ActivationWithCode.setPasswordUserInfoLabel
            userEmailLabel.attributedText = getAttributedStringWithEditedPart(
                of: String(format: Localization.LoginWithActivationSetPasswordEmailLabel.local, mail),
                partToEdit: Localization.LoginWithActivationSetPasswordEmailLabelBold.local,
                withFont: FontHelper.LoginWithActivation.setPasswordBoldForLabels
            )
        }
    }

    func initInputViews() {
        passwordView.initView(
            placeholder: Localization.ChangePasswordNewPassword.local,
            minValu: Regex.kPasswordMin,
            maxValue: Regex.kPasswordMax,
            lastFieldOnForm: false,
            delegate: self,
            errorMessage: Localization.ValidationPassword.local,
            secureField: true,
            inputFieldType: InputFieldType.inputPassword,
            editionType: InputEditionType.inputEditionTypeBlack,
            toolbarType: .next
        )

        repasswordView.initView(
            placeholder: Localization.ChangePasswordReNewPassword.local,
            minValu: Regex.kPasswordMin,
            maxValue: Regex.kPasswordMax,
            lastFieldOnForm: true,
            delegate: self,
            errorMessage: Localization.ValidationPassword.local,
            secureField: true,
            inputFieldType: InputFieldType.inputPassword,
            editionType: InputEditionType.inputEditionTypeBlack,
            toolbarType: .done
        )
    }

    fileprivate func getAttributedStringWithEditedPart(of string: String, partToEdit: String, withFont font: UIFont) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(string: string)
        let highlightedSubStringRange = string.range(of: partToEdit)
        let range = string.NSRangeFromRange(highlightedSubStringRange!)

        mutableString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        return mutableString
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        callSetPasswordService()
    }

    override func textFieldShouldReturn(textField: MTextField, textView: InputTextView?) {
        callSetPasswordService()
    }

    override func textFieldShouldNext(textField: MTextField, textView: InputTextView?) {
        if textView == self.passwordView {
            repasswordView.becomeFirstResponder()
        }
    }
    
    fileprivate func callSetPasswordService() {
        if (!isValid()) {
            return
        }

        let parameters = ["Password" : passwordView.textValue()]

        post(
            ServiceConstants.ServiceName.SetPassword,
            parameters: parameters as [String : AnyObject],
            displayError: false,
            callback: {(data: [String: AnyObject]?, _) in
                guard let data = data else {
                    self.showMessage(.error, message: Localization.ErrorSystem.local)
                    return
                }

                LoggerHelper.logger.debug("data : \(data)")

                if self.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                    return
                }

                if let result = data[resultKey] {
                    CoreManager.instance.user =  UserInfo.getUser(result)

                }

                LoggerHelper.logger.debug("user : \(CoreManager.instance.user!)")

                if let user = CoreManager.instance.user, user.isGsmVerified ?? false {
                    DispatchQueue.main.async {
                        CoreManager.Instance().getUser()
                        self.gotoDashboard()
                    }
                }
            }, errorCallback: {(data: ErrorModel, rawData) in
                self.showMessage(.error, message: data.description)
        })
    }
    
    fileprivate func isValid() -> Bool {
        if !passwordView.validate() {
            showMessage(.error, message: passwordView.getErrorMessage())
            return false
        }

        if !repasswordView.validate() {
            showMessage(.error, message: repasswordView.getErrorMessage())
            return false
        }

        if passwordView.textValue() != repasswordView.textValue() {
            showMessage(MessageType.error, message: Localization.ChangePasswordErrorPasswordsIsNotEqual.local)
            return false
        }

        return true
    }

}

// MARK: - StoryboardInstantiable
extension LoginWithCodeSetPasswordVC: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "ValidateActivationCodeVC" }
}
