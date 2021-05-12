//
//  FontHelper.swift
//  MultiPay
//
//  Copyright © 2019 inventiv. All rights reserved.
//

import Foundation
import UIKit

//MARK: Fonts
public struct FontHelper
{
    public static let TextTitleFont = UIFont(name: "Montserrat-Regular", size: 12.0)!
    public static let TextFont = UIFont(name: "Montserrat-Regular", size: 22)!
    
  //  static let LabelFont = FontHelper.defaultRegularFontWithSize(DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_6P ? 15.0 : 14.0)
    
    public static let ButtonFont = UIFont(name: "Montserrat-ExtraBold", size: 14)
    public static let ButtonTitleFont = FontHelper.defaultRegularFontWithSize(20)
    public static let SubButtonTitleFont = FontHelper.defaultRegularFontWithSize(13)
    
    public static let CardNumberFont = UIFont(name: "OCRAExtended", size: 16.0)!
    
    static let fontNames =  ["Montserrat-Regular",
                             "Montserrat-Light",
                             "Montserrat-ExtraLight",
                             "Montserrat-Medium",
                             "Montserrat-Bold",
                             "Montserrat-SemiBold",
                             "Montserrat-ExtraBold",
                             "Montserrat-Italic",
                             "Montserrat-BoldItalic",
                             "Montserrat-ExtraLightItalic",
                             "OpenSans-SemiBold",
                             "OpenSans-Light",
                             "OpenSans-Italic",
                             "OpenSans-ExtraBold",
                             "OpenSans-LightItalic",
                             "OpenSans-Bold",
                             "OpenSans-SemiBoldItalic",
                             "OpenSans-ExtraBoldItalic",
                             "OpenSans-Regular",
                             "OpenSans-BoldItalic"
                            ]
    
    public static func registerFonts(){
        let bundle = BundleManager.getPodBundle()
        let fontExtension = "ttf"
        FontHelper.fontNames.forEach { (font) in
            _ = UIFont.registerFont(bundle: bundle, fontName: font, fontExtension: fontExtension)
        }
    }
    
    public static func oCRAExtendedFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "OCRAExtended", size: size)!
    }
    
    public static func defaultRegularFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    public static func defaultLightFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    
    public static func extraLightFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraLight", size: size)!
    }
    
    public static func defaultMediumFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }
    
    public static func boldFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    public static func semiBoldFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
    
    public static func extraBoldFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraBold", size: size)!
    }
    
    public static func defaultItalicFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Italic", size: size)!
    }
    
    public static func boldItalicFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-BoldItalic", size: size)!
    }
    
    public static func extraLightItalicFontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-ExtraLightItalic", size: size)!
    }
    
    /*
     black görmedi
     Debug] [FontHelper.swift] > Montserrat
     [Debug] [FontHelper.swift] >   Montserrat-Regular
     [Debug] [FontHelper.swift] >   Montserrat-ExtraBold        *
     [Debug] [FontHelper.swift] >   Montserrat-BoldItalic       *
     [Debug] [FontHelper.swift] >   Montserrat-Medium           *
     [Debug] [FontHelper.swift] >   Montserrat-Bold             *
     [Debug] [FontHelper.swift] >   Montserrat-Light            *
     [Debug] [FontHelper.swift] >   Montserrat-SemiBold         *
     [Debug] [FontHelper.swift] >   Montserrat-LightItalic
     [Debug] [FontHelper.swift] >   Montserrat-ExtraLight        *
     [Debug] [FontHelper.swift] >   Montserrat-ExtraLightItalic  *
     [Debug] [FontHelper.swift] >   Montserrat-SemiBoldItalic
     [Debug] [FontHelper.swift] >   Montserrat-ThinItalic
     [Debug] [FontHelper.swift] >   Montserrat-Thin
     [Debug] [FontHelper.swift] >   Montserrat-BlackItalic
     [Debug] [FontHelper.swift] >   Montserrat-Italic              *
     [Debug] [FontHelper.swift] >   Montserrat-MediumItalic
     [Debug] [FontHelper.swift] >   Montserrat-ExtraBoldItalic
     
     */
    
    static func printFonts()
    {
//        let fontFamilyNames = UIFont.familyNames
//        for familyName in fontFamilyNames {
//            log.debug("\(familyName)")
//            let names = UIFont.fontNames(forFamilyName: familyName )
//            for name in names {
//                log.debug("  \(name)")
//            }
//
//        }
    }
    
    
}

