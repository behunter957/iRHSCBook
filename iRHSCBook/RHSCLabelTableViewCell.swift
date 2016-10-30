//
//  RHSCLabelTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

open class RHSCLabelTableViewCell : UITableViewCell {
    @IBOutlet weak var labelField: UILabel!
    
    open func configure(_ labelText: String?) {
        labelField.text = labelText
    }
}
