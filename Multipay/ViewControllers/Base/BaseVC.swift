//
//  BaseViewController.swift
//  Multipay
//
//  Created by ilker sevim on 7.09.2020.
//

import UIKit
import SwiftMessages
import PopupDialog

typealias SuccessCallBack = (_ dictionary: [String:AnyObject]?, _ rawData: Data?) -> Void
typealias ErrorCallBack = (_ errorModel: ErrorModel, _ rawData: Data?) -> Void


enum NavigationType {
    case noN
    case withLeftButton
    case withRightButton
    case withBothButton
    case withTitleOnly
    case other
}

enum NavigationEditionType {
    case whiteEditionType
    case blackEditionType
    case greenEditionType
}

enum ServiceResultCodeType {
    case exit
    case `continue`
    case agreement
}

let REGUEST_ERROR_CODE   = "999"

class BaseVC: UIViewController {
    
    var hasKeyboard = false
    var activeTextField :MTextField?
    var activeTextView :InputTextView?
    
    var viewMoved = false
    var keyboardHeight :CGFloat = 0.0
    
    var initialYPosition :CGFloat = 0.0
    
    var spinner :SpinnerView?
    var alertView :UIAlertController?
    
    //var navigationBarView:NavigationBarView?
    var navigationViewType:NavigationType = .noN
    var navigationEditionType:NavigationEditionType = .whiteEditionType
    
    
    var keyboardScrollView:UIView?
    
    var currentRequest:CustomRequest?
    
    var statusBarView : UIView?
    
    var analyticsScreenName: String?
    
    var overlayBackGroundView: UIView?
    
    lazy var requestList : [CustomRequest] = [CustomRequest]()
    
    private var mpStatusBarStyle: UIStatusBarStyle = .lightContent {
        didSet(newValue) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: - Lifecycle
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return mpStatusBarStyle
    }
    
    func updateStatusBarStyle(forStyle style: UIStatusBarStyle, withDuration: Double = Constants.STATUS_BAR_STYLE_ANIMATION_DURATION) {
        UIView.animate(withDuration: withDuration) {
            self.mpStatusBarStyle = style
        }
    }
    
