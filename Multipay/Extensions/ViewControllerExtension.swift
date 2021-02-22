//
//  ViewControllerExtension.swift
//  Multipay
//
//  Created by ilker sevim on 4.09.2020.
//  Copyright © 2020 multinet. All rights reserved.
//

import Foundation
import UIKit

public func getResourceBundle(anyClass: AnyClass = Multipay.self)->Bundle?{
    return BundleManager.getPodBundle(anyClass)
}

public extension UIViewController{
    
    func getLocalizedString(key:String, comment:String = "", anyClass: AnyClass) -> String{
        let path = Bundle(for: anyClass.self).path(forResource: Strings.bundleName, ofType: "bundle")!
        let bundle = Bundle(path: path) ?? Bundle.main
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
}

