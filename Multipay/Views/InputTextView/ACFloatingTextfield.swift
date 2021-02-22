//
//  ACFloatingTextfield.swift
//  ACFloatingTextField
//
//  Created by Er Abhishek Chandani on 31/07/16.
//  Copyright © 2016 Abhishek. All rights reserved.
//

import UIKit

@IBDesignable
@objc open class ACFloatingTextfield: UITextField {
    /////// sonradan eklenen
    var isPlaceHolderHidden: Bool = false
    //////
    var bottomLineView : UIView?
    var labelPlaceholder : UILabel?
    var labelErrorPlaceholder : UILabel?
    
    var showingError : Bool = false
    
    var bottomLineViewHeight : NSLayoutConstraint?
    var placeholderLabelHeight : NSLayoutConstraint?
    var errorLabelHieght : NSLayoutConstraint?
    
    /// Disable Floating Label when true.
    @IBInspectable open var disableFloatingLabel : Bool = false
    
    /// Shake Bottom line when Showing Error ?
    @IBInspectable open var shakeLineWithError : Bool = true
    
    /// Change Bottom Line Color.
    @IBInspectable open var lineColor : UIColor = UIColor.black {
        didSet{
            self.floatTheLabel()
        }
    }
    
    /// Change line color when Editing in textfield
    @IBInspectable open var selectedLineColor : UIColor = UIColor(red: 31/255, green: 134/255, blue: 255/255, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }
    
    /// Change placeholder color.
    @IBInspectable open var placeHolderColor : UIColor = UIColor(red: 147/255, green: 157/255, blue: 167/255, alpha: 1.0) {
        didSet{
            self.floatTheLabel()
        }
    }
    
    /// Change placeholder color while editing.
    @IBInspectable open var selectedPlaceHolderColor : UIColor = UIColor(red: 31/255, green: 134/255, blue: 255/255, alpha: 1.0){
        didSet{
            self.floatTheLabel()
        }
    }
    
    /// Change Error Text color.
    @IBInspectable open var errorTextColor : UIColor = UIColor(red: 81/255, green: 90/255, blue: 100/255, alpha: 1.0){
        didSet{
            self.labelErrorPlaceholder?.textColor = errorTextColor
            self.floatTheLabel()
        }
    }
    
    /// Change Error Line color.
    @IBInspectable open var errorLineColor : UIColor = UIColor(red: 250/255, green: 76/255, blue: 111/255, alpha: 1.0) {//UIColor = UIColor(red: 250/256.0, green: 76/256.0, blue: 111/256.0, alpha: 1.0) {
        didSet{
            self.floatTheLabel()
        }
    }
    
    //MARK:- Set Text
    override open var text:String?  {
        didSet {
            if showingError {
                self.hideErrorPlaceHolder()
            }
            floatTheLabel()
        }
    }
    
    override open var placeholder: String? {
        willSet {
            if newValue != "" {
                self.labelPlaceholder?.text = newValue
                
            }
        }
    }
    
    open var errorText : String? {
        willSet {
            self.labelErrorPlaceholder?.text = newValue
        }
    }
    
    //MARK:- UITtextfield Draw Method Override
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        self.upadteTextField(frame: CGRect(x:self.frame.minX, y:self.frame.minY, width:rect.width, height:rect.height));
    }
    
    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    // MARK:- Text Rect Management
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x:4, y:4, width:bounds.size.width, height:bounds.size.height);
    }
    
    //MARK:- UITextfield Becomes First Responder
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        self.textFieldDidBeginEditing()
        return result
    }
    
    //MARK:- UITextfield Resigns Responder
    override open func resignFirstResponder() -> Bool {
        let result =  super.resignFirstResponder()
        self.textFieldDidEndEditing()
        return result
    }
    
    //MARK:- Show Error Label
    public func showError() {
        showingError = true;
        self.showErrorPlaceHolder();
    }
    public func hideError() {
        showingError = false;
        self.hideErrorPlaceHolder();
        floatTheLabel()
    }
    
    public func showErrorWithText(errorText : String) {
        self.errorText = errorText;
        self.labelErrorPlaceholder?.text = self.errorText
        showingError = true;
        self.showErrorPlaceHolder();
    }
    
}

