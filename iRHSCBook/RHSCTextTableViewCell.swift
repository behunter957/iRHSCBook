//
//  RHSCTextTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

public class RHSCTextTableViewCell : UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    public func configure(setText: String?) {
        textField.text = setText
    }
}
