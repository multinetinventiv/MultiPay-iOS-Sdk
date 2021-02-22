
import Foundation
import SwiftMessages

enum MessageType {
    case info //Success
    case error //Error
    case warning
}

class MessageManager {
    
    class func showMessage(_ messageType:MessageType,message:String,block: (() -> Void)? = nil) {
        
        if block == nil {
            
            showTopMessageView(messageType, message: message)
            
        }else{
            showMessageCustom(messageType, message: message, block: block)
        }
        
    }
    
    
    class func showTopMessageView(_ messageType: MessageType, message: String){
        let alertTitle: String = {
            switch messageType {
            case .info:
                return Localization.Info.local
            case .warning:
                return Localization.Warning.local
            case .error:
                return Localization.Error.local
            }
        }()

        if messageType == .error {
            let error = MessageView.viewFromNib(layout: .messageView)
            error.configureTheme(.error)
            error.configureContent(title: alertTitle, body: message)
            error.button?.isHidden = true
            error.titleLabel?.font = FontHelper.defaultLightFontWithSize(14)
            error.iconImageView?.isHidden = true
            var errorConfig = SwiftMessages.Config()
            errorConfig.dimMode = .gray(interactive: true)
            errorConfig.presentationStyle = .top
            errorConfig.duration = .seconds(seconds: 3)
            errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            SwiftMessages.show(config: errorConfig, view: error)
        } else if messageType == .info{
            let success = MessageView.viewFromNib(layout: .messageView)
            success.configureTheme(.success)
            success.configureContent(title: alertTitle, body: message)
            success.button?.isHidden = true
            success.titleLabel?.font = FontHelper.defaultLightFontWithSize(14)
            var successConfig = SwiftMessages.Config()
            successConfig.dimMode = .gray(interactive: true)
            successConfig.presentationStyle = .top
            successConfig.duration = .automatic
            successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            success.configureTheme(backgroundColor: ColorPalette.colorGreenTea, foregroundColor: UIColor.white)
            success.iconImageView?.isHidden = true
            SwiftMessages.show(config: successConfig, view: success)
        } else if messageType == .warning {
            let messageView = MessageView.viewFromNib(layout: .messageView)
            messageView.configureTheme(.warning)
            messageView.configureContent(title: alertTitle, body: message)
            messageView.button?.isHidden = true
            messageView.titleLabel?.font = FontHelper.defaultLightFontWithSize(14)
            var messageConfig = SwiftMessages.Config()
            messageConfig.dimMode = .gray(interactive: true)
            messageConfig.presentationStyle = .top
            messageConfig.duration = .automatic
            messageConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            messageView.iconImageView?.isHidden = true
            SwiftMessages.show(config: messageConfig, view: messageView)
        }
        
    }
    
    
    class func showMessageCustom(_ messageType:MessageType,message:String, btnTitle: String? = nil, block: (() -> Void)?){
        
        if message.contains(String(ServiceConstants.CONNECTION_WAS_CANCELLED)) || message.contains(String(ServiceConstants.CONNECTION_WAS_LOST)){
            if block != nil{
                block!()
            }
            return
        }
        
        let alertTitle = messageType == MessageType.info ? Localization.Info.local : (messageType == MessageType.error ? Localization.Error.local : Localization.Warning.local)
        let SMThemeType = MessageType.info == messageType ? Theme.success : ( MessageType.warning == messageType ? Theme.warning :Theme.error)
        
        
        let custom = MessageView.viewFromNib(layout: .messageView)
        custom.titleLabel?.font = FontHelper.defaultLightFontWithSize(14)
        custom.configureTheme(SMThemeType)
        //custom.configureDropShadow()
        custom.configureContent(title: alertTitle, body: message)
        
        if messageType == .info {
            custom.configureTheme(backgroundColor: ColorPalette.colorGreenTea, foregroundColor: UIColor.white)
        }
        if btnTitle == nil {
            custom.button?.isHidden = true
            //custom.button?.setTitle(Localization.Ok.local, for: UIControl.State())
        }else{
            
            custom.button?.setTitle(btnTitle!, for: UIControl.State())
        }

        custom.iconImageView?.isHidden = true
        
        var customConfig = SwiftMessages.Config()
        if block != nil {
            
            customConfig.dimMode = .gray(interactive: true)
        }else{
            
            customConfig.dimMode = .gray(interactive: true)
        }
        
        
        customConfig.duration = .automatic
        customConfig.presentationStyle = .top
        customConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        
        SwiftMessages.show(config: customConfig, view: custom)
        
        custom.buttonTapHandler = { _ in SwiftMessages.hide()
            if block != nil{
                block!()
            }
        }
        
    }
    
}

