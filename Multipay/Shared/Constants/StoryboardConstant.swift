//
//  StoryboardConstant.swift
//  MultiU
//
//  Created by  on 26/05/16.
//  Copyright © 2016 . All rights reserved.
//

import Foundation
import UIKit

enum ScreenType {
    case loginScreen,otpScreen,registerScreen,resetPasswordScreen,changePasswordScreen,feedBackScreen, topUpOrdersVC
    case dashboardScreen,profileSettingsScreen,personelInfoScreen,notificationChannel, pinManagementVC, languageVC
    case non
}

struct StoryboardConstant {
    

    static fileprivate let storyboards = [ ScreenType.loginScreen               : "Main",
                                           ScreenType.otpScreen                 : "Main",
                                           ScreenType.registerScreen            : "Main",
                                           ScreenType.resetPasswordScreen       : "Main",
                                           ScreenType.changePasswordScreen      : "Main",
                                           ScreenType.pinManagementVC           : "PinManagement",
                                           ScreenType.dashboardScreen           : "Dashbord",
                                           ScreenType.profileSettingsScreen     : "Dashbord",
                                           ScreenType.personelInfoScreen        : "Dashbord",
                                           ScreenType.notificationChannel       : "Notification",
                                           ScreenType.feedBackScreen            : "Feedback",
                                           ScreenType.languageVC                : "MSettings",
                                           ScreenType.topUpOrdersVC             : "TopUpOrder"
    ]

   static  fileprivate let viewControllers = [ ScreenType.loginScreen               : "LoginVC",
                                               ScreenType.otpScreen                 : "OTPVC",
                                               ScreenType.registerScreen            : "RegisterVC",
                                               ScreenType.resetPasswordScreen       : "ResetPasswordVC",
                                               ScreenType.changePasswordScreen      : "ResetPassword2VC",
                                               ScreenType.pinManagementVC           : "PinManagementVC",
                                               ScreenType.dashboardScreen           : "DashboardVC",
                                               ScreenType.profileSettingsScreen     : "ProfileSettingsVC",
                                               ScreenType.personelInfoScreen        : "PersonelInfoSettingsVC",
                                               ScreenType.notificationChannel       : "NotificationVC",
                                               ScreenType.feedBackScreen            : "FeedBackVC",
                                               ScreenType.languageVC                : "LanguageVC",
                                               ScreenType.topUpOrdersVC             : "TopUpOrdersVC"
                                           
    ]
    

    static func getViewController(_ screen:ScreenType) -> BaseVC? {
        
        let screenStoryboardName = storyboards[screen]
        let viewStoryboardID = viewControllers[screen]
        
        guard let storyboardName = screenStoryboardName, screenStoryboardName != nil else {
            return nil
        }
        
        guard let viewControllerID = viewStoryboardID, viewStoryboardID != nil else {
            return nil
        }
        
        let storyboard = UIStoryboard(name:storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: viewControllerID) as? BaseVC
    }
}