extension ACFloatingTextfield {
    
    //MARK:- ACFLoating Initialzation.
    func initialize() -> Void {
        
        self.clipsToBounds = true
        /// Adding Bottom Line
        addBottomLine()
        
        /// Placeholder Label Configuration.
        addFloatingLabel()
        
        /// Error Placeholder Label Configuration.
        addErrorPlaceholderLabel()
        /// Checking Floatibility
        if self.text != nil && self.text != "" {
            self.floatTheLabel()
        }
        
    }
    
    //MARK:- ADD Bottom Line
    func addBottomLine(){
        
        if bottomLineView?.superview != nil {
            return
        }
        //Bottom Line UIView Configuration.
        bottomLineView = UIView()
        bottomLineView?.backgroundColor = lineColor
        bottomLineView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bottomLineView!)
        
        let leadingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: bottomLineView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        bottomLineViewHeight = NSLayoutConstraint.init(item: bottomLineView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1)
        
        self.addConstraints([leadingConstraint,trailingConstraint,bottomConstraint])
        bottomLineView?.addConstraint(bottomLineViewHeight!)
        
        self.addTarget(self, action: #selector(self.textfieldEditingChanged), for: .editingChanged)
    }
    
    @objc func textfieldEditingChanged(){
        if showingError {
            hideError()
        }
    }
    
    //MARK:- ADD Floating Label
    func addFloatingLabel(){
        
        if labelPlaceholder?.superview != nil {
            return
        }
        
        var placeholderText : String? = labelPlaceholder?.text
        if self.placeholder != nil && self.placeholder != "" {
            placeholderText = self.placeholder!
        }
        labelPlaceholder = UILabel()
        labelPlaceholder?.text = placeholderText
        labelPlaceholder?.textAlignment = self.textAlignment
        labelPlaceholder?.textColor = placeHolderColor
        labelPlaceholder?.font = FontHelper.semiBoldFontWithSize(11)// UIFont.init(name: (self.font?.fontName ?? "helvetica")!, size: 12)
        labelPlaceholder?.isHidden = true
        labelPlaceholder?.sizeToFit()
        labelPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
        self.labelPlaceholder?.adjustsFontSizeToFitWidth = true
        self.labelPlaceholder?.minimumScaleFactor = 0.2
        self.labelPlaceholder?.lineBreakMode = .byTruncatingTail
        //self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor])
        if labelPlaceholder != nil {
            self.addSubview(labelPlaceholder!)
        }
        let leadingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        placeholderLabelHeight = NSLayoutConstraint.init(item: labelPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 15)
        
        self.addConstraints([leadingConstraint,trailingConstraint,topConstraint])
        labelPlaceholder?.addConstraint(placeholderLabelHeight!)
        
    }
    
    
    func addErrorPlaceholderLabel() -> Void {
        
        if self.labelErrorPlaceholder?.superview != nil{
            return
        }
        labelErrorPlaceholder = UILabel()
        labelErrorPlaceholder?.text = self.errorText
        labelErrorPlaceholder?.textAlignment = self.textAlignment
        labelErrorPlaceholder?.textColor = errorTextColor
        labelErrorPlaceholder?.font = FontHelper.defaultRegularFontWithSize(10)// UIFont(name: (self.font?.fontName ?? "helvetica")!, size: 12)
        labelErrorPlaceholder?.sizeToFit()
        labelErrorPlaceholder?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelErrorPlaceholder!)
        