    var mpStatusBarHidden: Bool = false {
        didSet(newValue) {
            UIView.animate(withDuration: Constants.STATUS_BAR_STYLE_ANIMATION_DURATION) {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return mpStatusBarHidden
    }
    
    func hideStatusBar() {
        self.mpStatusBarHidden = true
    }
    
    func showStatusBar() {
        self.mpStatusBarHidden = false
    }
    
    deinit{
        log.debug("")
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func gotoDashboard()  {
        
        CoreManager.Instance().viewControllerStack.clear()
        
        log.debug("Will open dashboard or necessary vc")
        
        let nav = self.navigationController as! MyNavigationController
        nav.openWalletFromOTP()
        
        //appDelegate.window?.rootViewController  = UINavigationController(rootViewController: DashboardVC.instantiate())
    }
    
}

//MARK: - LifeCycle
extension BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *), !ColorPalette.isDarkModeSupported {
            overrideUserInterfaceStyle = .light
        }
        self.navigationController?.delegate = self
        self.navigationController?.navigationBar.backItem?.title = ""
        
        self.navigationController?.navigationBar.barTintColor = ColorPalette.login.loginViewBackground()
        self.navigationController?.navigationBar.tintColor = ColorPalette.tintColor()
        self.view.backgroundColor = ColorPalette.login.loginViewBackground()
        
        //addNavBarImageAndBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //CoreManager.Instance().pushVCToSctack(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        if(hasKeyboard){
            registerKeyboardNotificarion(false)
        }
        if Multipay.testModeActive{
            log.debug("Controller Disappear : \(self.className)")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateStatusBarStyle(forStyle: .lightContent)
        let coordinator = self.navigationController?.topViewController?.transitionCoordinator
        
        if coordinator != nil &&  coordinator!.initiallyInteractive {
            coordinator!.notifyWhenInteractionChanges({ (context) in
                
                if !context.isCancelled {
                    self.calculateNavigationBarTypeView()
                }
            })
            
        }else{
            
            calculateNavigationBarTypeView()
        }
        
        registerKeyboardNotificarion(true)
        addGestureRecognizer()
        
        initialYPosition  = self.view.frame.origin.y
        if(self.keyboardScrollView != nil) {
            initialYPosition  = self.keyboardScrollView!.frame.origin.y
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        log.debug("!!!!! MEMORY WARNING !!!!!!!!")
    }
    
    @objc func goBack()
    {
        print("Going back!")
        //self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: -  Messages
extension BaseVC {
    
    func popupAlertController (_ popupTitle:String, popupMessage:String, cancelBtnTitle:String = Localization.AlertCancel.local, okBtnTitle:String = Localization.AlertDone.local) {
        
        let alertController = UIAlertController(title: popupTitle, message: popupMessage, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .cancel) { (action) in
            self.popupCancelAction()
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: okBtnTitle, style: .default) { (action) in
            self.popupDoneAction()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
    
    @objc func popupCancelAction(){
        //cancel...
    }
    
    @objc func popupDoneAction(){
        //done..
    }
    
    
    func showMessage(_ messageType: MessageType, message: String, btnTitle: String? = nil, block: (() -> Void)? = nil) {
        if block == nil {
            MessageManager.showTopMessageView(messageType, message: message)
        } else {
            MessageManager.showMessageCustom(messageType, message: message, btnTitle: btnTitle, block: block)
        }
    }
    
    
    func checkResultCodeAndShowError(_ data: [String:AnyObject],showMessage:Bool = true) -> ServiceResultCodeType
    {
        
        if let resultCode =  data[resultCodeKey]  {
            
            let errorCode = resultCode as! Int
            //Success
            if errorCode == 0 {
                return ServiceResultCodeType.continue
            }
            
            //Gösterilmesi Gereken Hata Mesajları
            if errorCode >= 21401 && errorCode <= 21450{
                
                if (showMessage) {
                    if let resultMessage = data[resultMessageKey] as? String {
                        self.showMessage(MessageType.error, message: resultMessage)
                    }
                }
                return ServiceResultCodeType.exit
                
            }
            
            if errorCode == 20015 || errorCode == 21500{
                
                if (showMessage) {
                    if let resultMessage = data[resultMessageKey] as? String {
                        self.showMessage(MessageType.error, message: resultMessage)
                    }
                }
                return ServiceResultCodeType.exit
                
            }
            
            if errorCode == ServiceConstants.SECURE_CALL_ERROR{
                
                if(showMessage){
                    if let resultMessage = data[resultMessageKey] as? String {
                        self.showMessage(MessageType.error, message: resultMessage)
                    }
                }
                return ServiceResultCodeType.exit
            }
            
            //Session Hatası
            if  errorCode == ServiceConstants.SESSION_ERROR {
                
                //CoreManager.instance.clear()
                //appDelegate.window?.rootViewController  = UINavigationController(rootViewController: LoginVC.instantiate())
                return ServiceResultCodeType.exit
            }
            
            //Agreement Hatası
            if  errorCode == ServiceConstants.AGGREMENT_ERROR {
                return ServiceResultCodeType.agreement
            }
            
            
            //Sistem Hata Mesajları
            //21500 ignore edildi.
            if errorCode >= 21450 && errorCode < 21500 {
                if (showMessage) {
                    self.showMessage(.error, message: Localization.ErrorSystem.local + " - " + String(errorCode))
                }
                return ServiceResultCodeType.exit
            }
            
            
            //Token veya Type Hatası
            if errorCode == ServiceConstants.TOKEN_ERROR ||  errorCode == ServiceConstants.TYPE_ERROR {
                self.showMessage(.error, message: Localization.ErrorSystem.local + " - " + String(errorCode))
                return ServiceResultCodeType.exit
            }
            
            //Bilinmeyen Hata
            if errorCode == ServiceConstants.UNKNOWN_ERROR || errorCode == ServiceConstants.NO_SERVICE_AUTHORIZATION{
                if (showMessage) {
                    self.showMessage(MessageType.error, message: Localization.ErrorSystem.local)
                }
                return ServiceResultCodeType.exit
            }
            
            if (showMessage) {
                self.showMessage(MessageType.error, message: Localization.ErrorSystem.local)
            }
            return ServiceResultCodeType.exit
            
        }
        
        return ServiceResultCodeType.exit
        
    }
    
}

extension BaseVC{
    
    func showOverlayView() {
        overlayBackGroundView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        overlayBackGroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.9)//UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(overlayBackGroundView!)
        
    }
    
    func hideOverlayView() {
        overlayBackGroundView?.removeFromSuperview()
        overlayBackGroundView = nil
    }
    
    func calculateNavigationBarTypeView(){
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.backItem?.title = ""
        self.navigationController?.navigationBar.backItem?.leftBarButtonItem?.title = ""
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: #selector(goBack))
        
        var textAttr : [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!]
        
        switch navigationEditionType {
        case .blackEditionType:
            self.updateStatusBarStyle(forStyle: .default)
            self.navigationController?.navigationBar.tintColor = ColorPalette.tintColor()
            textAttr = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!]
            self.navigationController?.navigationBar.isTranslucent = false
        case .whiteEditionType:
            self.updateStatusBarStyle(forStyle: .lightContent)
            self.navigationController?.navigationBar.tintColor = ColorPalette.tintColor()
            textAttr = [NSAttributedString.Key.foregroundColor: ColorPalette.navTitleColor(), NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 20)!]
            self.navigationController?.navigationBar.isTranslucent = false
        case .greenEditionType:
            self.updateStatusBarStyle(forStyle: .default)
            self.navigationController?.navigationBar.tintColor = ColorPalette.tintColor()
            textAttr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 20)!]
            self.navigationController?.navigationBar.barTintColor = ColorPalette.colorGreenTea
            self.navigationController?.navigationBar.isTranslucent = false
        }
        self.navigationController?.navigationBar.titleTextAttributes = textAttr
        
        if ( navigationViewType == NavigationType.withRightButton){
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sdkCloseBtn", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil), style: UIBarButtonItem.Style.plain, target: self, action: #selector(BaseVC.presentModalWillDismiss))
            
        }else if navigationViewType == NavigationType.withLeftButton{
            
            //self.navigationController?.isNavigationBarHidden = true
            
            
            
            let inserts = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            
            let backImage = UIImage(named: "backButton", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil)
            
            self.navigationController?.navigationBar.backIndicatorImage = backImage?.withAlignmentRectInsets(inserts)
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage?.withAlignmentRectInsets(inserts)
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            //self.navigationItem.backBarButtonItem = UIBarButtonItem(image: backImage, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
            self.navigationItem.setHidesBackButton(false, animated: false)
            
        }else if navigationViewType == NavigationType.withTitleOnly{
            
            //self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated: false)
            
        }else if navigationViewType == NavigationType.noN{
            
            self.navigationController?.isNavigationBarHidden = true
        }
        
        
    }
    
