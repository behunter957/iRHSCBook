//
//  RHSCTeamScoresTableViewCell.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

open class RHSCTeamScoresTableViewCell : UITableViewCell {
    @IBOutlet weak var game1ScoreField: UITextField!
    @IBOutlet weak var game2ScoreField: UITextField!
    @IBOutlet weak var game3ScoreField: UITextField!
    @IBOutlet weak var game4ScoreField: UITextField!
    @IBOutlet weak var game5ScoreField: UITextField!
    @IBOutlet weak var gamesWonField: UILabel!
    var team : Int = 0
    
    open func configure(_ forTeam: Int, scores: [Int], gamesWon: Int) {
        team = forTeam
        game1ScoreField.text = (scores.count < 1 ? "0" : String(scores[0]))
        game2ScoreField.text = (scores.count < 2 ? "0" : String(scores[1]))
        game3ScoreField.text = (scores.count < 3 ? "0" : String(scores[2]))
        game4ScoreField.text = (scores.count < 4 ? "0" : String(scores[3]))
        game5ScoreField.text = (scores.count < 5 ? "0" : String(scores[4]))
        gamesWonField.text = String(gamesWon)
    }
}
