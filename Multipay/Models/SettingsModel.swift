

import Foundation

//MARK: - SettingsModel

class SettingsModel: CustomStringConvertible {
    
    var  header :String = ""
    var  title   :String = ""
    var  subtitle :String = ""
    var  screenType:ScreenType = ScreenType.non
    var  segue = ""
    var  section = false
    var  cellIdentifier = "MTDefaultCell"
    
    var description: String{
        return ("title:\(title)")
    }
    
    init(header:String = "",title:String,subtitle:String = "",screenType:ScreenType = ScreenType.non,segue:String = "",section:Bool = false,cellIdentifier:String = "MTDefaultCell"){
        
        self.header = header
        self.title = title
        self.subtitle = subtitle
        self.screenType = screenType
        self.segue = segue
        self.section = section
        self.cellIdentifier = cellIdentifier
    }
    
    
    class func loadSettings() -> [SettingsModel]{
        
        var settings = [SettingsModel] ()
        
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsPersonalInfoHeader.local, section: true,cellIdentifier:"MTSectionHeaderCell"))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsPersonalInfoSettings.local,segue:"personelSegue"))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsChangePassword.local, screenType: ScreenType.changePasswordScreen))
        
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsPaymentSettingsHeader.local, section: true,cellIdentifier:"MTSectionHeaderCell"))
        settings.append(SettingsModel(header: "", title: Localization.ProfileAndSettingsPIN.local, subtitle: "", screenType: ScreenType.pinManagementVC))
        settings.append(SettingsModel(header: "", title: Localization.ProfileAndSettingsTopUpOrder.local, subtitle: "", screenType: ScreenType.topUpOrdersVC))
        
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsNotificationSettingsHeader.local, section: true,cellIdentifier:"MTSectionHeaderCell"))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsNotificationChannels.local,screenType: ScreenType.notificationChannel))
        
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsAboutAppHeader.local, section: true,cellIdentifier:"MTSectionHeaderCell"))

        settings.append(SettingsModel(title: Localization.ProfileAndSettingsAgreement.local, subtitle: ""))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsKvkk.local, subtitle: ""))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsFAQ.local, subtitle: ""))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsContactUs.local, screenType: ScreenType.feedBackScreen))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsLanguage.local, screenType: ScreenType.languageVC))
        settings.append(SettingsModel(title: Localization.ProfileAndSettingsSignOut.local))
        settings.append(SettingsModel(title: CoreManager.getVersion(),section: true,cellIdentifier:"MTSectionHeaderCell"))
        
        return settings
        
    }
}
