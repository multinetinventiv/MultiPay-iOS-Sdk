
import Foundation

//MARK: - Colors
public struct ColorPalette {
    
    //
    public static let colorBastille        = UIColor(red: 45/255, green: 45/255, blue: 50/255, alpha: 1.0)
    public static let colorDirtyWhite      = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
    
    //AppColor
    
    static func colorGrayMakoToolbar() -> UIColor {
        let lightColor = UIColor(red: 79/255, green: 88/255, blue: 88/255, alpha: 1.0)
        let darkColor = UIColor.white
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
    
    
    public static let colorGrayMako        = UIColor(red: 79/255, green: 88/255, blue: 88/255, alpha: 1.0)       // Navigation Header
    
    public static let colorGrayCapeCod     = UIColor(red: 78.0/255, green: 82.0/255, blue: 83.0/255, alpha: 1.0) // Tutorial Titles
    public static let colorGrayWildSand    = UIColor(red: 245/255, green: 245/255, blue: 242/255, alpha: 1.0)    // Background
    public static let colorRedCinnabar     = UIColor(red: 236/255, green: 60/255, blue: 54/255, alpha: 1.0)      // Check-In
    public static let colorPink            = UIColor(red: 252/255, green: 229/255, blue: 228/255, alpha: 1.0)    // Check-In
    public static let vcBackground         = paleLilac
    //White
    public static let paleLilac            = UIColor(red: 231.0 / 255.0, green: 231.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0)
    
    //Green
    public static let colorGreenButton     = colorGreenTea//UIColor(red: 121/255, green: 187/255, blue: 74/255, alpha: 1.0) // Yeşil action button rengi
    public static let colorGreenMint       = UIColor(red: 214/255, green: 235/255, blue: 198/255, alpha: 1.0)
    public static let colorGreenScreamin   = UIColor(red: 117/255, green: 255/255, blue: 74/255, alpha: 1.0) // Success Pagea
    public static let colorGreenPistachio  = UIColor(red: 126/255, green: 191/255, blue: 82/255, alpha: 1.0)
    public static let colorGreenTea        = UIColor(red: 93/255, green: 177/255, blue: 133/255, alpha: 1.0)
    public static let softGreen            = UIColor(red: 107.0 / 255.0, green: 191.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    public static let greenishTeal         = UIColor(red: 52.0 / 255.0, green: 177.0 / 255.0, blue: 128.0 / 255.0, alpha: 1.0)
    public static let blueGreen            = UIColor(red: 1.0 / 255.0, green: 131.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    public static let deepTeal             = UIColor(red: 2.0 / 255.0, green: 86.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0)
    public static let shamrock             = UIColor(red: 54.0 / 255.0, green: 216.0 / 255.0, blue: 149.0 / 255.0, alpha: 1.0)
    
    //Orange
    public static let colorOrange          = UIColor(red: 247.0/255, green: 156.0/255, blue: 55.0/255, alpha: 1.0)
    public static let dustyOrange          = UIColor(red: 245.0/255, green: 139.0/255, blue: 56.0/255, alpha: 1.0)
    
    //Yellow
    public static let colorYellowFilter    = UIColor(red: 254.0/255, green: 209.0/255, blue: 48.0/255, alpha: 1.0)
    public static let wildSand             = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    public static let gold                 = UIColor(red: 255.0 / 255.0, green: 210.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    
    //Blue
    public static let brightCyan           = UIColor(red: 91.0 / 255.0, green: 200.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    public static let azure                = UIColor(red: 38.0 / 255.0, green: 167.0 / 255.0, blue: 223.0 / 255.0, alpha: 1.0)
    public static let darkBlueGrey         = UIColor(red: 24.0 / 255.0, green: 22.0 / 255.0, blue: 61.0 / 255.0, alpha: 1.0)
    
    public static let cerulean             = UIColor(red: 6.0 / 255.0, green: 123.0 / 255.0, blue: 194.0 / 255.0, alpha: 1.0)
    
    
    // Pink
    public static let coralPink            = UIColor(red: 240.0 / 255.0, green: 112.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    public static let darkishPink          = UIColor(red: 237.0 / 255.0, green: 52.0 / 255.0, blue: 114.0 / 255.0, alpha: 1.0)
    
    //Purple
    public static let fadedPurple          = UIColor(red: 159.0 / 255.0, green: 94.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    public static let warmPurple           = UIColor(red: 128.0 / 255.0, green: 56.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    public static let twilight             = UIColor(red: 90.0 / 255.0, green: 83.0 / 255.0, blue: 161.0 / 255.0, alpha: 1.0)
    public static let blueberry            = UIColor(red: 69.0 / 255.0, green: 64.0 / 255.0, blue: 134.0 / 255.0, alpha: 1.0)
    //Grey
    public static let darkGreyBlue         = UIColor(red: 43.0 / 255.0, green: 46.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
    public static let concreteGray         = UIColor(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)

    public static let charcoal             = UIColor(red: 22.0 / 255.0, green: 27.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    
    //Red
    public static let orangeyRed           = UIColor(red: 22.0 / 255.0, green: 27.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    public static let torchRed             = UIColor(red: 253.0 / 255.0, green: 13.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    
    
    //PaymentSuccessScreen
    public static let colorBlackGreen      = UIColor(red: 237.0/255, green: 61.0/255, blue: 54.0/255, alpha: 1.0)
    
    //Installment-OrderComplete
    public static let colorGrayAluminium = UIColor(red: 151/255, green: 153/255, blue: 155/255, alpha: 1.0)
    public static let colorGray = UIColor(red: 131/255, green: 136/255, blue: 161/255, alpha: 1.0)
    
    
    public struct Gray {
        static let Light       = UIColor(white: 0.8374, alpha: 1.0)
        static let Medium      = UIColor(white: 0.4756, alpha: 1.0)
        static let Dark        = UIColor(white: 0.2605, alpha: 1.0)
        static let emperorGray = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1.0)
    }
    
    
    
    public static func inputAccesoryViewBGColor() -> UIColor {
        return UIColor(red: 245 / 255, green: 245/255, blue: 245 / 255, alpha: 1.0)
    }
    
    public static func inputAccesoryViewDoneButtonColor() -> UIColor {
        return UIColor(red: 32/255, green: 122/255, blue: 247/255, alpha: 1.0)
    }
    public static func inputAccesoryViewButtonColor() -> UIColor {
        return UIColor(red: 55 / 255, green: 69/255, blue: 144 / 255, alpha: 1.0)
    }
    
    public static func RGBA(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpa: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpa)
    }
    
    public static func tintColor() -> UIColor {
        let lightColor = UIColor(red: 0.094, green: 0.086, blue: 0.239, alpha: 1)
        let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
    
    public static func navTitleColor() -> UIColor {
        let lightColor = UIColor(red: 0.094, green: 0.086, blue: 0.239, alpha: 1)
        let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
    
    //Dark Mode
    public static let isDarkModeSupported = true
    public static let getirPrimary = UIColor.hexStringToUIColor(hex: "18163D")
    public static let getirBorder = UIColor(red: 0.949, green: 0.941, blue: 0.992, alpha: 1)
    
    public static func decideColor(lightColor: UIColor, darkColor: UIColor) -> UIColor {
    
        var color = lightColor
        
        if #available(iOS 13, *), ColorPalette.isDarkModeSupported {
            color = UIColor { traitCollection in
                
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return darkColor
                default:
                    return lightColor
                }
            }
        }
        return color
    }
    
    public static func commonTextColor() -> UIColor {
        let lightColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
    
    public static func commonTextColorGrayishInDarkmode() -> UIColor {
        let lightColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)

    }
    
    public static func commonTextColorGrayish2() -> UIColor {
        let lightColor = UIColor(red: 0.42, green: 0.455, blue: 0.525, alpha: 1)
        let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
    
    static func commonButtonBorder() -> UIColor {
        let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
        let darkColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
        return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
    }
}

extension ColorPalette{
    //MARK: Login Folder
    
    struct login {
        
        static func loginViewBackground() -> UIColor {
            let lightColor:UIColor = UIColor.white
            let darkColor = ColorPalette.getirPrimary
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func inputBackground() -> UIColor {
            let lightColor:UIColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static let loginBtnBackgroundPassive = UIColor(red: 0, green: 0, blue: 0, alpha: 0.38)
       
        static func forgotPasswordLblTitle() -> UIColor {
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func registerButtonBorder() -> UIColor {
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.12)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static let registerBtnTitle = darkBlueGrey
        static let loginBtnTitlePassive = UIColor.white
        static let activationBtnTitle = darkBlueGrey
        
        
        static let titleColor = UIColor.hexStringToUIColor(hex: "5DB185")
        static let infoColor = UIColor.hexStringToUIColor(hex: "6B7486")
        
        static let usernamePlaceholderTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        static let usernameSelectedPlaceholderTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.38)
        static let usernameBackviewColor = UIColor.hexStringToUIColor(hex: "E8E8E8")
        static var usernameInputColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
        
        static let forgotPasswordTextLbl = UIColor.black
        
        static let girisYapPassiveText = UIColor.white
        static let girisYapPassiveBackground = UIColor.hexStringToUIColor(hex: "9FD0B5")
        static var girisYapActiveBackground = UIColor.hexStringToUIColor(hex:"5DB185")
        static var girisYapActiveText = UIColor.white
        
        static let kayitOlColor = UIColor.hexStringToUIColor(hex: "18163D")
        static let kayitOlBackground = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0)
        
    }

    struct OTP {
        
        static func bottomBorderColor()->UIColor {
            let lightColor:UIColor = UIColor(red: 0.788, green: 0.808, blue: 0.796, alpha: 1)
            let darkColor = UIColor(red: 0.788, green: 0.808, blue: 0.796, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        
        
    }
    
    struct ActivationWithCode {
        static let activationCodeSendButtonText = UIColor.white
        static let activationCodeSendButtonBackground = ColorPalette.colorGreenTea
        static let activationCodeLabelText = UIColor.black

        static let setPasswordSetButton = UIColor.white
        static let setPasswordUserInfoLabel = UIColor.black
        static let setPasswordSetButtonBackground = ColorPalette.colorGreenTea
    }
    
    struct register {
        static let personalInfoLabel = ColorPalette.colorGrayMako
        static let securityInfoLabel = ColorPalette.colorGrayMako
        static let passwordInfoLabel = UIColor.darkText
        static let contractHeaderLabel = UIColor.darkText
        static let contractTextLabel = UIColor.darkText
        static let informHeaderLabel = UIColor.darkText
        static let informTextLabel = UIColor.darkText
        static let buttonRegisterBackground = ColorPalette.colorGreenTea
        static let switchBtnsSelectedBackground = ColorPalette.colorGreenTea
        static let switchBtnsUnSelectedBackground = UIColor.lightGray.withAlphaComponent(0.5)
    }
    
    struct resetPassword {
        static let descriptionLbl = UIColor.black.withAlphaComponent(0.5)
        static let emailBtnBackground  = ColorPalette.colorGreenButton
        static let emailBtnTitleColor  = UIColor.white
        static let background   =   ColorPalette.vcBackground
    }
    struct resetPassword2 {
        static let resetBtnBackground = ColorPalette.colorGreenButton
        static let resetBtnTitleColor  = UIColor.white
        static let passwordInfoLabelText = UIColor.black
    }
    
    struct otp {
        static let loginBtnBackground = UIColor.gray
        static let lblDescription = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 1)
        static let lblTimer = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 1)
        static let lblTimeDescription = UIColor.darkGray
        static let btnLoginActiveBackground = ColorPalette.colorGreenTea
        static let btnLoginPassiveBacground = UIColor.gray
    }
    
    struct tutorial {
        static let leftBtnTitle = UIColor.white//UIColor(red: 79/255, green: 88/255, blue: 88/255, alpha: 1.0)
        static let tutorialPage1 = UIColor(red: 79/255, green: 88/255, blue: 88/255, alpha: 1.0)
        struct tutorialScreenBase {
            static let topTitleLbl = UIColor.white
            static let bottomTitleLbl = UIColor.white//UIColor(red: 79/255, green: 88/255, blue: 88/255, alpha: 1.0)
            static let permissionBtnBackground = ColorPalette.colorOrange
            static let permissionBtnTitle = UIColor.white
        }
        
        struct tutorialFirst {
            static let btnChangeLanguageBackground = UIColor.white
            static let btnChangeLanguageTitle = ColorPalette.colorGrayCapeCod
            static let lblTop = UIColor.white
        }

    }
    ///////////////////
    
    //MARK: Dashboard Folder
    struct deleteCard {
        static let continueBtnBackground = ColorPalette.colorGreenButton
        static let continueBtnTitle = UIColor.white
        static let lblTitle = ColorPalette.colorGreenMint
        static let lblDetail = UIColor.white
    }
    
    struct walletSdk {
        static func topInfoText() -> UIColor {
            let lightColor:UIColor = UIColor(red: 0.098, green: 0.098, blue: 0.098, alpha: 1)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func kartEkleBackground() -> UIColor {
            
            let lightColor:UIColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0)
            let darkColor = UIColor(red: 0.384, green: 0.008, blue: 0.933, alpha: 0)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func kartListBackground() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            let darkColor = UIColor(red: 0.141, green: 0.145, blue: 0.329, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func kartListBackgroundSelected() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0.902, green: 0.953, blue: 0.929, alpha: 1)
            let darkColor = UIColor(red: 0.2, green: 0.212, blue: 0.42, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func cardName() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func cardNumber() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func cardBalance() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func cardSumOfUsableBalance() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            let darkColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        static func seperatorColor() -> UIColor{
            let lightColor:UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            let darkColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
            return ColorPalette.decideColor(lightColor: lightColor, darkColor: darkColor)
        }
        
        
    }
    
    struct walletSelection {
        static let lblNoDataFound = UIColor.lightGray
        static let availableBalanceBtnBackground = ColorPalette.colorGreenButton
        static let availableBalanceBtnTitle = UIColor.white
    }
    struct lastTrx {
        static let dataNotFoundLbl = ColorPalette.darkBlueGrey
    }

    struct cardTransaction {
        static let Undefined = ColorPalette.colorDirtyWhite

        static let Loading = ColorPalette.shamrock
        static let CorporateLoading = ColorPalette.shamrock
        static let IndividualLoading = ColorPalette.shamrock
        static let BonusLoading = ColorPalette.gold

        static let Expenditure = ColorPalette.torchRed
        static let Withdraw = ColorPalette.torchRed
        static let Cancel = ColorPalette.fadedPurple

        static let MoneyTransferEntry = ColorPalette.shamrock
        static let MoneyTransferOut = ColorPalette.torchRed
    }

    struct lastTrxCell {
        static let lblMerchantTitle = ColorPalette.darkBlueGrey
        static let lblTime = ColorPalette.darkBlueGrey
        static let lblAmount = ColorPalette.darkBlueGrey
    }
    
    struct walletSelectionToKeep {
        static let btnKeepBackgroundColor = ColorPalette.colorGreenButton
        static let btnKeepTitleColor = UIColor.white
    }
    
    struct userView {
        static let lblName = UIColor.black
        static let lblAmount = UIColor.black
        static let lblAmountTitle = UIColor.black
    }
    
    struct dashboardItemView {
        static let QRbackgroundColor = ColorPalette.colorGreenButton
        static let QRbuttonTitle = UIColor.white
        
        static let backgroundColor = UIColor.white
        static let buttonTitle = ColorPalette.darkBlueGrey
    }
    
    struct dashboardBarView {
        static let contentBackgroundView = ColorPalette.colorGreenButton
        static let walletBtnTitle = UIColor.white
        static let salePointsBtnTitle = UIColor.white
    }
    //////////////////////////////
    //MARK: Wallet Folder
    
    struct cardOcr {
        static let goToManuelTitleLbl = UIColor.white
        static let addCardInfoLabel = UIColor.white
    }
    
    struct addCard {
        static let lblCardNumber = UIColor.black
        static let txtCardNumber = UIColor.black
        static let backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
        static let continueBtnTitle = UIColor.white
        static let continueBtnBackground = ColorPalette.colorGreenButton
    }
    
    struct addCardSuccess {
        static let lblDescription = ColorPalette.colorGreenMint
        static let lblOwner = ColorPalette.RGBA(79, green: 89, blue: 89, alpa: 1)
        static let lblCardNumber = UIColor.black
        static let contBtn = ColorPalette.colorGreenButton
        static let contBtnTitle = UIColor.white

    }
    
    struct addCardError {
        static let lblWarning = UIColor.white
        static let lblDesc = ColorPalette.colorGreenMint
        static let btnContinue = UIColor.clear
        static let btnretry = ColorPalette.colorGreenButton
    }
    
    struct paymentNewSuccess {
        static let amountLabel = ColorPalette.colorGreenScreamin
        static let paymentSuccessDescLabel = UIColor.white
        static let continueButtonBackground = ColorPalette.colorBlackGreen
        static let continueButtonTitle = ColorPalette.colorBlackGreen
    }
    
    struct paymentInfo {
        static let btnTitle = UIColor.white
        static let btnBackground = ColorPalette.colorGreenTea
    }
    
    struct topUp {
        static let backgroundColor                        = ColorPalette.colorGrayWildSand
        static let topUpButtonContainer                   = ColorPalette.colorGrayWildSand
        
        static let topUpButton                            = ColorPalette.colorGreenButton
        static let alertTextColor                         = UIColor.black
    }
    
    struct topUpCardList {
        static let cardCircleContainerBackgroundColor     = ColorPalette.colorGreenButton
    }
    
    struct topUpCardAdd {
        static let containerViewCardAddBackgroundColor    = UIColor.clear
        
        static let expireDateContentBackgroundColor       = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        static let expireDateHeaderBackgroundColor        = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        static let expireDateConfirmButtonColor           = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        static let expireDateCancelButtonColor            = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        
        static let expireTextViewBackgroundColor          = UIColor.red
        static let expireTextViewPlaceHolderColor         = UIColor.red.withAlphaComponent(0.5)
    }
    
    struct orderComplete {
        static let orderCompleteHeaderLabel               = UIColor.white
        static let orderCompleteTimeLabel                 = ColorPalette.colorGrayAluminium
        static let orderCompleteCurrentBalanceTitleLabel  = ColorPalette.colorGrayAluminium
        static let amountLabel                            = ColorPalette.colorGreenScreamin
        
        static let messageAttribute                           = ColorPalette.colorGreenMint
        static let successViewContainerLayerBackgroundColor   = UIColor.clear.cgColor
    }
    
    struct topUpOrders {
        static let backgroundColor                            = ColorPalette.colorGrayMako
        static let containerViewBackgroundColor               = ColorPalette.colorGrayWildSand
    }
    
    struct topUpOrder {
        static let barTintColor                               = UIColor.brown
        static let tintColor                                  = UIColor.white
        static let backgroundColor                            = ColorPalette.colorGrayMako
        static let containerViewBackgroundColor               = ColorPalette.colorGrayWildSand
        
        static let cInputAccessoryViewBackgroundColor         = ColorPalette.inputAccesoryViewBGColor()
        static let toolbarBackgroundColor                     = ColorPalette.inputAccesoryViewBGColor()
        
        static let btnSetTitleColor                           = ColorPalette.inputAccesoryViewDoneButtonColor()
        static let btnBackgroundColor                         = UIColor.clear
        
        static let topUpInstructionBankCardTitle              = UIColor.black
    }
    
    struct addCreditCard {
        static let backgroundColor                            = ColorPalette.colorGrayMako
        static let containerViewBackgroundColor               = ColorPalette.colorGrayWildSand
        
        static let expirationDateITViewBackgroundColor        = UIColor.red
        static let expirationDateITViewPlaceHolderColor       = UIColor.red.withAlphaComponent(0.5)
        
    }
    
    struct cardOnlineSettings {        
        static let dateViewText                               = UIColor.black
        static let dateViewTitleText                          = UIColor.lightGray.withAlphaComponent(0.6)
        
        static let datePickerContentBackgroundColor           = UIColor(red: 253/255.0, green: 253/255.0, blue: 253/255.0, alpha: 1)
        static let datePickHeaderBackgroundColor              = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        static let datePickerConfirmButtonColor               = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        static let datePickerCancelButtonColor                = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        
        static let backgroundColor                            = ColorPalette.colorGrayMako
        static let contentViewBackgroundColor                 = ColorPalette.colorGrayWildSand
    }
    
    struct cardSpending {
        static let spendingCheckLabel                         = UIColor.darkGray
        static let disableSpendingCheckLabel                  = UIColor.lightGray
        static let updateButtonBackgroundColor                = ColorPalette.colorGreenButton
        
        static let backgroundColor                            = ColorPalette.colorGrayMako
    }
    
    struct eWallet {
        static let buttonPayBackgroundColor                   = ColorPalette.colorGreenButton
        static let lblBalanceTitle                            = UIColor.clear
        static let lblBalance                                 = UIColor.darkGray.withAlphaComponent(0.9)
        
        static let lblWaitingBalanceTitle                     = UIColor.darkGray.withAlphaComponent(0.7)
        static let lblWaitingBalance                          = UIColor.darkGray.withAlphaComponent(0.9)
        
        static let backgroundColor                            = UIColor.black.withAlphaComponent(0.6)
        static let btnMapLayer                                = ColorPalette.colorGrayMako.withAlphaComponent(0.4).cgColor
        
        static let transBackgroundColor                       = UIColor.black.withAlphaComponent(0.6)
    }
    
    struct cardTrx {
        static let notFoundText                               = UIColor.darkGray.withAlphaComponent(0.7)
        static let backgroundColor                            = UIColor.white
    }
    
    struct successProgressView {
        static let backgroundColor                           = UIColor.clear
        
        static let circleLayerFillColor                       = UIColor.clear.cgColor
        static let circleLayerStrokeColor                     = ColorPalette.RGBA(122, green: 253, blue: 86, alpa: 1).cgColor
        
        static let checkMarkLayerFillColor                    = UIColor.clear.cgColor
        static let checkMarkLayerStrokeColor                  = ColorPalette.RGBA(122, green: 253, blue: 86, alpa: 1).cgColor
    }
    
    struct eWalletCollectionCell {
        static let lblOwner                                   = UIColor.darkGray
        static let lblCardNumber                              = UIColor.black
    }
    
    struct walletAddCardCollectionCell {
        static let multinetCardTitle                          = UIColor.white
        static let virtualCardTitle                           = UIColor.white
    }
    
    struct walletCardView {
        static let lblOwner                                   = UIColor.darkGray
        static let lblCardNumber                              = UIColor.black
    }
    
    struct walletCell {
        static let lblAmount                                  = UIColor.white
        static let lblOwner                                   = UIColor.white.withAlphaComponent(0.8)
        static let lblCardNo                                  = UIColor.white.withAlphaComponent(0.8)
        static let backgroundColor                            = UIColor.clear
        static let switchBtnsSelectedBackground          = ColorPalette.colorGreenTea
    }
    
    struct transactionCell {
        static let lblHeader                                  = UIColor.black
        static let lblMerchant                                = ColorPalette.Gray.Medium
        static let lblDate                                    = ColorPalette.Gray.Medium
        static let lblAmount                                  = UIColor.black
        
        static let updateRewardLblMerchant                    = UIColor.lightGray
        static let updateRewardLblDate                        = UIColor.lightGray
        static let colorViewBackgroundColor                   = ColorPalette.RGBA(212, green: 174, blue: 40, alpa: 1)
        static let shapeLayerFillColor                        = UIColor.white.cgColor
    }
    
    struct barcodeView {
        static let shapeLayerStrokeColor                      = UIColor.green.cgColor
        static let shapeLayerFillColor                        = UIColor(red: 0, green: 1, blue: 0, alpha: 0.25).cgColor
        static let buttonReadLayerBorderColor                 = UIColor.white.cgColor
    }
    
    struct checkView {
        static let switchControlBackgroundColor               = UIColor.lightGray
        static let lblTitle                                   = ColorPalette.colorGrayMako
        static let switchBtnsSelectedBackground               = ColorPalette.colorGreenTea
    }
    
    //MARK: Common Folder
    struct pushAlert {
        static let lblTitle = UIColor.white
        static let btnOkBackground = ColorPalette.colorGreenTea
        static let btnOkTitle = UIColor.white
        static let btnLaterBackground = UIColor.clear
        static let btnLaterTitle = UIColor.white
        static let background = colorGrayMako
    }
    
    struct cardHeaderView {
        static let lblCardNumber                        = UIColor.white
        static let lblCardOwner                         = UIColor.white
        static let lblCardBalance                       = UIColor.white
        static let tatliParaAmount                      = ColorPalette.colorGrayMako
        static let tatliParaDescription                 = ColorPalette.colorGrayMako
        
        static let lblCardNumber5                       = UIColor.white
        static let lblCardBalance5                      = UIColor.white
        static let tatliParaDescription5                = ColorPalette.colorGrayMako
    }
    
    struct spinnerView {
        static let activityIndicatorViewBackgroundColor = UIColor.clear
    }
    
    struct quickReloadView {
        static let amountTextViewBackgroundColor        = UIColor.clear
        static let scrollViewBackgroundColor            = UIColor.white
        static let backgroundColor                      = ColorPalette.colorGrayWildSand
        static let backButton                           = ColorPalette.colorGreenTea
        static let reloadButton1                        = ColorPalette.colorGreenButton
        static let reloadButton2                        = ColorPalette.colorGreenButton
        static let reloadButton3                        = ColorPalette.colorGreenButton
        static let otherButton                          = ColorPalette.colorGreenButton
        
        static let reloadButton1Title                   = UIColor.white//ColorPalette.colorGreenButton
        static let reloadButton2Title                   = UIColor.white//ColorPalette.colorGreenButton
        static let reloadButton3Title                   = UIColor.white//ColorPalette.colorGreenButton
        static let otherButtonTitle                     = UIColor.white//ColorPalette.colorGreenButton
        
        static let reloadButton1Cleared                 = UIColor.white
        static let reloadButton2Cleared                 = UIColor.white
        static let reloadButton3Cleared                 = UIColor.white
        static let otherButtonCleared                   = UIColor.white
        
        static let reloadButton1ClearedTitle            = UIColor.black
        static let reloadButton2ClearedTitle            = UIColor.black
        static let reloadButton3ClearedTitle            = UIColor.black
        static let otherButtonClearedTitle              = UIColor.black
    }
    
    struct quickSelectionView {
        static let amountTextViewBackgroundColor                = UIColor.clear
        static let amountTextViewTxtInputTextColor              = UIColor.white
        static let amountTextViewSelectedPlaceHolderColor       = UIColor.lightGray.withAlphaComponent(0.6)
        static let amountTextViewTxtInputBackgroundColor        = UIColor.clear
        static let amountTextViewBackgroundViewBackgroundColor  = UIColor.clear
        
        static let selectBtnBackgroundColor                     = ColorPalette.colorGreenButton
        static let lblDescTitle                                 = ColorPalette.colorGrayMako
        static let backgroundColor                              = ColorPalette.colorGrayMako
    }
    
    struct quickViewCell {
        static let lblColorNon                                  = ColorPalette.colorGrayMako
        static let lblColorSelected                             = UIColor.white
        static let backgroundColorNon                           = UIColor.white
        static let backgroundColorSelected                      = ColorPalette.colorGreenButton
    }
    
    struct pinCode {
        static let color                                        = ColorPalette.RGBA(74, green: 88, blue: 87, alpa: 1.0)
    }
    
    struct noDataFound {
        static let lblNotFound                                  = UIColor.darkGray
    }
    
    struct MTLabel {
        static let label                                        = UIColor.white
    }
    
    struct MTNameLabel {
        static let label                                        = UIColor.white
    }
    
    struct MTSectionHeaderCell {
        static let lblTitle                                     = UIColor.gray
    }
    
    struct MTDefaultCell {
        static let lblTitle                                     = UIColor.black
        static let lblSubtitle                                  = ColorPalette.Gray.Light
        static let lblHeader                                    = ColorPalette.Gray.Light
    }
    
    struct MTActionSheetLight {
        static let backgroundColor                              = UIColor.white
        static let titleColor                                   = ColorPalette.colorBlackGreen
        static let titleFontColor                               = UIColor.black.withAlphaComponent(0.9)
    }
    
    struct MTActionSheetDefault {
        static let backgroundColor                              = ColorPalette.RGBA(128, green: 134, blue: 157, alpa: 1)
        static let titleColor                                   = UIColor.white
        static let titleFontColor                               = UIColor.black.withAlphaComponent(0.9)
    }
    
    struct inputTextView {
        static let text                                         = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87) //UIColor.white
        static let titleText                                    = UIColor(red: 0.094, green: 0.086, blue: 0.239, alpha: 1) //UIColor.white.withAlphaComponent(0.5)
        static let rightView                                    = UIColor.lightGray
        static let rightViewBG                                  = UIColor.clear
        
        static let blackTxtInputPlaceHolderColor                = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1)
        static let blackTxtInputSelectedPlaceHolderColor        = UIColor.black
        static let blackTxtInputTextColor                       = UIColor.black
        static let blackTxtInputClearButtonColor                = blackTxtInputPlaceHolderColor
        
        static let txtInputPlaceHolderColor                     = UIColor.white.withAlphaComponent(0.6)
        static let txtInputSelectedPlaceHolderColor             = UIColor.white
        static let txtInputTextColor                            = UIColor.white
        static let txtInputClearButtonColor                     = UIColor.white
        static let txtInputOriginalTextColor                    = txtInputPlaceHolderColor
        
        static let txtInputLineColor                            = UIColor.clear
        static let txtInputSelectedLineColor                    = UIColor(red: 0.094, green: 0.086, blue: 0.239, alpha: 1)
    }
    
    struct cardScrollView {
        static let txtMerchant                                  = ColorPalette.colorBlackGreen
        static let txtDate                                      = ColorPalette.colorBlackGreen
    }
    
    struct MTCardView {
        static let cardNumber                                   = UIColor.black
        static let cardTypeName                                 = UIColor.black
    }
    
    struct agreement {
        static let backgroundColor                              = ColorPalette.colorGrayMako
    }
    
    struct webVC {
        static let webViewBackgroundColor                       = ColorPalette.concreteGray
        static let activityIndicatorColor                       = UIColor.black
        static let containerViewBackgroundColor                 = ColorPalette.colorGrayWildSand
        static let backgroundColor                              = UIColor.black.withAlphaComponent(0.6)
    }
    
    struct checkInInfo {
        static let btnTitle                                     = UIColor.white
        static let btnBGMiss                                    = ColorPalette.colorRedCinnabar
        static let btnBG                                        = ColorPalette.colorGrayMako
        
        static let backgroundCamp                               = ColorPalette.RGBA(210.0, green: 155.0, blue: 71.0, alpa: 1.0)
        static let background                                   = ColorPalette.colorGrayMako
    }
    
    
    //MARK: Campaign Folder
    struct parantezCampaignWinView {
        static let title                              = UIColor.black
        static let merchantName                       = UIColor.lightGray
        static let date                               = UIColor.lightGray
        static let amount                             = UIColor.black
    }
    
    struct todayHereCell {
        static let todayTitleColor                    = ColorPalette.colorGrayMako
        static let todayChekinButtonBGColor           = ColorPalette.colorRedCinnabar
        
        static let containerViewLayerColor            = UIColor.black.cgColor
    }
    
    struct campaign {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let tableViewBackgroundColor           = ColorPalette.colorGrayWildSand
        static let tableViewEmptyMessage              = ColorPalette.colorGrayMako
    }
    
    struct campaignPager {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let contentBackgroundColor             = ColorPalette.colorGrayWildSand
        static let segmentBackgroundColor             = ColorPalette.colorGrayWildSand
        static let segmentContentColor                = ColorPalette.Gray.Light
        static let segmentTintColor                   = ColorPalette.darkGreyBlue
        static let selectedSegmentContentColor        = ColorPalette.darkBlueGrey
    }
    
    
    
    struct newCampaignHeader {
        static let howCanWin                          = UIColor.white
        static let amount                             = UIColor.white
        static let amountInfo                         = UIColor.white
        static let bottomDescription                  = ColorPalette.colorGrayMako
        static let backgroundColor                    = ColorPalette.colorGreenTea
    }
    
    struct campaignVirtualCell {
        static let campaignTitle                      = UIColor.black
        static let campaignSubtitle                   = UIColor.black
    }
    
    struct campaignDetail {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let containerViewBackgroundColor       = ColorPalette.colorGrayWildSand
        static let webViewBackgroundColor             = UIColor.clear
        
        static let tableView                          = UIColor.clear
        static let cellBackgroundColor                = UIColor.clear
        static let cellContentViewBackgroundColor     = UIColor.clear
        static let cellBaseContentViewBackgroundColor = UIColor.clear
        
        static let continueButtonColor                = ColorPalette.colorGreenButton
        
    }
    
    struct campaignCreate {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let containerViewBackgroundColor       = ColorPalette.colorGrayWildSand
        static let overlayAppearance                  = UIColor.black
    }
    
    struct todayHere {
        static let labelColor                         = ColorPalette.colorGrayMako
        static let vwBackgroundColor                  = ColorPalette.colorPink
        static let vwBackgroundColorWin               = ColorPalette.colorGrayWildSand
        static let footerViewBackgroundColor          = UIColor.white
        
        static let cellBackgroundColor                = ColorPalette.colorGrayWildSand
        static let contentBackgroundView = ColorPalette.colorGreenTea
    }
    
    //MARK: Settings Folder
    
    struct profileHeader {
        static let mailColor                          = UIColor.white
        static let overlayBackgroundColor             = ColorPalette.colorBastille
    }
    
    struct notificationDetailCell {
        static let goToSettingsButtonLayer            = UIColor.black.cgColor
        static let notificationSwitchSelected         = ColorPalette.colorGreenTea
    }
    
    struct notificationCell {
        static let titleColor                         = UIColor.black
        static let detailColor                        = ColorPalette.Gray.emperorGray
    }
    
    struct languageCell {
        static let backgroundColor                    = UIColor.clear
        static let prepareWhitebackgroundColor        = UIColor.white
        static let lineColor                          = UIColor.black
        static let languageDescriptionColor           = UIColor.white
        static let languageDescriptionRegularColor    = UIColor.black
    }
    
    struct notification {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let tableViewBackgroundColor           = ColorPalette.colorGrayWildSand
    }
    
    struct notificationDetail {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let tableViewBackgroundColor           = ColorPalette.colorGrayWildSand
    }
    
    struct pinManagement {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let tableViewBackgroundColor           = ColorPalette.colorGrayWildSand
        
        static let defineLimitColor                   = UIColor.black.withAlphaComponent(0.7)
        static let pinLimitColor                      = UIColor.black.withAlphaComponent(0.7)
        static let pinLimitDetailColor                = UIColor.black.withAlphaComponent(0.7)
        static let pinChangeColor                     = UIColor.darkText
    }
    
    struct pinDefineInfo {
        static let containerViewBackgroundColor       = ColorPalette.colorGrayMako
        
        static let warningColor                       = UIColor.white
        static let descColor                          = ColorPalette.colorGreenMint
        static let infoTopColor                       = UIColor.white
        static let btnContinueBackground              = ColorPalette.colorGreenTea
    }
    
    struct pin {
        static let headerColor                        = ColorPalette.RGBA(74, green: 88, blue: 87, alpa: 1.0)
        static let statusColor                        = ColorPalette.RGBA(74, green: 88, blue: 87, alpa: 1.0)
    }
    
    struct feedback {
        static let descViewColor                      = UIColor.black
        static let messageTitleColor                  = UIColor.lightGray
        static let nameViewColor                      = UIColor.darkGray
        static let emailViewColor                     = UIColor.darkGray
        static let phoneViewColor                     = UIColor.darkGray
        static let btnSendColor                       = UIColor.darkGray
        
        static let targetColor                        = ColorPalette.RGBA(2, green: 17, blue: 65, alpa: 1)
        static let backgroundColor                    = ColorPalette.vcBackground
        static let scrollViewBackgroundColor          = ColorPalette.colorGrayWildSand
        static let mainContainerViewBackgroundColor   = ColorPalette.colorGrayWildSand
        static let btnSendBackground                  = ColorPalette.colorGreenTea
        static let targetCIColor                      = CIColor(cgColor: targetColor.cgColor)
        static let overlayColor                       = UIColor(red: targetCIColor.red, green: targetCIColor.green, blue: targetCIColor.blue, alpha: 0.0)
    }

    struct merchantFeedback {
        static let btnSendBackground = ColorPalette.colorGreenTea
        static let descriptionTextViewColor = UIColor.black
        static let infoLabel = UIColor.black
    }
    
    struct profileSettings {
        static let backgroundColor                    = UIColor.black.withAlphaComponent(0.6)
        static let barButtonItemColor                 = UIColor.white
        static let barButtonItemHighlightedColor      = UIColor.white
        static let barTintColor                       = UIColor.black
    }
    
    struct personelInfoSettings {
        static let genderViewColor                    = UIColor.black
        static let dateViewColor                      = UIColor.black
        static let dateViewTitleText                          = UIColor.lightGray.withAlphaComponent(0.6)

        static let datePickerContentViewColor         = ColorPalette.colorDirtyWhite
        static let datePickerHeaderBackgroundColor    = ColorPalette.wildSand
        static let datePickerConfirmButtonColor       = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        static let datePickerCancelButtonColor        = UIColor(red: 32/255.0, green: 146/255.0, blue: 227/255.0, alpha: 1)
        static let informSwitchSelectedBackground     = ColorPalette.colorGreenTea
    }
    
    struct language {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let tableViewBackgroundColor           = ColorPalette.colorGrayWildSand
    }
    
    //MARK: Salepoints Folder
    struct filter {
        static let backgroundColor                    = UIColor.white//ColorPalette.vcBackground
        
        static let btnClearLayerColor                 = ColorPalette.colorGrayMako.cgColor
        static let btnClearTitleColor                 = ColorPalette.colorGrayMako
        
        static let btnSelectBackgroundColor           = ColorPalette.colorGreenTea
        static let btnSelectTitleColor                = UIColor.white
    }
    
    struct filterSelection {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        
        static let btnSelectTitleColor                = UIColor.white
        static let btnSelectBackgroundColor           = ColorPalette.colorGreenButton
    }
    
    struct facilitySection {
        static let backgroundColor                    = ColorPalette.RGBA(231.0, green: 231.0, blue: 239.0, alpa: 1.0)
        static let titleColor                         = ColorPalette.colorGrayMako
    }
    
    struct mercantFacility {
        
    }
    
    struct spFilterCell {
        static let backgroundColor                     = UIColor.clear
        static let titleColor                          = UIColor.black.withAlphaComponent(0.8)
    }
    
    struct filterNoData {
        static let titleColor                          = ColorPalette.colorGrayMako
    }
    
    struct filterTagCell {
        static let mainTitleBackgroundColor            = UIColor.clear
        static let mainTitleColor                      = UIColor.white
        static let backgroundColor                     = ColorPalette.colorGreenButton
    }
    
    struct filterSection {
        static let colorViewBackgroundColorNormal      = ColorPalette.colorYellowFilter
        static let colorViewBackgroundColor            = ColorPalette.colorGreenButton
        static let mainTitleColor                      = ColorPalette.colorGrayMako
    }
    
    struct spMainSelectionCell {
        static let backgroundColor                     = UIColor.clear
        static let mainTitleColor                      = UIColor.black
        static let descColor                           = UIColor.lightGray
        static let green                               = ColorPalette.RGBA(30, green: 226, blue: 126, alpa: 1)
        static let yellow                              = ColorPalette.RGBA(254 , green: 203, blue: 10, alpa: 1)
    }
    
    struct salePoint {
        static let lblHeaderColor                      = ColorPalette.charcoal
        static let lblSectorName                       = ColorPalette.orangeyRed
        static let lblDistance                         = ColorPalette.charcoal
    }
    
    struct parantezMerchantView {
        static let lblLoadingColor                     = ColorPalette.colorGrayMako
    }
    
    struct campaignInfo {
        static let lblInfoColor                       = UIColor.darkText
        static let lblInfoBoldColor                   = UIColor.darkText
    }
    
    struct mapView {
        static let btnSearchBarFilterBackgroundColor  = ColorPalette.darkBlueGrey
        static let btnSearchCloseToMeBackgroundColor  = ColorPalette.colorGrayMako
        static let searchThisAreaBackgroundColor      = ColorPalette.colorGrayMako
        static let searchThisAreaColor                = UIColor.white
        static let btnParantezPoints                  = ColorPalette.darkBlueGrey
        static let btnParantezPointTitle                  = ColorPalette.darkBlueGrey

    }
    
    struct mapViewCell {
        static let lblHeaderColor                     = UIColor.black.withAlphaComponent(0.8)
        static let lblSectorNameColor                 = ColorPalette.Gray.Medium
        static let lblDistanceColor                   = UIColor.black
    }
    
    struct fuelAlert {
        static let backgroundColor                    = ColorPalette.colorGrayMako
        static let btnColor                           = ColorPalette.colorGreenButton
    }
    
    struct salePointSearch {
        static let searchBarFont                      = ColorPalette.RGBA(9, green: 39, blue: 75, alpa: 1)
        static let titleColor                         = ColorPalette.RGBA(9, green: 39, blue: 75, alpa: 1)
    }
    
    struct merchantDetail {
        static let lblTitleColor                      = UIColor.white
        static let lblSectorNameColor                 = UIColor.white.withAlphaComponent(0.7)
        static let lblAdressTitleColor                = UIColor.lightGray
        static let lblPhoneTitleColor                 = UIColor.lightGray
        static let lblCampaignTitleColor              = UIColor.lightGray
        
        static let lblPhoneColor                      = ColorPalette.colorGrayMako
        static let lblAdressColor                     = ColorPalette.colorGrayMako
        static let lblCampaignColor                   = ColorPalette.colorGrayMako
        
        static let btnFeedBackLayerColor              = ColorPalette.colorGrayMako.cgColor
        static let btnFeedBackTitleColor              = ColorPalette.colorGrayMako
    }
    
    
}


//  static let  = UIColor(red: 131/255, green: 136/255, blue: 161/255, alpha: 1.0)
