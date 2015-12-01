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
    
    func teamChanged(forPlayer player: Int, forMember: RHSCMember?, isTeam1: Bool)
}
    

public class RHSCTeamSelectionTableViewCell : UITableViewCell {
    @IBOutlet weak var playerNameField: UILabel!
    @IBOutlet weak var segField: UISegmentedControl!
    var playerNum : Int = 0
    var member : RHSCMember? = nil
    var delegate : segmentChangedProtocol? = nil
    
    func configure(forPlayerNum: Int, forMember: RHSCMember?, isTeam1: Bool) {
        playerNum = forPlayerNum
        self.member = forMember
        playerNameField.text = member!.buttonText()
        segField.selectedSegmentIndex = (isTeam1 ? 0 : 1)
    }
    
    @IBAction func indexChanged(sender:UISegmentedControl) {
        delegate!.teamChanged(forPlayer: playerNum, forMember: member, isTeam1: (sender.selectedSegmentIndex == 0))
    }
}
