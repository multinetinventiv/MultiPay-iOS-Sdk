//
//  RadioButton.swift
//  Multipay
//
//  Created by ilker sevim on 2.11.2020.
//

import Foundation
import UIKit

protocol RadioButtonDelegate {
    func onClick(_ sender: UIView)
}

class RadioButton: UIButton {
    var checkedView: UIImageView = UIImageView(image: UIImage(named: "radioChecked", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil))
    
    var uncheckedView: UIImageView = UIImageView(image: UIImage(named: "radioUnchecked", in: getResourceBundle(anyClass: LoginVC.self), compatibleWith: nil))
    
    var delegate: RadioButtonDelegate?
    
    var isChecked: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(onClick), for: UIControl.Event.touchUpInside)
        self.setTitle("", for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(onClick), for: UIControl.Event.touchUpInside)
        self.setTitle("", for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        checkedView.removeFromSuperview()
        uncheckedView.removeFromSuperview()
        //removeConstraints(self.constraints)
        
        let view = isChecked == true ? checkedView : uncheckedView
        addSubview(view)
        
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    @objc func onClick(sender: UIButton) {
        if sender == self {
            delegate?.onClick(self)
        }
    }
}