extension FontHelper{
    struct login{
        static let forgotPassword = UIFont(name: "Montserrat-Regular", size: 14)
        static let forgotPasswordBoldPart: UIFont = FontHelper.boldItalicFontWithSize(15)
        static let registerBtn = UIFont(name: "Montserrat-ExtraBold", size: 13.65)
        static let loginBtn = FontHelper.ButtonFont
        static let activationBtn = FontHelper.ButtonFont
        static let titleLbl = UIFont(name: "OpenSans-Bold", size: 16)
        static let bottomLbl = UIFont(name: "OpenSans-SemiBold", size: 13)
    }

    struct LoginWithActivation {
        static let setPasswordNormalForLabels = FontHelper.defaultMediumFontWithSize(14)
        static let setPasswordBoldForLabels = FontHelper.boldItalicFontWithSize(14)
        static let setPasswordBtn = FontHelper.ButtonFont

        static let sendCodeButton = FontHelper.ButtonFont
        static let enterActivationLabel = FontHelper.defaultRegularFontWithSize(15)

        static let userInfoHeader = FontHelper.boldFontWithSize(16)
    }
    
    struct register {
        static let contractHeaderLabel: UIFont = FontHelper.boldFontWithSize(16)
        static let contractTextLabel: UIFont = FontHelper.defaultRegularFontWithSize(14)
        static let informHeaderLabel: UIFont = FontHelper.boldFontWithSize(16)
        static let informTextLabel: UIFont = FontHelper.defaultRegularFontWithSize(10)
        static let registerBtnTitle: UIFont = FontHelper.defaultMediumFontWithSize(18)
        static let personalInfoLabel: UIFont = FontHelper.defaultRegularFontWithSize(18)
        static let securityInfoLabel: UIFont = FontHelper.defaultRegularFontWithSize(18)
        static let registerInfoLabel: UIFont = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct resetPassword {
        static let desc: UIFont = FontHelper.defaultRegularFontWithSize(17)
        static let emailBtnTitle = FontHelper.ButtonFont
    }
    struct resetPassword2 {
        static let resetBtnTitle: UIFont = FontHelper.ButtonFont!
        static let passwordInfoLabel: UIFont = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct otp {
        static let descriptionLbl = UIFont(name: "Montserrat-Bold", size: 14)
        static let timeDescriptionLbl: UIFont = FontHelper.defaultLightFontWithSize(15)
        static let timerLbl = UIFont(name: "Montserrat-Regular", size: 14)!
        static let loginBtnTitle = UIFont(name: "Montserrat-ExtraBold", size: 13.65)
    }
    
    struct tutorial {
        static let leftBtnTitle: UIFont = FontHelper.boldFontWithSize(15)
        struct tutorialScreenBase {
            static let topTitleLbl: UIFont = FontHelper.boldFontWithSize(25)
            static let bottomTitleLbl: UIFont = FontHelper.defaultRegularFontWithSize(18)
            static let permissionBtn: UIFont = FontHelper.defaultRegularFontWithSize(15)

        }
        struct tutorialFirst{
            static let topLbl: UIFont = FontHelper.boldFontWithSize(30)
            static let btnChangeLanguage: UIFont = FontHelper.ButtonFont!
        }
    }
    //MARK: Dashboard Folder
    struct deleteCard {
        static let continueBtnTitle: UIFont = FontHelper.ButtonFont!
        static let lblTitle: UIFont = FontHelper.defaultRegularFontWithSize(20)
        static let lblDetail: UIFont = FontHelper.defaultLightFontWithSize(16)

    }
    
    struct walletSelection {
        static let lblNoDataFound: UIFont = FontHelper.defaultRegularFontWithSize(20)
        static let availableBalanceBtn: UIFont = FontHelper.ButtonTitleFont
    }
    