    func addNavBarImageAndBarButtons() {
        let navController = self.navigationController!
        let image = UIImage(named: "TopLogo", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil)
        let imageView = UIImageView(image: image)
        let bannerWidth = navController.navigationBar.frame.size.width * 0.362
        let bannerHeight: CGFloat = 24.22
        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        
        let titleBackView = UIView()
        titleBackView.backgroundColor = UIColor.clear
        titleBackView.frame = CGRect(x: 0, y: 0, width: navController.navigationBar.frame.size.width, height: 40)
        titleBackView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(bannerWidth)
            make.height.equalTo(bannerHeight)
        }
        
        
        self.navigationItem.titleView = titleBackView
    }
    
    @objc func presentModalWillDismiss(animated: Bool = true){
        self.dismiss(animated: animated, completion: nil)
    }
    
    func presentModal(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        
        
        if(viewControllerToPresent.isKind(of: UIImagePickerController.self) || viewControllerToPresent.isKind(of: UIAlertController.self) || viewControllerToPresent.isKind(of: PopupDialog.self) ) {
            super.present(viewControllerToPresent, animated: flag, completion: nil)
            return
        }
        
        if viewControllerToPresent is UINavigationController {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
            
        }else{
            
            let nav = UINavigationController(rootViewController: viewControllerToPresent)
            nav.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            super.present(nav, animated: flag, completion: completion)
            
        }
        
    }
    
}

