//
//  UIExtension.swift
//  PayByUp
//
//  Created by Göktuğ Aral on 03/08/2017.
//  Copyright © 2017 Göktuğ Aral. All rights reserved.
//

import UIKit
import Foundation
import SDWebImage

extension NSLayoutConstraint
{
    //We use a simple inspectable to allow us to set a value for iphone 4.
    @IBInspectable var iPhone4_Constant: CGFloat
        {
        set{
            //Only apply value to iphone 4 devices.
            if (UIScreen.main.bounds.size.height < 500)
            {
                self.constant = newValue;
            }
        }
        get
        {
            return self.constant;
        }
    }
}

//MARK: - UIWindow
public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

//MARK: - UINavigationBar
extension UINavigationBar{
    
    class func setCustomAppereance() {
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 20)!,
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: UIControl.State())
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.clear], for: UIControl.State.highlighted)
    }
}

//MARK: - UIView
extension UIView {
    
    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2
        
        
        
        guard let view =  BundleManager.getPodBundle().loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {    // 3
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(view)     // 4
        view.translatesAutoresizingMaskIntoConstraints = false   // 5
        view.bindFrameToSuperviewBounds()
        return view   // 7
    }
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self]))
    }
    
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval? = 1.0, delay: TimeInterval? = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration!, delay: delay!, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }

    func fadeOutAndInAnimation(timesRepeat: Int = 2, duration: TimeInterval? = 0.6, delay: TimeInterval? = 0.5 ){
        UIView.animate(withDuration: duration!, delay: delay!, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
            UIView.setAnimationRepeatCount(Float(timesRepeat))
            self.alpha = 0.25

        }, completion: { _ in
            self.alpha = 1.0
        })
    }

    func dropShadow(color: UIColor  = UIColor.black) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 5
        
        let shadowRect = self.bounds.insetBy(dx: 0, dy: 1);  // inset top/bottom
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    @objc func addRadiusEffect() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(width) {
            var frame = self.frame
            frame.size.width = width
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get {
            return self.bounds.size.height
        }
        
        set(height) {
            var frame = self.frame
            frame.size.height = height
            self.frame = frame
        }
    }
    
    func centerInSuperview()
    {
        var frame = self.frame
        frame.origin.x = (self.superview!.width - self.width) / 2
        frame.origin.y = (self.superview!.height - self.height) / 2
        self.frame = frame
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
    
}

//MARK: - UITableView
public extension UITableView {
    
    /// Register given `UITableViewCell` in tableView.
    /// Cell will be registered with the name of it's class as identifier.
    func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    /// Register given `UITableViewCell` in tableView.
    /// Cell will be registered with the name of it's class as identifier.
    func registerNib<T: UITableViewCell>(_:T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    /// Dequeue cell of given class from tableView.
    func dequeue<T: UITableViewCell>(_: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T ?? T()
    }
    
    func emptyMessage(message:String, font:UIFont? = FontHelper.defaultMediumFontWithSize(17), textColor:UIColor? = ColorPalette.colorGrayMako) {
        
        let messageLabel = UILabel(frame: CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height))
        //let messageLabel = UILabel(frame: CGRect(x: 0, y: 245, width: self.bounds.width, height: 300))
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = font
        messageLabel.textColor = textColor
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func removeEmptyMessage() {
        self.backgroundView = nil
        self.backgroundView?.removeFromSuperview()
    }
}

//MARK: - UICollectionView
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    public func dequeue<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
    func emptyMessage(message:String, font:UIFont? = FontHelper.defaultRegularFontWithSize(17), textColor:UIColor? = ColorPalette.colorGrayMako) {
        
        let messageLabel = UILabel(frame: CGRect(x:0, y:0, width:self.bounds.size.width, height:self.bounds.size.height))
        //let messageLabel = UILabel(frame: CGRect(x: 0, y: 245, width: self.bounds.width, height: 300))
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = font
        messageLabel.textColor = textColor
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func removeEmptyMessage() {
        self.backgroundView = nil
        self.backgroundView?.removeFromSuperview()
    }

}

//MARK: - UITextField
extension UITextField {
    func replaceNSRange(range: NSRange, withText text: String) {
        if let rangeStart = position(from: beginningOfDocument, offset: range.location){
            if let rangeEnd = position(from: rangeStart, offset: range.length) {
                replace(textRange(from: rangeStart, to: rangeEnd)!, withText: text)
            }
        }
    }
    