    struct lastTrx {
        static let dataNotFoundLbl: UIFont = FontHelper.defaultMediumFontWithSize(13)
    }
    struct lastTrxCell {
        static let lblMerchantTitle: UIFont = FontHelper.boldFontWithSize(12)
        static let lblTime: UIFont = FontHelper.boldFontWithSize(10)
        static let lblAmount: UIFont = FontHelper.defaultRegularFontWithSize(12)
    }
    
    struct walletSelectionToKeep {
        static let btnKeep: UIFont = FontHelper.ButtonFont!
    }
    
    struct userView {
        static let lblAmountTitle: UIFont = FontHelper.defaultLightFontWithSize(13)
        static let lblName: UIFont = FontHelper.defaultMediumFontWithSize(22)
        static let lblAmount: UIFont = FontHelper.defaultMediumFontWithSize(28)
    }
    
    struct dashboardItemView {
        static let buttonTitleDefault: UIFont = FontHelper.boldFontWithSize(13)
        static let buttonTitle: UIFont = FontHelper.boldFontWithSize(13.3)
    }
    struct dashboardBarView {
        static let walletBtnTitle: UIFont = FontHelper.boldFontWithSize(13)
        static let salePointBtnTitle: UIFont = FontHelper.boldFontWithSize(13)
    }
    
    ///////////////////////////////////////////////
    
    //MARK: Wallet Folder
    
    struct cardOcr {
        static let goToManuelTitleLbl: UIFont = FontHelper.ButtonFont!
        static let addCardInfoLbl: UIFont = FontHelper.defaultMediumFontWithSize(16)
        static let takePhoto: UIFont = FontHelper.ButtonFont!

    }
    
    struct addCard {
        static let txtCardInfoLabel: UIFont = FontHelper.defaultRegularFontWithSize(15.0)
        static let lblCardNumber: UIFont = FontHelper.CardNumberFont
        static let txtCardNumber: UIFont = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct addCardSuccess {
        static let lblDate: UIFont = FontHelper.defaultLightFontWithSize(18)
        static let lblTime: UIFont = FontHelper.defaultLightFontWithSize(18)
        static let lblDescription: UIFont = FontHelper.boldFontWithSize(18)
        static let lblOwner: UIFont = FontHelper.defaultMediumFontWithSize(14)
        static let lblCardNumber: UIFont = FontHelper.CardNumberFont
        static let contBtn: UIFont = FontHelper.ButtonFont!

    }
    
    struct addCardError {
        static let btnContinue: UIFont = FontHelper.ButtonFont!
        static let btnretry: UIFont = FontHelper.ButtonFont!
        static let lblWarning: UIFont = FontHelper.defaultRegularFontWithSize(23)
        static let lblDesc: UIFont = FontHelper.defaultMediumFontWithSize(16)
    }
    
    struct paymentNewSuccess {
        static let amountLabel = FontHelper.boldFontWithSize(41)
        static let paymentSuccessDescLabel = FontHelper.boldFontWithSize(16)
        static let continueButton = FontHelper.ButtonTitleFont
    }
    
    struct paymentInfo {
        static let btnTitle = FontHelper.defaultMediumFontWithSize(18)
        static let lblHeader = FontHelper.boldFontWithSize(30)
    }
    
    struct topUp {
        static let topupThreeDBtnTitle     = FontHelper.defaultRegularFontWithSize(14)
        static let segmentedControl        = FontHelper.ButtonFont
        //static let topupOrderTitleLbl    =
    }
    
    struct topUpCardList {
        
    }
    
    struct topUpCardAdd {
        
    }
    
    struct orderComplete {
        static let orderCompleteHeaderLabel              = FontHelper.defaultLightFontWithSize(20)
        static let orderCompleteDateLabel                = FontHelper.defaultLightFontWithSize(18)
        static let orderCompleteTimeLabel                = FontHelper.defaultLightFontWithSize(18)
        
        static let amountLabel                           = FontHelper.boldFontWithSize(41)
        
        static let orderCompleteCurrentBalanceTitleLabel = FontHelper.defaultLightFontWithSize(20)
        static let orderCompleteCurrentBalanceLabel      = FontHelper.defaultMediumFontWithSize(20)
        
        static let amountAtrribute                       = FontHelper.boldFontWithSize(41)
        static let messageAttribute                      = FontHelper.boldFontWithSize(16)
        
        static let orderCompleteCloseButton              = FontHelper.ButtonTitleFont
    }
    
