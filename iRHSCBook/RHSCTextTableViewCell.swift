//
//  RHSCTextTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
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


open class RHSCTextTableViewCell : UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    open func configure(_ setText: String?) {
        textField.attributedPlaceholder = NSAttributedString(string: "optional description", attributes: [NSForegroundColorAttributeName : UIColor.blue])
        if (setText != nil) && (setText?.characters.count > 0) {
            textField.text = setText
        }

    }
}
