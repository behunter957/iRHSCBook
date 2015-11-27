//
//  RHSCTeamSelectionTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

public class RHSCTeamSelectionTableViewCell : UITableViewCell {
    @IBOutlet weak var playerNameField: UILabel!
    @IBOutlet weak var segField: UISegmentedControl!
    var player : Int = 0
    
    public func configure(forPlayer: Int, setText: String?, isTeam1: Bool) {
        playerNameField.text = setText
        segField.selectedSegmentIndex = (isTeam1 ? 0 : 1)
    }
}