    struct topUpOrder {
        static let btnTitleLabel                         =  FontHelper.defaultMediumFontWithSize(16)
    }
    
    struct cardManagement {
        static let nameLabel                             = FontHelper.defaultLightFontWithSize(16)
    }
    
    struct cardOnlineSettings {
        static let dateView                              = FontHelper.TextTitleFont
    }
    
    struct cardSpending {
        static let secretQuestionTitle                   = FontHelper.defaultMediumFontWithSize(15)
    }
    
    struct eWallet {
        static let buttonPayTitle                        = FontHelper.ButtonFont
        static let buttonTopupTitle                      = FontHelper.ButtonFont
        static let buttonManageTitle                     = FontHelper.ButtonFont
        
        static let lblBalanceTitle                       = FontHelper.defaultRegularFontWithSize(23)
        static let lblBalance                            = FontHelper.defaultMediumFontWithSize(55)
        static let buttonBalanceRefreshTitle             = FontHelper.extraLightFontWithSize(14)
        
        static let lblWaitingBalanceTitle                = FontHelper.defaultRegularFontWithSize(12)
        static let lblWaitingBalance                     = FontHelper.defaultMediumFontWithSize(14)
    }
    
    struct cardTrx {
        static let notFoundText                          = FontHelper.defaultRegularFontWithSize(20)
    }
    
    struct eWalletCollectionCell {
        static let lblOwner                              = FontHelper.defaultMediumFontWithSize(15)
        static let lblCardNumber                         = FontHelper.oCRAExtendedFontWithSize(16)
        
        static let lblOwner5                             = FontHelper.defaultMediumFontWithSize(14)
        static let lblCardNumber5                        = FontHelper.oCRAExtendedFontWithSize(15)
    }
    
    struct walletAddCardCollectionCell {
        static let multinetCardTitle                     = FontHelper.boldFontWithSize(15)
        static let virtualCardTitle                      = FontHelper.boldFontWithSize(15)
    }
    
    struct walletCardView {
        static let lblOwner                              = FontHelper.defaultMediumFontWithSize(14)
        static let lblCardNumber                         = FontHelper.oCRAExtendedFontWithSize(15)
        
        static let lblOwner5                             = FontHelper.defaultMediumFontWithSize(11)
        static let lblCardNumber5                        = FontHelper.oCRAExtendedFontWithSize(12)
    }
    
    struct wallletCell {
        static let lblAmount                             = FontHelper.defaultRegularFontWithSize(20)
        static let lblOwner                              = FontHelper.defaultRegularFontWithSize(17)
        static let lblCardNo                             = FontHelper.defaultRegularFontWithSize(17)
    }
    
    struct transactionCell {
        static let lblHeader                             = FontHelper.defaultRegularFontWithSize(17)
        static let lblMerchant                           = FontHelper.defaultRegularFontWithSize(15)
        static let lblDate                               = FontHelper.defaultRegularFontWithSize(15)
        static let lblAmount                             = FontHelper.defaultRegularFontWithSize(20)
    }
    
    struct QRPayInfoCell {
        static let lblInfo                               = FontHelper.defaultLightFontWithSize(17)
        static let lblIndex                              = FontHelper.defaultLightFontWithSize(20)
        
        static let lblInfoBold                           = FontHelper.boldFontWithSize(18)
    }
    
    struct barcodeView {
        static let qrScanDescription                     = FontHelper.ButtonFont
    }
    
    struct checkView {
        static let lblTitle                              = FontHelper.defaultRegularFontWithSize(14)
    }
    
    //////////////////
    //MARK: Common Folder
    struct pushAlert {
        static let btnOk = FontHelper.ButtonFont
        static let btnLater = FontHelper.ButtonFont
        static let lblTitle = FontHelper.boldFontWithSize(20)
    }
    
    struct cardHeaderView {
        static let lblCardNumber                = FontHelper.oCRAExtendedFontWithSize(28)
        static let lblCardOwner                 = FontHelper.defaultLightFontWithSize(21)
        static let lblCardBalance               = FontHelper.defaultMediumFontWithSize(45)
        static let tatliParaAmount              = FontHelper.defaultMediumFontWithSize(20)
        static let tatliParaDescription         = FontHelper.defaultMediumFontWithSize(19)
        
