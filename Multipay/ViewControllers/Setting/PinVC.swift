//
//  PinVC.swift
//  MultiU
//
//  Created by  on 02/08/2016.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

protocol PinVCDelegate {
    func pinProcessCompleted()
}

class PinVC: BaseVC {

    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var pinCodeView: PinCodeView!
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    var pinVCDelegate: PinVCDelegate?
    
    fileprivate var value:String?
    
    var enteredPin : ((_ value: String?) -> ())?
    var pinCodeType = PinCodeType.multi
    var askPin: Bool = false
    var pinFromMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = pinCodeType == PinCodeType.multi ? Localization.PinHeaderDefine.local : Localization.PinHeader.local
        self.navigationViewType = NavigationType.withLeftButton
        self.navigationEditionType = NavigationEditionType.whiteEditionType
        
        pinCodeView.delegate = self
        pinCodeView.pinCodeType = self.pinCodeType
        
        setupView()
        
    }
    
    fileprivate func setupView(){
    
        self.lblHeader.text = Localization.PinEnter.local
        lblHeader.textColor = ColorPalette.pin.headerColor
        self.lblStatus.text = ""
        lblStatus.textColor = ColorPalette.pin.statusColor
        
        lblStatus.font = FontHelper.pin.statusFont
        lblHeader.font = FontHelper.pin.headerFont
        
        let font = FontHelper.pin.btnFont
        self.btn0.titleLabel?.font = font
        self.btn1.titleLabel?.font = font
        self.btn2.titleLabel?.font = font
        self.btn3.titleLabel?.font = font
        self.btn4.titleLabel?.font = font
        self.btn5.titleLabel?.font = font
        self.btn6.titleLabel?.font = font
        self.btn7.titleLabel?.font = font
        self.btn8.titleLabel?.font = font
        self.btn9.titleLabel?.font = font
        self.btnClear.titleLabel?.font = font
        self.btnCancel.titleLabel?.font = font
        
        btnCancel.setTitle(Localization.CancelButton2.local, for: UIControl.State())
        btnClear.setTitle(Localization.ClearButton.local, for: UIControl.State())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func pressedBtn(_ sender: UIButton){
    
        if sender.tag != 10 && sender.tag != 11 {
            
            pinCodeView.insertText("\(sender.tag)")
        }else if sender.tag == 10{
            
            pinCodeView.deleteBackward()
        }else if sender.tag == 11{
        
            if askPin {
                self.dismiss(animated: true) {
                    self.enteredPin?(nil)
                };
                return
            }
            
            self.navigationController?.popViewController(animated: true)
            
        }

    }
    
    fileprivate func userInteractionChange(_ interactionEnable: Bool){
    
        self.btn0.isUserInteractionEnabled = interactionEnable
        self.btn1.isUserInteractionEnabled = interactionEnable
        self.btn2.isUserInteractionEnabled = interactionEnable
        self.btn3.isUserInteractionEnabled = interactionEnable
        self.btn4.isUserInteractionEnabled = interactionEnable
        self.btn5.isUserInteractionEnabled = interactionEnable
        self.btn6.isUserInteractionEnabled = interactionEnable
        self.btn7.isUserInteractionEnabled = interactionEnable
        self.btn8.isUserInteractionEnabled = interactionEnable
        self.btn9.isUserInteractionEnabled = interactionEnable
        self.btnCancel.isUserInteractionEnabled = interactionEnable
        self.btnClear.isUserInteractionEnabled = interactionEnable
        
        
    }
    
    
    
    fileprivate func callService(){
    
    
        if self.value == nil {
            return
        }
        
        
        let param = ["PinCode" : self.value!]
        
        
        
        post(ServiceConstants.ServiceName.UpdatePin, parameters: param as [String : AnyObject], displayError: true, displaySpinner: true, callback: { [weak self](data:[String:AnyObject]?, rawData) in
            
            if let strongSelf = self
            {
                if let data  = data {
                    
                    log.debug("data : \(data)")
                    
                    if  strongSelf.checkResultCodeAndShowError(data) == ServiceResultCodeType.exit {
                        strongSelf.definePinProcessReset()
                        return
                    }
                    
                    
                    if (ServiceUrl.isPROD()) {
                         strongSelf.openOTPVC(param as [String : AnyObject], response: data,smsCode:nil)
                    }else{
                        
                         //strongSelf.openOTPVC(param, response: data)
                        //return
                        
            
                        if let result = data[resultKey] {
                            strongSelf.openOTPVC(param as [String : AnyObject], response: data,smsCode:strongSelf.getSMSCode( (result["SmsMessage"] as? String)!))
//                            strongSelf.showMessage(MessageType.Info, message:  (result["SmsMessage"] as? String)!,block: {
//                                strongSelf.openOTPVC(param, response: data)
//                            })
                        }
                    }
                }
            }

            }) { [weak self] (data: ErrorModel, rawData) in
                log.info("")
                if let strongSelf = self {
                    
                    strongSelf.definePinProcessReset()
                }
        }
    }

    fileprivate func getSMSCode(_ message:String)->String {
        
        
        let array = message.components(separatedBy: ": ")
        if(array.count >= 2 ) {
            return array[1]
        }else{
            
            // let leng =  message.characters.count
            
            //let startIndex  = message.endIndex
            
            
            // Access the substring.
           // let substring = value[range]            let string = mes
           // return String
            
        }
        return ""
    }
    
    fileprivate func openOTPVC(_ param: [String : AnyObject], response: [String : AnyObject],smsCode:String?){
    
        let vc : OTPVC = OTPVC.instantiate()
        //vc.registerData = response[resultKey] as? [String : AnyObject]
        vc.loginRequestParameters = param
        vc.serviceName = ServiceConstants.ServiceName.UpdatePin
        vc.resendServiceName = ServiceConstants.ServiceName.UpdatePin
        vc.delegate = self
        vc.smsCode = smsCode
        vc.otpCalledType = pinFromMenu ? OTPCalledType.pinSettings : OTPCalledType.pinDefinition
        definePinProcessReset()
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
    
    
    fileprivate func definePinProcessReset(){
        self.lblHeader.text = Localization.PinEnter.local
        self.lblStatus.text = ""
        pinCodeView.reset()
    }

}


//MARK: - OTPVCDelegate
extension PinVC: OTPVCDelegate{
    
     func otpDidFinishSuccess(_ otpVC:OTPVC,result:[String:AnyObject]?)
     {
        otpVC.navigationController?.popViewController(animated: false)
        self.navigationController?.popViewController(animated: true)
        self.pinVCDelegate?.pinProcessCompleted()
        CoreManager.Instance().user!.pinCodeProtected = true
    }
}

extension PinVC: PinCodeViewDelegate{

    func pinCodeMultiProcessFirstStepCompleted() {
        log.debug("")
        self.lblHeader.text = Localization.PinReEnter.local
    }
    
    func pinCodeProcessCompleted(_ value: String) {
        log.debug("")
        self.lblStatus.text = Localization.PinSuccess.local
        
        self.value = value
        
        if askPin {
        
            self.dismiss(animated: true) {
                
                self.enteredPin?(self.value)
            };
            
        }else{
        
            callService()
        }
        
        

    }
    
    func pinCodesNotSame() {
        log.debug("")
        self.lblHeader.text = Localization.PinEnter.local
        self.lblStatus.text = Localization.PinFailed.local
    }
    
    func animationStart() {
        userInteractionChange(false)
    }
    
    func animationEnd() {
        userInteractionChange(true)
    }
    
}

extension PinVC: StoryboardInstantiable {
    
    static var storyboardName: String { return "PinManagement" }
    static var storyboardIdentifier: String? { return "PinVC" }
}
