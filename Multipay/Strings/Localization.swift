
import Foundation

class Localization {
    
    static fileprivate func getLocalizedStringFor(_ key: String?) -> String {
        if key == nil || key == "" {
            return ""
        }
        
        let bundleURL = Bundle(for: Localization.self).resourceURL?.appendingPathComponent("\(Strings.bundleName).bundle")
        
        guard let bundle =  Bundle(url: bundleURL!) else {
            return ""
        }
        
        return NSLocalizedString(key!, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    
    static func getLocalizedString(_ key: String?, args: [AnyObject]? = nil) -> String {
        
        let value  = Localization.getLocalizedStringFor(key)
        return value
        
    }
}

extension Localization {
    
    //Error
    static let Error1005                                            =   "error_1005_multipay_sdk"
    static let Error1001                                            =   "error_1001_multipay_sdk"
    static let ErrorHttp                                            =   "error_http_multipay_sdk"
    static let ErrorSystem                                          =   "error_system_multipay_sdk"
    
    //Common
    static let Continue                                             =   "common_continue_button_multipay_sdk"
    static let Save                                                 =   "common_save_button_multipay_sdk"
    static let Cancel                                               =   "common_cancel_button_multipay_sdk"
    static let CancelButton2                                        =   "common_cancel_button2_multipay_sdk"
    static let ClearButton                                          =   "common_clear_button_multipay_sdk"
    
    
    static let Ok                                                   =   "common_ok_button_multipay_sdk"
    static let Done                                                 =   "common_done_button_multipay_sdk"
    static let Send                                                 =   "common_send_button_multipay_sdk"
    static let Other                                                =   "common_other_button_multipay_sdk"
    static let CloseButton                                          =   "common_close_button_multipay_sdk"
    
    static let Success                                              =   "common_succes_multipay_sdk"
    static let Info                                                 =   "common_info_multipay_sdk"
    static let Warning                                              =   "common_warning_multipay_sdk"
    static let WarningCaps                                          =   "common_warning_caps_multipay_sdk"
    static let Error                                                =   "common_error_multipay_sdk"
    static let ErrorMessage                                         =   "common_error_message_multipay_sdk"
    static let Retry                                                =   "common_retry_multipay_sdk"

    static let CommonInfoNoDataFound                                =   "common_info_nodatafound_multipay_sdk"

    //Alert
    static let AlertDone                                            =   "alert_done_multipay_sdk"
    static let AlertCancel                                          =   "alert_cancel_multipay_sdk"
    
    
    //Validation
    static let ValidationEmail                                      =   "validation_email_multipay_sdk"
    static let ValidationPassword                                   =   "validation_password_multipay_sdk"
    static let ValidationPhone                                      =   "validation_gsm_multipay_sdk"
    static let ValidationName                                       =   "validation_name_multipay_sdk"
    static let ValidationSurname                                    =   "validation_surname_multipay_sdk"
    static let ValidationCardNumber                                 =   "validation_card_number_multipay_sdk"
    static let ValidationContract                                   =   "validation_contract_multipay_sdk"
    static let ValidationKVKK                                       =   "validation_kvkk_multipay_sdk"
    static let ValidationOTP                                        =   "validation_otp_multipay_sdk"
    static let ValidationEmailOrGSM                                 =   "validation_email_or_gsm_multipay_sdk"

    //Login
    static let LoginEmailOrGSM                                      =   "login_email_or_gsm_multipay_sdk"
    static let LoginPassword                                        =   "login_password_multipay_sdk"
    static let LoginButton                                          =   "login_top_title_multipay_sdk"
    static let LoginRegister                                        =   "login_register_multipay_sdk"
    static let LoginForgetPasswordText                              =   "login_forget_password_text_multipay_sdk"
    static let LoginWithActivationCodeBtnText                       =   "login_activation_text_multipay_sdk"
    static let LoginWithActivationTitle                             =   "login_top_title_multipay_sdk"
    static let LoginWithActivationLabelText                         =   "login_info_title_multipay_sdk"
    static let LoginWithActivationCodeInputPlaceholder              =   "otp_description_multipay_sdk"
    static let LoginWithActivationCodeInputError                    =   "LoginWithActivation.CodeInputLabelError"
    static let LoginWithActivationButtonText                        =   "LoginWithActivation.ButtonText"
    static let LoginWithActivationEnterValidCode                    =   "LoginWithActivation.EnterValidCode"
    static let LoginTopTitle                                        =   "login_top_title_multipay_sdk"
    static let LoginTopInfoTitle                                    =   "login_info_title_multipay_sdk"
    
    static let LoginWithActivationSetPasswordTitle                  =   "LoginWithActivationSetPassword.Title"
    static let LoginWithActivationSetPasswordInfoLabel              =   "LoginWithActivationSetPassword.InfoLabel"
    static let LoginWithActivationSetPasswordUsernameLabel          =   "LoginWithActivationSetPassword.UserNameLabel"
    static let LoginWithActivationSetPasswordUsernameLabelBold      =   "LoginWithActivationSetPassword.UserNameLabelBold"
    static let LoginWithActivationSetPasswordGSMLabel               =   "LoginWithActivationSetPassword.GSMLabel"
    static let LoginWithActivationSetPasswordGSMLabelBold           =   "LoginWithActivationSetPassword.GSMLabelBold"
    static let LoginWithActivationSetPasswordEmailLabel             =   "LoginWithActivationSetPassword.EmailLabel"
    static let LoginWithActivationSetPasswordEmailLabelBold         =   "LoginWithActivationSetPassword.EmailLabelBold"
    static let LoginWithActivationSetPasswordSetButton              =   "LoginWithActivationSetPassword.SetButton"
    
    // Add Card
    
    static let AddCardCardName                                      =   "add_card_card_alias_multipay_sdk"
    static let AddCardCVVInfoLabel                                  =   "add_card_card_description_multipay_sdk"
    static let AddCardTitle                                         =   "add_card_navigation_title_multipay_sdk"
    static let AddCardCardNumber                                    =   "add_card_card_number_multipay_sdk"
    
    //Wallet
    
    static let WalletTopInfoText                                    =   "wallet_description_multipay_sdk"
    static let WalletTitle                                          =   "wallet_navigation_title_multipay_sdk"
    static let WalletSynchroniseButton                              =   "wallet_match_multipay_sdk"
    static let WalletAddCardButton                                  =   "wallet_add_wallet_multipay_sdk"
    static let WalletSumBalance                                     =   "wallet_item_balance_description_multipay_sdk"
    
    //Register
    static let RegisterHeader                                       =   "register_header_multipay_sdk"
    static let RegisterName                                         =   "register_name_multipay_sdk"
    static let RegisterLastname                                     =   "register_lastname_multipay_sdk"
    static let RegisterEmail                                        =   "register_email_multipay_sdk"
    static let RegisterGsm                                          =   "register_gsm_multipay_sdk"
    static let RegisterPassword                                     =   "register_password_multipay_sdk"
    static let RegisterContract                                     =   "register_contract_multipay_sdk"
    static let RegisterContractText                                 =   "register_contract_text_multipay_sdk"
    static let RegisterFacebook                                     =   "register_facebook_multipay_sdk"
    static let RegisterInformHeaderLabel                            =   "register_inform_header_label_multipay_sdk"
    static let RegisterInformTextLabel                              =   "register_inform_text_label_multipay_sdk"
    static let RegisterKVKKHeaderLabel                              =   "register_kvkk_header_label_multipay_sdk"
    static let RegisterKVKKTextLabel                                =   "register_kvkk_text_label_multipay_sdk"
    static let RegisterPersonalInfoLabelText                        =   "register_personal_info_label_text_multipay_sdk"
    static let RegisterSecurityInfoLabelText                        =   "register_security_info_label_text_multipay_sdk"
    
    //OTP
    static let OTPDescriptionWithGsm                                =   "otp_description_multipay_sdk"
    static let OTPSMSCode                                           =   "otp_sms_code_multipay_sdk"
    static let OTPSecondText                                        =   "otp_remaining_time_multipay_sdk"
    static let OTPResendButton                                      =   "otp_resend_multipay_sdk"
    static let OTPApproveLabel                                      =   "otp_approve_label_multipay_sdk"
    static let OTPTitle                                             =   "otp_navigation_title_multipay_sdk"

    //FORGOT PASSWORD
    static let ForgotPasswordHeader                                     = "forgot_password_header_multipay_sdk"
    static let ForgotPasswordDescription                                = "forgot_password_description_multipay_sdk"
    static let ForgotPasswordButton                                     = "forgot_password_button_multipay_sdk"
    
    //CHANGE PASSWORD
    static let ChangePasswordNewPassword                                = "ChangePassword.NewPassword"
    static let ChangePasswordReNewPassword                              = "ChangePassword.ReNewPassword"
    static let ChangePasswordHeader                                     = "ChangePassword.Header"
    static let ChangePasswordPasswordInfo                               = "ChangePassword.PasswordRestrictionsInfo"
    static let ChangePasswordPassword                                   = "ChangePassword.Password"
    static let ChangePasswordErrorPasswordLengthIsNotSuitable           = "ChangePassword.Error.PasswordLengthIsNotSuitable"
    static let ChangePasswordErrorPasswordsIsNotEqual                   = "ChangePassword.Error.PasswordsIsNotEqual"

    //WALLET
    static let WalletAvailableBalance                                   = "wallet_item_balance_description_multipay_sdk"
    static let WalletAvailableLimit                                     = "Wallet.AvailableLimit"
    static let WalletWaitingBalance                                     = "Wallet.WaitingBalance"
    static let WalletWaitingLimit                                       = "Wallet.WaitingLimit"
    static let WalletAddCardCvvInformation                              = "wallet_addcard_cvv_info_multipay_sdk"
    static let AddCardCardNumbers                                       = "AddCard.Manually.CardNumbers"

    static let ProfileAndSettingsPersonalInfoHeader         = "ProfileAndSettings.PersonalInfoHeader"
    static let ProfileAndSettingsPersonalInfoSettings       = "ProfileAndSettings.PersonalInfoSettings"
    static let ProfileAndSettingsChangePassword             = "ProfileAndSettings.ChangePassword"
    static let ProfileAndSettingsPaymentSettingsHeader      = "ProfileAndSettings.PaymentSettingsHeader"
    static let ProfileAndSettingsPIN                        = "ProfileAndSettings.PIN"
    static let ProfileAndSettingsNotificationSettingsHeader    = "ProfileAndSettings.NotificationSettingsHeader"
    static let ProfileAndSettingsNotificationChannels       = "ProfileAndSettings.NotificationChannels"
    static let ProfileAndSettingsAboutAppHeader             = "ProfileAndSettings.AboutAppHeader"
    static let ProfileAndSettingsAgreement                  = "ProfileAndSettings.Agreement"
    static let ProfileAndSettingsKvkk                       = "ProfileAndSettings.Kvkk"
    static let ProfileAndSettingsFAQ                        = "ProfileAndSettings.FAQ"
    static let ProfileAndSettingsContactUs                  = "ProfileAndSettings.ContactUs"
    static let ProfileAndSettingsLanguage                   = "ProfileAndSettings.Language"
    static let ProfileAndSettingsSignOut                    = "ProfileAndSettings.SignOut"
    static let ProfileAndSettingsTopUpOrder                 = "ProfileAndSettings.TopUpOrder"

    //PIN
    static let PinHeader                    = "Pin.Header"

    static let PinHeaderDefine              = "Pin.HeaderDefine"
    static let PinEnter                     = "Pin.Enter"
    static let PinReEnter                   = "Pin.ReEnter"
    static let PinSuccess                   = "Pin.Success"
    static let PinFailed                    = "Pin.Failed"

    //AGREEMENT
    static let AgreementHeader                  = "Agreement.Header"
    static let AgreementOkButton                = "Agreement.OkButton"
    static let AgreementCancelButton            = "Agreement.CancelButton"

    static let AgreementKVKKError               = "Agreement.KVKK.ErrorMessage"

}