        static let lblCardNumber5               = FontHelper.oCRAExtendedFontWithSize(24)
        static let lblCardBalance5              = FontHelper.defaultMediumFontWithSize(35)
        static let tatliParaDescription5        = FontHelper.defaultMediumFontWithSize(15)
    }
    
    struct quickReloadView {
        static let reloadButton1                = FontHelper.defaultRegularFontWithSize(16)
        static let reloadButton2                = FontHelper.defaultRegularFontWithSize(16)
        static let reloadButton3                = FontHelper.defaultRegularFontWithSize(16)
        static let otherButton                  = FontHelper.defaultRegularFontWithSize(16)
        
        static let descriptionLabel             = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct quickViewCell {
        static let lblFount                     = FontHelper.defaultMediumFontWithSize(15)
    }
    
    struct noDataFound {
        static let lblNotFound                  = FontHelper.defaultLightFontWithSize(13)
    }
    
    struct noDataCell {
        static let lblNoData                    = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct MTLabel {
        static let label                        = FontHelper.boldFontWithSize(14)
    }
    
    struct MTNameLabel {
        static let label                        = FontHelper.boldFontWithSize(14)
        static let name                         = FontHelper.defaultMediumFontWithSize(22)
        static let surname                      = FontHelper.defaultMediumFontWithSize(22)
    }
    
    struct MTSectionHeaderCell {
        static let lblTitle                     = FontHelper.defaultRegularFontWithSize(14)
    }
    
    struct MTDefaultCell {
        static let lblTitle                     = FontHelper.defaultRegularFontWithSize(15)
        static let lblSubtitle                  = FontHelper.defaultRegularFontWithSize(16)
        static let lblHeader                    = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct MTActionSheetLight {
        static let font                     = FontHelper.defaultRegularFontWithSize(15)
        static let title                    = FontHelper.boldFontWithSize(16)
    }
    
    struct MTActionSheetDefault {
        static let font                         = FontHelper.boldFontWithSize(15)
        static let title                        = FontHelper.boldFontWithSize(16)
    }
    
    struct inputTextView {
        static let font                         = FontHelper.TextTitleFont
        static let textFont                     = FontHelper.TextTitleFont
        
        static let txtInput                     = UIFont(name: "Montserrat-Regular", size: 16)
        static let txtInput5                    = UIFont(name: "Montserrat-Regular", size: 16)
    }
    
    struct cardScrollView {
        static let txtMerchant                  = FontHelper.defaultMediumFontWithSize(18)
        static let txtDate                      = FontHelper.defaultMediumFontWithSize(18)
    }
    
    struct MTCardView {
        static let cardNumber                   = FontHelper.oCRAExtendedFontWithSize(13)
        static let cardTypeName                 = FontHelper.defaultLightFontWithSize(13)
    }
    
    struct checkInInfo {
        static let btnTitleLabel                = FontHelper.defaultMediumFontWithSize(17)
        
        static let lblMerchantTitle             = FontHelper.boldFontWithSize(20)
        static let lblMerchantType              = FontHelper.semiBoldFontWithSize(20)
    }
    
    //MARK: Campaign Folder
    struct parantezCampaignWinView {
        static let title                             = FontHelper.defaultRegularFontWithSize(17)
        static let merchantName                      = FontHelper.defaultRegularFontWithSize(15)
        static let date                              = FontHelper.defaultRegularFontWithSize(15)
        static let amount                            = FontHelper.defaultRegularFontWithSize(17)
    }
    
    struct todayHereCell {
        static let todayTitleFont                    = FontHelper.boldFontWithSize(17)
        static let todayChekinButtonFont             = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct campaignPager {
        static let largerRedTextAttributes           = FontHelper.extraBoldFontWithSize(16)
    }
    
    
    
    struct newCampaignHeader {
        static let howCanWinFont                     = FontHelper.defaultMediumFontWithSize(20)
        static let amountFont                        = FontHelper.boldFontWithSize(30)
        static let amountInfoFont                    = FontHelper.defaultLightFontWithSize(20)
        static let amountInfoSetFont                 = FontHelper.boldFontWithSize(25)
        static let bottomDescriptionFont             = FontHelper.boldFontWithSize(15)
        static let bottomDescriptionFontSmall        = FontHelper.defaultMediumFontWithSize(13)
    }
    
