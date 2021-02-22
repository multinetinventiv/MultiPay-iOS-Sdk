//
//  BaseView.swift
//  MultiPay
//
//  Created by Göktuğ Aral on 26/01/17.
//  Copyright © 2017 Göktuğ Aral. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    
}

