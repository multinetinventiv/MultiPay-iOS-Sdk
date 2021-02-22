//
//  PinCodeView.swift
//  MultiU
//
//  Created by  on 02/08/2016.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

enum PinCodeType: Int{
    
    case single = 1
    case multi = 2
}

protocol PinCodeViewDelegate: class{
    
    func pinCodeMultiProcessFirstStepCompleted()
    func pinCodeProcessCompleted(_ value: String)
    func pinCodesNotSame()
    func animationStart()
    func animationEnd()
}

class PinCodeView: UIView {

    fileprivate var diameter: CGFloat = 30.0
    fileprivate var spacing: CGFloat = 16.0
    fileprivate var thickness: CGFloat = 2.0
    fileprivate var length: Int = 4
    fileprivate var enterCount: Int = 0
    fileprivate var oldValue: String?
    
    weak var delegate: PinCodeViewDelegate?
    
    var pinCodeType: PinCodeType = PinCodeType.single
    
    var color: UIColor = ColorPalette.pinCode.color {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var text: String = "" {
        didSet {
            setNeedsDisplay()
            checkStatus()
        }
    }
    
    var isEmpty: Bool {
        return text.isEmpty
    }
    
    
    var isFilled: Bool {
        return text.count == length
    }
    
    override var intrinsicContentSize : CGSize {
        let width = CGFloat(length) * (diameter + spacing) - spacing + thickness
        let height = diameter + thickness
        return CGSize(width: width, height: height)
    }
    
    override func draw(_ rect: CGRect) {
        var origin = CGPoint.zero
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.setStrokeColor(color.cgColor)
        context!.setLineWidth(thickness)
        
        // Draw circles
        for i in 0..<length {
            
            let isDotFilled = i < text.count
            if isDotFilled {
                let dotRect = CGRect(origin: origin, size: CGSize(width: diameter + thickness, height: diameter + thickness))
                context!.fillEllipse(in: dotRect)
            } else {
                let position = CGPoint(x: origin.x + thickness/2, y: origin.y + thickness/2)
                let dotRect = CGRect(origin: position, size: CGSize(width: diameter, height: diameter))
                context!.strokeEllipse(in: dotRect)
            }
            
            origin.x += diameter + spacing
        }
        
    }
    
    fileprivate func checkStatus(){
        
        if text.count != length{
            return
        }
        
        self.delegate?.animationStart()
        
        let triggerTime = Int64(Double(NSEC_PER_SEC) * 0.5)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(triggerTime) / Double(NSEC_PER_SEC), execute: { () -> Void in
            
            self.delegate?.animationEnd()
            self.enterCount += 1
            
            if PinCodeType.single == self.pinCodeType {
                self.delegate?.pinCodeProcessCompleted(self.text)
            }else if PinCodeType.multi == self.pinCodeType{
                if self.enterCount == 1 {
                    self.oldValue = self.text
                    self.text = ""
                    self.delegate?.pinCodeMultiProcessFirstStepCompleted()
                    
                }else if self.enterCount == 2{
                    
                    if self.oldValue == self.text {
                        self.delegate?.pinCodeProcessCompleted(self.text)
                    }else{
                        self.delegate?.pinCodesNotSame()
                        self.reset()
                        
                    }
                }
                
                
            }
            
            
        })
        
        
    }
    
    func reset(){
        
        enterCount = 0
        oldValue = nil
        text = ""
       
        
    }
    
    
    // MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    fileprivate func initialSetup() {
        
    }
    
    
    
     func insertText(_ textToInsert: String) {
        if text.count + textToInsert.count <= length {
            text.append(textToInsert)
        }
    }
    
    func deleteBackward() {
        if !text.isEmpty {
            text.remove(at: text.index(before: text.endIndex))
            
        }
    }
}