    struct campaignVirtualCell {
        static let campaignTitleFont                 = FontHelper.boldFontWithSize(15)
        static let campaignSubtitleFont              = FontHelper.defaultRegularFontWithSize(14)
    }
    
    struct campaignDetail {
        static let campaignJoinedDescriptionFont     = FontHelper.defaultLightFontWithSize(14)
        static let title                             = FontHelper.boldFontWithSize(15)
        static let detail                            = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct campaignCreate {
        static let cardAggrementFont                 = FontHelper.defaultRegularFontWithSize(14)
        static let infoFont                          = FontHelper.defaultRegularFontWithSize(14)
        static let overlayAppearance                 = UIColor.black
    }
    
    struct todayHere {
        static let labelFont                         = FontHelper.boldFontWithSize(15)
    }
    
    //MARK: Settings Folder
    
    struct profileHeader {
        static let mailFont                           = FontHelper.boldFontWithSize(17)
    }
    
    struct notificationDetailCell {
        static let titleFont                         = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct notificationCell {
        static let titleFont                         = FontHelper.defaultRegularFontWithSize(15)
        static let detailFont                        = FontHelper.defaultLightFontWithSize(12)
    }
    
    struct languageCell {
        static let languageDescriptionFont           = FontHelper.boldFontWithSize(17)
        static let languageDescriptionRegularFont    = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct pinManagement {
        static let defineLimitFont                   = FontHelper.defaultRegularFontWithSize(15)
        static let pinLimitFont                      = FontHelper.defaultRegularFontWithSize(18)
        static let pinLimitDetailFont                = FontHelper.defaultLightFontWithSize(15)
        static let pinChange                         = FontHelper.defaultRegularFontWithSize(12)
    }
    
    struct pinDefineInfo {
        static let warningFont                       = FontHelper.defaultRegularFontWithSize(23)
        static let descFont                          = FontHelper.defaultMediumFontWithSize(18)
        static let infoTopFont                       = FontHelper.defaultRegularFontWithSize(14)
        static let infoTopBoldFont                   = FontHelper.boldFontWithSize(15)
    }
    
    struct pin {
        static let headerFont                        = FontHelper.boldFontWithSize(19)
        static let statusFont                        = FontHelper.defaultLightFontWithSize(17)
        
        static let btnFont                           = FontHelper.defaultRegularFontWithSize(20)
    }
    
    struct feedback {
        static let descViewFont                      = FontHelper.defaultLightFontWithSize(14)
        static let messageTitleFont                  = FontHelper.defaultRegularFontWithSize(13)
        static let nameViewFont                      = FontHelper.defaultRegularFontWithSize(14)
        static let emailViewFont                     = FontHelper.defaultRegularFontWithSize(14)
        static let phoneViewFont                     = FontHelper.defaultRegularFontWithSize(14)
        static let btnSendFont                       = FontHelper.ButtonTitleFont
        static let btnCallCenter                     = FontHelper.semiBoldFontWithSize(17)
        static let btnWhatsapp                       = FontHelper.semiBoldFontWithSize(17)
    }

    struct merchantFeedback {
        static let btnSend = FontHelper.ButtonTitleFont
        static let descTextView = FontHelper.defaultRegularFontWithSize(16)
        static let infoLabel = FontHelper.defaultRegularFontWithSize(16)
    }
    
    struct profileSettings {
        
    }
    
    struct personelInfoSettings {
        static let informHeaderFont                  = FontHelper.boldFontWithSize(16)
        static let informTextFont                    = FontHelper.defaultRegularFontWithSize(16)
        static let genderViewFont                    = FontHelper.TextTitleFont
        static let dateViewFont                      = FontHelper.TextTitleFont
    }
    
    
    //MARK: Salepoint Folder
    
    struct filterSelection {
        static let btnSelectFont                     = FontHelper.ButtonFont
    }
    
    struct facilitySection {
        static let titleFont                         = FontHelper.defaultMediumFontWithSize(14)
    }
    
    struct mercantFacility {
        static let nameFont                          = FontHelper.defaultLightFontWithSize(14)
    }
    
