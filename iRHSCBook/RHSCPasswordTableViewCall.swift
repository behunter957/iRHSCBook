//
//  RHSCPasswordTableViewCall.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2017-07-12.
//  Copyright © 2017 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


open class RHSCPasswordTableViewCell : UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    open func configure(_ setText: String?) {
        textField.attributedPlaceholder = NSAttributedString(string: "user ID", attributes: [NSForegroundColorAttributeName : UIColor.blue])
        if (setText != nil) && (setText?.characters.count > 0) {
            textField.text = setText
            textField.isSecureTextEntry = true
        }
    }
}