    func replaceString(string: String, withText text: String) {
        if self.text == nil {
            return
        }
        
        if let range = self.text!.range(of: string) {
            let rangeLocation = self.text!.distance(from: text.startIndex, to: range.lowerBound)
            let rangeLength = self.text!.distance(from: text.startIndex, to: text.endIndex)
            if let fromPosition = position(from: beginningOfDocument, offset: rangeLocation) {
                if let toPosition = position(from: fromPosition, offset: rangeLength) {
                    replace(textRange(from: fromPosition, to: toPosition)!, withText: text)
                }
            }
        }
    }
    
    func shiftSelectedTextRange(offset: Int) {
        if let previousRange = selectedTextRange {
            if let newStartPosition = position(from: previousRange.start, offset: offset) {
                if let newEndPosition = position(from: previousRange.end, offset: offset) {
                    selectedTextRange = textRange(from: newStartPosition, to: newEndPosition)
                }
            }
        }
    }
    
    var textWithCaret: String {
        get {
            insertText("|")
            let value = text!
            replaceString(string: "|", withText: "")
            return value
        }
        set {
            text = newValue
            replaceString(string: "|", withText: "")
        }
    }
}


//MARK: - UIImageView

extension UIImageView {
    func changeColor(color :UIColor = .white) {
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }

    func downloadImageFrom(urlString: String, placeholderImage: UIImage?) {
        self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholderImage)
    }
}
//MARK: - UIImage

extension UIImage {
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    class func takeScreenShot(view:UIView!) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
}

//MARK: - UITextView
extension UITextView {
    func increaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)!
    }
    
    func decreaseFontSize () {
        self.font =  UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)!
    }
}

//MARK: - UILabel
extension UILabel {
    
    func roundCorner(color:UIColor, width:CGFloat) {
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = self.bounds.width / 2
    }
    
    override func addRadiusEffect() {
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}

//MARK: - UIButton
extension UIButton {
    enum buttonType {
        case green
        case clear
    }
    
    func roundedCorners(cornerRadius: CGFloat, borderWidth: CGFloat = 0.0, borderColor: UIColor = UIColor.clear) {

        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func actionStyle(title:String, font:UIFont? = FontHelper.ButtonFont, type: buttonType? = .green, radius: CGFloat? = 5) {
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = radius!
        self.titleLabel?.font = font
        
        if type == .green {
            self.backgroundColor = ColorPalette.colorGreenButton
            
        }else{
            self.backgroundColor = UIColor.clear
            self.layer.borderWidth = 1.0
        }
    }
    
    func addShadow(color:UIColor? = .black) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = self.bounds.size.width / 2
        
        let shadowRect = self.bounds.insetBy(dx: 0, dy: 1);  // inset top/bottom
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func avatarPlaceholder() {
        //Style
        self.titleLabel!.font = FontHelper.defaultRegularFontWithSize(40)
        self.backgroundColor = ColorPalette.colorGrayMako
        self.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        //Circle
        self.layer.cornerRadius = self.bounds.size.height / 2
        self.layer.masksToBounds = true
        
        
        //Title
        guard let user = CoreManager.shared.user else {
            return
        }
        
        if(user.getUserName() != "") {
            let name =  user.getUserName()[0]
            let last =  user.getSurname()[0]
            let capitals = String(name) + String(last)
            self.setTitle(capitals, for: UIControl.State.normal)
        }
    }
    
    
    
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    func alignTextAndImage(image: UIImage?, title: String,font:UIFont, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat = 18.0, state: UIControl.State = .normal){
        self.titleLabel?.font = font
        self.titleLabel?.lineBreakMode = .byTruncatingTail
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        titleLabel?.contentMode = .center
        setTitle(title, for: state)
        
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    func alignTextAndImage(image: UIImage?, attributedTitle title: NSAttributedString, at position: UIView.ContentMode, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(title: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    
    
    
    
    
    
    // MARK: Private Methods
    private func adjust(title: NSAttributedString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = title.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(title: NSString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])

        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: UIView.ContentMode, withSpacing spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position) {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }

    

    
}

extension String {
    func getTextHeight(font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        
        label.sizeToFit()
        return label.layer.bounds.height
    }
    
    
}

extension UINavigationController {
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