        let trailingConstraint = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8)
        //    let topConstraint = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        errorLabelHieght = NSLayoutConstraint.init(item: labelErrorPlaceholder!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        
        self.addConstraints([trailingConstraint,bottomConstraint])
        labelErrorPlaceholder?.addConstraint(errorLabelHieght!)
        
    }
    
    func showErrorPlaceHolder() {
        
        bottomLineViewHeight?.constant = 2;
        
        if self.errorText != nil && self.errorText != "" {
            errorLabelHieght?.constant = 15;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.bottomLineView?.backgroundColor = self.errorLineColor;
                self.layoutIfNeeded()
            }, completion: nil)
        }else{
            errorLabelHieght?.constant = 0;
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.bottomLineView?.backgroundColor = self.errorLineColor;
                self.layoutIfNeeded()
            }, completion: nil)
        }
        
        if shakeLineWithError {
            bottomLineView?.shake()
        }
        
    }
    
    func hideErrorPlaceHolder(){
        showingError = false;
        
        if errorText == nil || errorText == "" {
            return
        }
        
        errorLabelHieght?.constant = 0;
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    //MARK:- Float & Resign
    func floatTheLabel() -> Void {
        DispatchQueue.main.async {
            if self.text == "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }else if self.text == "" && !self.isFirstResponder {
                self.resignPlaceholder()
            }else if self.text != "" && !self.isFirstResponder  {
                self.floatPlaceHolder(selected: false)
            }else if self.text != "" && self.isFirstResponder {
                self.floatPlaceHolder(selected: true)
            }
        }
    }
    
    //MARK:- Upadate and Manage Subviews
    func upadteTextField(frame:CGRect) -> Void {
        self.frame = frame;
        self.initialize()
    }
    
    //MARK:- Float UITextfield Placeholder Label
    func floatPlaceHolder(selected:Bool) -> Void {
        
        labelPlaceholder?.isHidden = self.isPlaceHolderHidden
        if selected {
            
            bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.selectedLineColor;
            labelPlaceholder?.textColor = self.selectedPlaceHolderColor;
            bottomLineViewHeight?.constant = 2;
            //self.setValue(self.selectedPlaceHolderColor, forKeyPath: "_placeholderLabel.textColor")
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor])
            
        } else {
            bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
            bottomLineViewHeight?.constant = 1;
            self.labelPlaceholder?.textColor = self.placeHolderColor
            //self.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor])
        }
        
        if disableFloatingLabel == true {
            labelPlaceholder?.isHidden = true
            return
        }
        
        if placeholderLabelHeight?.constant == 15 {
            return
        }
        
        placeholderLabelHeight?.constant = 15;
        labelPlaceholder?.font = UIFont(name: (self.font?.fontName)!, size: 11)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        })
        
    }
    
    //MARK:- Resign the Placeholder
    func resignPlaceholder() -> Void {
        
        //self.setValue(self.placeHolderColor, forKeyPath: "_placeholderLabel.textColor")

        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: self.placeHolderColor])
        
        bottomLineView?.backgroundColor = showingError ? self.errorLineColor : self.lineColor;
        bottomLineViewHeight?.constant = 1;
        
        if disableFloatingLabel {
            
            labelPlaceholder?.isHidden = true
            self.labelPlaceholder?.textColor = self.placeHolderColor;
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutIfNeeded()
            })
            return
        }
        
        placeholderLabelHeight?.constant = self.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.labelPlaceholder?.font = self.font
            self.labelPlaceholder?.textColor = self.placeHolderColor
            self.layoutIfNeeded()
        }) { (finished) in
            self.labelPlaceholder?.isHidden = true
            self.placeholder = self.labelPlaceholder?.text
        }
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidBeginEditing() -> Void {
        if showingError {
            self.hideErrorPlaceHolder()
        }
        if !self.disableFloatingLabel {
            self.placeholder = ""
        }
        self.floatTheLabel()
        self.layoutSubviews()
    }
    
    //MARK:- UITextField Begin Editing.
    func textFieldDidEndEditing() -> Void {
        self.floatTheLabel()
    }
}

//MARK:- Shake
extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.1
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
