
import Foundation

class Localization {
    
    static fileprivate func getLocalizedStringFor(_ key: String?, comment: String = "") -> String {
        if key == nil || key == "" {
            return ""
        }
        
        return LocalizationManager.shared.localized(key!, comment: comment)
    }
    
    static func getLocalizedString(_ key: String?, args: [AnyObject]? = nil) -> String {
        
        let value  = Localization.getLocalizedStringFor(key)
        return value
        
    }
}

extension Localization {
    
    //Error
    static let Error1005                                            =   "Error.1005"
    static let Error1001                                            =   "Error.1001"
    static let ErrorHttp                                            =   "Error.Http"
    static let ErrorSystem                                          =   "Error.System"
    
    //Common
    static let Continue                                             =   "Common.ContinueButton"
    static let Save                                                 =   "Common.SaveButton"
    static let Cancel                                               =   "Common.CancelButton"
    static let CancelButton2                                        =   "Common.CancelButton2"
    static let ClearButton                                          =   "Common.ClearButton"
    
    
    static let Ok                                                   =   "Common.OkButton"
    static let Done                                                 =   "Common.DoneButton"
    static let Send                                                 =   "Common.SendButton"
    static let Other                                                =   "Common.OtherButton"
    static let CloseButton                                          =   "Common.CloseButton"
    
    static let Success                                              =   "Common.Succes"
    static let Info                                                 =   "Common.Info"
    static let Warning                                              =   "Common.Warning"
    static let WarningCaps                                          =   "Common.WarningCaps"
    static let Error                                                =   "Common.Error"
    static let ErrorMessage                                         =   "Common.Error.Message"
    static let Retry                                                =   "Common.Retry"

    static let CommonInfoNoDataFound                                =   "Common.Info.NoDataFound"

    //Alert
    static let AlertDone                                            =   "Alert.Done"
    static let AlertCancel                                          =   "Alert.Cancel"
    
    
    //Validation
    static let ValidationEmail                                      =   "validation_email"
    static let ValidationPassword                                   =   "validation_password"
    static let ValidationPhone                                      =   "validation_gsm"
    static let ValidationName                                       =   "validation_name"
    static let ValidationSurname                                    =   "validation_surname"
    static let ValidationCardNumber                                 =   "Validation.CardNumber"
    static let ValidationContract                                   =   "Validation.Contract"
    static let ValidationKVKK                                       =   "Validation.KVKK"
    static let ValidationOTP                                        =   "Validation.OTP"

    //Login
    static let LoginEmailOrGSM                                      =   "login_email_or_gsm"
    static let LoginPassword                                        =   "login_password"
    static let LoginButton                                          =   "login_button"
    static let LoginRegister                                        =   "Login.Register"
    static let LoginForgetPasswordText                              =   "login_forget_password_text"
    static let LoginWithActivationCodeBtnText                       =   "login_activation_text"
    static let LoginWithActivationTitle                             =   "LoginWithActivation.Title"
    static let LoginWithActivationLabelText                         =   "LoginWithActivation.LabelText"
    static let LoginWithActivationCodeInputPlaceholder              =   "LoginWithActivation.CodeInputLabel"
    static let LoginWithActivationCodeInputError                    =   "LoginWithActivation.CodeInputLabelError"
    static let LoginWithActivationButtonText                        =   "LoginWithActivation.ButtonText"
    static let LoginWithActivationEnterValidCode                    =   "LoginWithActivation.EnterValidCode"
    static let LoginTopTitle                                        =   "Login.TopTitle"
    static let LoginTopInfoTitle                                    =   "Login.InfoTitle"
    
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
    
    static let AddCardCardName                                      =   "add_card_card_alias"
    static let AddCardCVVInfoLabel                                  =   "add_card_card_description"
    static let AddCardTitle                                         =   "add_card_navigation_title"
    static let AddCardCardNumber                                    =   "add_card_card_number"
    
    //Wallet
    
    static let WalletTopInfoText                                    =   "wallet_description"
    static let WalletTitle                                          =   "wallet_navigation_title"
    static let WalletSynchroniseButton                              =   "wallet_match"
    static let WalletAddCardButton                                  =   "wallet_add_wallet"
    static let WalletSumBalance                                     =   "wallet_item_balance_description"
    
    //Register
    static let RegisterHeader                                       =   "Register.Header"
    static let RegisterName                                         =   "Register.Name"
    static let RegisterLastname                                     =   "Register.Lastname"
    static let RegisterEmail                                        =   "Register.Email"
    static let RegisterGsm                                          =   "Register.GSM"
    static let RegisterPassword                                     =   "Login.Password"
    static let RegisterContract                                     =   "Register.Contract"
    static let RegisterContractText                                 =   "Register.ContractText"
    static let RegisterFacebook                                     =   "Register.Facebook"
    static let RegisterInformHeaderLabel                            =   "Register.Inform.Header.Label"
    static let RegisterInformTextLabel                              =   "Register.Inform.Text.Label"
    static let RegisterKVKKHeaderLabel                              =   "Register.Kvkk.Header.Label"
    static let RegisterKVKKTextLabel                                =   "Register.Kvkk.Text.Label"
    static let RegisterPersonalInfoLabelText                        =   "Register.PersonalInfoLabel.Text"
    static let RegisterSecurityInfoLabelText                        =   "Register.SecurityInfoLabel.Text"
    
    //OTP
    static let OTPDescriptionWithGsm                                =   "otp_description"
    static let OTPSMSCode                                           =   "OTP.SMSCode"
    static let OTPSecondText                                        =   "otp_remaining_time"
    static let OTPResendButton                                      =   "otp_resend"
    static let OTPApproveLabel                                      =   "OTP.ApproveLabel"
    static let OTPTitle                                             =   "otp_navigation_title"

    //FORGOT PASSWORD
    static let ForgotPasswordHeader                                     = "ForgotPassword.Header"
    static let ForgotPasswordDescription                                = "ForgotPassword.Description"
    static let ForgotPasswordButton                                     = "ForgotPassword.Button"
    
    //CHANGE PASSWORD
    static let ChangePasswordNewPassword                                = "ChangePassword.NewPassword"
    static let ChangePasswordReNewPassword                              = "ChangePassword.ReNewPassword"
    static let ChangePasswordHeader                                     = "ChangePassword.Header"
    static let ChangePasswordPasswordInfo                               = "ChangePassword.PasswordRestrictionsInfo"
    static let ChangePasswordPassword                                   = "ChangePassword.Password"
    static let ChangePasswordErrorPasswordLengthIsNotSuitable           = "ChangePassword.Error.PasswordLengthIsNotSuitable"
    static let ChangePasswordErrorPasswordsIsNotEqual                   = "ChangePassword.Error.PasswordsIsNotEqual"

    //WALLET
    static let WalletAvailableBalance                                   = "Wallet.AvailableBalance"
    static let WalletAvailableLimit                                     = "Wallet.AvailableLimit"
    static let WalletWaitingBalance                                     = "Wallet.WaitingBalance"
    static let WalletWaitingLimit                                       = "Wallet.WaitingLimit"
    static let WalletAddCardCvvInformation                              = "Wallet.AddCard.CVVInfo"
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