//MARK: - Service Ops
extension BaseVC {
    
    func showHUD(_ show:Bool,text:String = "",addMainWindow:Bool = true)  {
        DispatchQueue.main.async {
            if(show)
            {
                if self.spinner != nil {
                    return
                }
                self.spinner = SpinnerView(view: self.view, text: text,isInMainwindow:addMainWindow)
                
            }else {
                self.spinner?.removeFromSuperview()
                self.spinner = nil
            }
        }
    }
    
    func post(_ serviceName: String, isSdkService: Bool = true, parameters: [String: AnyObject]?, isCancelable:Bool = true, displayError: Bool = true, isSecure: Bool = false, displaySpinner: Bool = true, addMainWindow: Bool = true, retryCount:Int = 0, httpMethod: HTTPMethod = .post, callback: @escaping SuccessCallBack,errorCallback:@escaping ErrorCallBack) {
        
        //HUD Operations Start ---
        let prod = ServiceUrl.isPROD() || ServiceUrl.isPILOT()
        if displaySpinner {
            showHUD(true,text:prod ? "" : serviceName, addMainWindow:addMainWindow)
        }
        //HUD operations End ---
        
        
        ServiceInvokerHandler.sharedInstance.post(serviceName,
                                                  isSdkService: isSdkService,
                                                  parameters: parameters ?? [:],
                                                  isCancelable: isCancelable,
                                                  applicationType: ServiceInvokerHandler.ServiceInvokerHandlerApplicationType.multiPay,
                                                  httpMethod: httpMethod,
                                                  callback: { [weak self]
                                                    
                                                    (responseSuccess, rawData)  in
                                                    
                                                    guard let strongSelf = self else { return }
                                                    
                                                    if displaySpinner {
                                                        strongSelf.showHUD(false,text:serviceName, addMainWindow:addMainWindow)
                                                    }
                                                    
                                                    DispatchQueue.main.async(execute: {
                                                        guard let response = responseSuccess, let resultCode = response[resultCodeKey] as? Int else { return }
                                                        
                                                        if resultCode == ServiceConstants.KVKK_AGGREEMENT_ERROR {
                                                            print("KVKK_AGGREEMENT_ERROR")
                                                            //strongSelf.showKVKKAgreementVC()
                                                        } else if displayError {
                                                            _ = self?.checkResultCodeAndShowError(response)
                                                        }
                                                    })
                                                    callback(responseSuccess, rawData)
                                                  })
        { [weak self] (responseFail, rawData) in
            guard let strongSelf = self else { return }
            if displaySpinner {
                strongSelf.showHUD(false,text:serviceName, addMainWindow:addMainWindow)
            }
            
            DispatchQueue.main.async(execute: {
                
                var jsonDict: [String:AnyObject] = [:]
                
                if let rawData = rawData{
                    do {
                        jsonDict = try JSONSerialization.jsonObject(with: rawData, options: .mutableContainers) as? [String:AnyObject] ?? [:]
                    } catch {
                        print("Something went wrong")
                    }
                }
                
                let resultCode = jsonDict["resultCode"] as? Int
                
                var message = responseFail.description
                
                if responseFail.code != "-999", responseFail.code != "0" {
                    
                    if let resultMessage = jsonDict["resultMessage"]{
                        message = resultMessage as! String
                    }
                    
                    if (retryCount < Constants.maxRetryCount && resultCode != 20201 && responseFail.code != String(ServiceConstants.NO_INTERNET_CONNECTION)) || responseFail.code == String(ServiceConstants.CONNECTION_WAS_LOST) || responseFail.code == String(ServiceConstants.CONNECTION_WAS_CANCELLED)
                    {
                        strongSelf.post(serviceName, parameters: parameters, retryCount: retryCount + 1, callback: callback, errorCallback: errorCallback)
                        return
                    }
                    else {
                        
                        MessageManager.showMessageCustom(.error, message: message, btnTitle: resultCode != 20201 ? Localization.Retry.local : nil) {
                            strongSelf.post(serviceName, parameters: parameters, retryCount: retryCount + 1, callback: callback, errorCallback: errorCallback)
                            return
                        }
                    }
                }
                
                let errorModel = ErrorModel(code: responseFail.code, message: message)
                errorCallback(errorModel, rawData)
            })
        }
        
    }
    
    
    
}

