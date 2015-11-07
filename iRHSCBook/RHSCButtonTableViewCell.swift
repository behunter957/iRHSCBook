//
//  RHSCButtonTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

public class RHSCButtonTableViewCell : UITableViewCell {
    @IBOutlet weak var buttonField: UIButton!
    
    public func configure(buttonText: String?) {
        if let targText = buttonText {
            let aText = NSAttributedString.init(string: targText)
            buttonField.setAttributedTitle(aText, forState: .Normal)
            buttonField.contentHorizontalAlignment = .Right
        }
    }
}
