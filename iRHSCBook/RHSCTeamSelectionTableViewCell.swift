//
//  RHSCTeamSelectionTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol segmentChangedProtocol {
    
    func teamChanged(forPlayer: Int, isTeam1: Bool)
}
    

public class RHSCTeamSelectionTableViewCell : UITableViewCell {
    @IBOutlet weak var playerNameField: UILabel!
    @IBOutlet weak var segField: UISegmentedControl!
    var player : Int = 0
    var delegate : segmentChangedProtocol? = nil
    
    public func configure(forPlayer: Int, name: String?, isTeam1: Bool) {
        player = forPlayer
        playerNameField.text = name
        segField.selectedSegmentIndex = (isTeam1 ? 0 : 1)
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl) {
        delegate!.teamChanged(player, isTeam1: (sender.selectedSegmentIndex == 0))
    }
}