//MARK: - InputTextViewDelegate
extension BaseVC :InputTextViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: MTextField,textView:InputTextView? = nil) {
        self.activeTextField = textField
        self.activeTextView = textView
    }
    
    func textFieldDidEndEditing(_ textField: MTextField,textView:InputTextView? = nil) {
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(textField: MTextField,textView:InputTextView? = nil) {
        textView?.resignFirstResponder()
    }
    
    func textFieldShouldNext(textField: MTextField, textView: InputTextView?) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String, textView: InputTextView) -> Int {
        
        return 0
    }
    
    func inputTextTappedWith(textView: InputTextView) {
        
    }
}

//MARK: - Keyboard Process
extension BaseVC {
    
    func addGestureRecognizer()  {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseVC.hidekeyboard))
        tap.cancelsTouchesInView    = false
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func hidekeyboard() {
        self.view.endEditing(true)
    }
    
    
    func registerKeyboardNotificarion(_ register:Bool)
    {
        if(register){
            
            NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keybordWillBeShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(BaseVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }else{
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
    }
    
    @objc public func keybordWillBeShow(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardSize.height
                if self.activeTextField != nil
                {
                    moveViewForKeyboard()
                }
            }
        }
        
    }
    
    @objc public func keyboardWillHide(_ notification: Notification)
    {
        self.keyboardHeight = 0
        moveViewToInitial()
    }
    
    
    
    @objc func moveViewForKeyboard()  {
        
        if (hasKeyboard)
        {
            if let activeFieldPresent = self.activeTextField
            {
                let windowSize = self.view.window?.frame.size
                
                var navigationBarSize  = CGSize(width: 0, height: 0)
                
                if let navigationBarSizeTemp = self.navigationController?.navigationBar.frame.size {
                    navigationBarSize = navigationBarSizeTemp
                }
                
                var scrollView  = self.view
                
                if let view = self.keyboardScrollView {
                    scrollView = view
                }
                
                
                var frame  = scrollView?.frame
                
                let activeFieldPosition = activeFieldPresent.convert(activeFieldPresent.bounds, to: nil)
                
                let activeFieldBottomPoint  = activeFieldPosition.size.height +  activeFieldPosition.origin.y
                let visibleAreaEndPoint     =  (windowSize?.height)! - self.keyboardHeight
                
                navigationBarSize.height += 20
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    if(activeFieldPosition.origin.y < navigationBarSize.height)
                    {
                        frame?.origin.y += (navigationBarSize.height + activeFieldBottomPoint )
                        
                        
                        if(scrollView?.isKind(of: UIScrollView.self))!
                        {
                            var point = (scrollView as! UIScrollView).contentOffset
                            point.y = (frame?.origin.y)! - 10
                            (scrollView as! UIScrollView).setContentOffset(point, animated: true)
                        }else{
                            scrollView?.frame    = frame!;
                        }
                        
                        
                        
                    }else{
                        
                        if(activeFieldBottomPoint >= visibleAreaEndPoint)
                        {
                            frame?.origin.y  -= ((activeFieldBottomPoint + activeFieldPosition.size.height) - visibleAreaEndPoint );
                        }
                        if((scrollView?.frame.origin.y)! > (frame?.origin.y)!)
                        {
                            if(scrollView?.isKind(of: UIScrollView.self))!
                            {
                                var point = (scrollView as! UIScrollView).contentOffset
                                point.y += ((activeFieldBottomPoint + activeFieldPosition.size.height) - visibleAreaEndPoint )
                                
                                (scrollView as! UIScrollView).setContentOffset(point, animated: true)
                            }else{
                                scrollView?.frame    = frame!;
                            }
                            
                        }
                    }
                })
            }
        }
    }
    
    @objc func moveViewToInitial()  {
        UIView.animate(withDuration: 0.3, animations: {
            
            var scrollView  = self.view
            
            if let view = self.keyboardScrollView {
                scrollView = view
            }
            
            var frame = scrollView?.frame
            frame?.origin.y = self.initialYPosition
            scrollView?.frame = frame!
        })
    }
    
}

