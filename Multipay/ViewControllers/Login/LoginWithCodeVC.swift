//
//  LoginWithCodeVC.swift
//  MultiPay
//
//  Created by Orhan Aykut Kardeş on 6.08.2019.
//  Copyright © 2019 inventiv. All rights reserved.
//

import UIKit

class LoginWithCodeVC: BaseVC {
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var activationView: InputTextView!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationViewType = .withLeftButton
        self.navigationEditionType = .whiteEditionType
        self.title = Localization.LoginWithActivationTitle.local

        self.view.backgroundColor = ColorPalette.vcBackground

        activationView.initView(
            placeholder: Localization.LoginWithActivationCodeInputPlaceholder.local,
            delegate: self,
            errorMessage: Localization.LoginWithActivationCodeInputError.local,
            editionType: .inputEditionTypeBlack
        )

        btnLogin.roundedCorners(cornerRadius: 5.0)
        btnLogin.titleLabel?.font = FontHelper.LoginWithActivation.sendCodeButton
        btnLogin.setTitleColor(ColorPalette.ActivationWithCode.activationCodeSendButtonText, for: .normal)
        btnLogin.setTitle(Localization.LoginWithActivationButtonText.local, for: .normal)
        btnLogin.backgroundColor = ColorPalette.ActivationWithCode.activationCodeSendButtonBackground

        descriptionLbl.textColor = ColorPalette.ActivationWithCode.activationCodeLabelText
        descriptionLbl.text = Localization.LoginWithActivationLabelText.local
        descriptionLbl.font = FontHelper.LoginWithActivation.enterActivationLabel
    }

    @IBAction func sendBtnTapped(_ sender: UIButton) {
        callLoginWithActivationCodeService()
    }

    override func textFieldShouldReturn(textField: MTextField, textView: InputTextView?) {
        callLoginWithActivationCodeService()
    }

    func validateActivationCode() -> Bool {
        let activationCode = activationView.textValue()
        return activationCode.length >= 4 && activationCode.length <= 20
    }

    func callLoginWithActivationCodeService() {
        if !self.validateActivationCode() {
            self.showMessage(.error, message: Localization.LoginWithActivationEnterValidCode.local)
            return
        }

        let parameters = ["ActivationCode" : activationView.textValue()]

        post(ServiceConstants.ServiceName.LoginWithActivationCode, parameters: parameters as [String: AnyObject] , displayError: false, callback: {[weak self] (data: [String: AnyObject]?, rawData) in
            guard let strongSelf = self else { return }

            if let data  = data {
                if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                    return
                }

                if let result = data[resultKey] {
                    CoreManager.instance.user =  UserInfo.getUser(result)

                }

                LoggerHelper.logger.debug("response: \(data)")
                LoggerHelper.logger.debug("user : \(CoreManager.instance.user!)")

                let vc = LoginWithCodeSetPasswordVC.instantiate()
                vc.user = CoreManager.instance.user
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            }, errorCallback: {(error: ErrorModel, rawData) in
                self.showMessage(.error, message: error.description)
        })
    }

}

// MARK: - StoryboardInstantiable
extension LoginWithCodeVC: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "LoginWithCodeVC" }
}