    struct spFilterCell {
        static let titleFont                         = FontHelper.defaultRegularFontWithSize(15)
    }
    
    struct filterNoData {
        static let titleFont                         = FontHelper.defaultLightFontWithSize(18)
    }
    
    struct filterTagCell {
        static let mainTitle                         = FontHelper.defaultLightFontWithSize(17)
    }
    
    struct spMainSelectionCell {
        static let mainTitleFont                     = FontHelper.defaultRegularFontWithSize(17)
        static let descFont                          = FontHelper.defaultRegularFontWithSize(14)
    }
    
    struct salePoint {
        static let lblHeaderFont                     = FontHelper.defaultRegularFontWithSize(16)
        static let lblSectorNameFont                 = FontHelper.defaultRegularFontWithSize(13)
        static let lblDistanceFont                   = FontHelper.boldFontWithSize(15)
    }
    
    struct parantezMerchantView {
        static let lblCampaignInfoFont               = FontHelper.defaultLightFontWithSize(14)
        static let lblLeftTopFont                    = FontHelper.defaultMediumFontWithSize(12)
        static let lblRightTopFont                   = FontHelper.defaultMediumFontWithSize(12)
        
        static let lblLeftBottomFont                 = FontHelper.defaultLightFontWithSize(13)
        static let lblRightBottomFont                = FontHelper.defaultLightFontWithSize(13)
        static let lblLoadingFont                    = FontHelper.defaultLightFontWithSize(18)
    }
    
    struct campaignInfo {
        static let lblInfoFont                       = FontHelper.defaultRegularFontWithSize(20)
        static let lblInfoBoldFont                   = FontHelper.boldFontWithSize(20)
    }
    
    struct mapView {
        static let btnSearchBarDetail                = FontHelper.defaultLightFontWithSize(13)
        static let btnSearchBarFilter                = FontHelper.boldFontWithSize(13)
        static let btnSearchCloseToMe                = FontHelper.boldFontWithSize(13)
        static let btnParantezPoints                 = FontHelper.defaultRegularFontWithSize(13)
    }
    
    struct mapViewCell {
        static let lblDistanceFont                   = FontHelper.defaultRegularFontWithSize(15)
        static let lblSectorNameFont                 = FontHelper.defaultRegularFontWithSize(13)
        static let lblHeaderFont                     = FontHelper.defaultMediumFontWithSize(16)
    }
    
    struct mapDirectionsInfo {
        static let buttonFont                        = FontHelper.SubButtonTitleFont
    }
    
    struct fuelAlert {
        static let lblMessageFont                    = FontHelper.defaultRegularFontWithSize(16)
        static let btnNeverShowFont                  = FontHelper.ButtonFont
        static let btnOKFont                         = FontHelper.ButtonFont
    }
    
    struct salePointSearch {
        static let searchBarFont                     = FontHelper.boldFontWithSize(14)
        static let titleFont                         = FontHelper.boldFontWithSize(14)
    }
    
    struct merchantDetail {
        static let lblTitleFont                      = FontHelper.boldFontWithSize(18)
        static let lblSectorName                     = FontHelper.defaultRegularFontWithSize(18)
        static let lblAdressTitleFont                = FontHelper.defaultMediumFontWithSize(14)
        static let lblPhoneTitleFont                 = FontHelper.defaultMediumFontWithSize(14)
        static let lblCampaignTitleFont              = FontHelper.defaultMediumFontWithSize(14)
        
        static let btnPhoneFont                      = FontHelper.defaultLightFontWithSize(15)
        
        static let lblAdressFont                     = FontHelper.defaultLightFontWithSize(13)
        
        static let lblTodayHereInfoFont              = FontHelper.boldFontWithSize(11)
        static let btnTodayHereFont                  = FontHelper.defaultLightFontWithSize(16)
        static let lblTodayHereInfoTopFont           = FontHelper.boldFontWithSize(11)
        static let btnTodayHereTopFont               = FontHelper.defaultLightFontWithSize(16)
        
        static let btnFeedBackTitleFont              = FontHelper.boldFontWithSize(17)
        static let btnRouteTitleFont                 = FontHelper.defaultMediumFontWithSize(13)
    }
    
    
}