// MARK: - Navigation Process
extension BaseVC : UINavigationControllerDelegate{}


// MARK: - Navigation Process
extension BaseVC : UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        // SWMessage.sharedInstance.dismissActiveNotification()
        
        
        guard let view = touch.view, touch.view != nil else {
            return true
        }
        
        if (view .isKind(of: UIControl.self)){
            return false
        }
        
        return true
    }
    
}


//MARK: - useragrrement
extension BaseVC:AgreementViewDelegate {
    
    @objc func agreedUserAgreementClicked(type: AgreementViewType) {
        CoreManager.shared.getUser()
    }
    @objc func disagreedUserAgreementClicked(type: AgreementViewType) {
        //logout()
    }
    
}

//MARK : Logout
extension BaseVC {
    
    func logout()
    {
        let parameters = ["" : ""]
        _ = post(ServiceConstants.ServiceName.Logout, parameters: parameters as [String : AnyObject] , displayError: false, displaySpinner:false,callback: { (data:[String:AnyObject]?, rawData) in
            //....
        },errorCallback: {(data: ErrorModel, rawData) in
            log.error("error : \(data.description)")
        })
        
        CoreManager.instance.clear()
        self.navigationController?.popToRootViewController(animated: true)
        //appDelegate.window?.rootViewController  = UINavigationController(rootViewController: LoginVC.instantiate())
        
    }
    
}

/*
 @objc internal func showUserAggrementVC(){
 
 let vc = AgreementVC.instantiate()
 vc.delegate = self
 vc.agreementViewType = AgreementViewType.error
 
 vc.providesPresentationContextTransitionStyle = true;
 vc.definesPresentationContext = true;
 self.present(vc, animated: true, completion: nil)
 }
 
 @objc internal func showKVKKAgreementVC(){
 //ServiceInvoker.sharedInstance.stopOngoingRequests()
 
 let vc = AgreementVC.instantiate()
 vc.agreementViewType = AgreementViewType.kvkk
 vc.providesPresentationContextTransitionStyle = true;
 vc.definesPresentationContext = true;
 
 if #available(iOS 13.0, *) {
 vc.isModalInPresentation = true
 } else {
 vc.modalPresentationStyle = .fullScreen
 }
 
 navigationController?.present(vc, animated: true, completion: nil)
 }
 
 
 @objc func userLoaded(){
 }
 }
 */
