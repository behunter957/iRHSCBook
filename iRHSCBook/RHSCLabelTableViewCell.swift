//
//  RHSCLabelTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-07.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

public class RHSCLabelTableViewCell : UITableViewCell {
    @IBOutlet weak var labelField: UILabel!
    
    public func configure(labelText: String?) {
        labelField.text = labelText
    }
}
