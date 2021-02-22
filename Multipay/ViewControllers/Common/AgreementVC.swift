//
//  AgreementVC.swift
//  MultiPay
//
//  Created by Göktuğ Aral on 22/09/16.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

@objc enum AgreementViewType: Int {
    case none
    case profile //iç ekran
    case register //kayıt olma
    case error //hata kodu gelince
    case kvkk
    case kvkkWithNoButtons
    case kvkkRegister
    case virtualCard
}

protocol AgreementViewDelegate :class {
    func agreedUserAgreementClicked(type: AgreementViewType)

    func disagreedUserAgreementClicked(type: AgreementViewType)
}

extension AgreementViewType {
    func disagreedUserAgreementClicked(type: AgreementViewType) {}
}

class AgreementVC: BaseVC {
    // Constraints
    @IBOutlet weak var constraintBottomContainerHeight: NSLayoutConstraint!

    // Outlets
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var webViewContainer: MTWebView!

    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var disagreeButton: UIButton!

    // Variables
    var agreementViewType:AgreementViewType = .none

    weak var delegate: AgreementViewDelegate?

    var virtualCardAggrementUrl :String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if (self.agreementViewType == AgreementViewType.profile || agreementViewType == AgreementViewType.kvkkWithNoButtons) {
            self.navigationViewType = NavigationType.withLeftButton
        } else if (self.agreementViewType == AgreementViewType.register) {
            self.navigationViewType = NavigationType.withRightButton
        } else if (self.agreementViewType == AgreementViewType.virtualCard) {
            self.navigationViewType = NavigationType.withRightButton
        } else {
            self.navigationViewType = NavigationType.withTitleOnly
        }

        self.navigationEditionType = .whiteEditionType
        self.title =  Localization.AgreementHeader.local

        initViewStyles()
        initView()
    }

    func initViewStyles() {
        disagreeButton.setTitle(Localization.AgreementCancelButton.local, for: UIControl.State())
        agreeButton.setTitle(Localization.AgreementOkButton.local, for: UIControl.State())
        self.view.backgroundColor = ColorPalette.agreement.backgroundColor
    }

    func initView() {
        if self.agreementViewType == AgreementViewType.virtualCard {
            self.webViewContainer.loadUrl(url: self.virtualCardAggrementUrl!)
        } else if (agreementViewType == AgreementViewType.kvkk || agreementViewType == AgreementViewType.kvkkWithNoButtons || agreementViewType == AgreementViewType.kvkkRegister), let kvkkUrl = CoreManager.Instance().setting.kvkkUrl {
            self.webViewContainer.loadUrl(url: kvkkUrl)
        } else if let stringUrl = CoreManager.Instance().setting.userAgreementUrl {
            self.webViewContainer.loadUrl(url: stringUrl)
        }

        if (self.agreementViewType == AgreementViewType.profile || self.agreementViewType == AgreementViewType.kvkkWithNoButtons) {
            self.bottomContainerView.alpha = 0;
            self.constraintBottomContainerHeight.constant = 0
        }
    }

    // MARK: - UIButton Actions
    @IBAction func disagreeButtonClicked(_ sender: AnyObject) {
        if (self.agreementViewType == AgreementViewType.profile) {
            self.navigationController?.popViewController(animated: true)
        } else if (self.agreementViewType == AgreementViewType.register || agreementViewType == AgreementViewType.kvkkRegister) {
            presentModalWillDismiss()
        } else if (self.agreementViewType == AgreementViewType.virtualCard) {
            presentModalWillDismiss()
        } else if self.agreementViewType == AgreementViewType.kvkk {
            self.logout()
            showMessage(.warning, message: Localization.AgreementKVKKError.local)
        }

        self.delegate?.disagreedUserAgreementClicked(type: agreementViewType)
    }
    
    @IBAction func agreeButtonClicked(_ sender: AnyObject) {
        if(AgreementViewType.error == agreementViewType) {
             self.requestAgreeTermsAndConditions()
        } else if (self.agreementViewType == AgreementViewType.register || agreementViewType == AgreementViewType.kvkkRegister) {
            self.delegate?.agreedUserAgreementClicked(type: agreementViewType)
            self.dismiss(animated: true, completion: nil)
        } else if agreementViewType == AgreementViewType.kvkk {
            requestAggreeKVKK()
        } else {
            self.delegate?.agreedUserAgreementClicked(type: agreementViewType)
            if self.agreementViewType == AgreementViewType.profile {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func requestAggreeKVKK() {
        post(ServiceConstants.ServiceName.MarkKVKKAsRead, parameters: ["" : "" as AnyObject] , displayError: false, displaySpinner: false, callback: { (data:[String:AnyObject]?, rawData) in
                //appDelegate.launchApplication()
            self.navigationController?.popToRootViewController(animated: true)
            }, errorCallback: {(data: ErrorModel, rawData) in
                log.debug("KVKK aggreement error \(data)")
            }
        )
    }
    
    func requestAgreeTermsAndConditions() {
        post(ServiceConstants.ServiceName.MarkCurrentUserAggrementAsRead, parameters: ["" : "" as AnyObject] , displayError: false, displaySpinner: false, callback: { [weak self] (data:[String:AnyObject]?, rawData) in
                if let strongSelf = self {
                    if let data = data {
                        log.debug("data : \(data)")

                        if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                            return
                        }

                        strongSelf.delegate?.agreedUserAgreementClicked(type: strongSelf.agreementViewType)

                        if (strongSelf.agreementViewType == AgreementViewType.profile) {
                            strongSelf.navigationController?.popViewController(animated: true)
                        } else {
                            strongSelf.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }, errorCallback: {(data: ErrorModel, rawData) in
                log.debug("User aggreement error \(data)")
            }
        )
    }
}

// MARK: - StoryboardInstantiable

extension AgreementVC: StoryboardInstantiable {
    static var storyboardName: String { return "Common" }
    static var storyboardIdentifier: String? { return "AgreementVC" }
}
