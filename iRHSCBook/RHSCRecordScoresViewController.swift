//
//  RHSCRecordScoresViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
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


class RHSCRecordScoresViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, segmentChangedProtocol, scoreChangedProtocol {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var courtAndDateCell : RHSCLabelTableViewCell? = nil
    var eventCell : RHSCLabelTableViewCell? = nil
    var player1Cell : RHSCTeamSelectionTableViewCell? = nil
    var player2Cell : RHSCTeamSelectionTableViewCell? = nil
    var player3Cell : RHSCTeamSelectionTableViewCell? = nil
    var player4Cell : RHSCTeamSelectionTableViewCell? = nil
    var scoreHeaderCell : UITableViewCell? = nil
    var game1ScoreCell : RHSCGameScoreTableViewCell? = nil
    var game2ScoreCell : RHSCGameScoreTableViewCell? = nil
    var game3ScoreCell : RHSCGameScoreTableViewCell? = nil
    var game4ScoreCell : RHSCGameScoreTableViewCell? = nil
    var game5ScoreCell : RHSCGameScoreTableViewCell? = nil
    var gamesWonCell : RHSCGamesWonTableViewCell? = nil
    
    
    var score : RHSCScore? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    var delegate : AnyObject? = nil
    
    override func viewDidLoad() {
        
//        self.tableView.accessibilityIdentifier = "RecordScores"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"
        let dateTimeFormat = DateFormatter()
        dateTimeFormat.dateFormat = "EEE, MMM d h:mm a"
        // create the cells
        courtAndDateCell = formTable.dequeueReusableCell(withIdentifier: "CourtAndDateCell") as? RHSCLabelTableViewCell
        if (courtAndDateCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            courtAndDateCell = nib?[0] as? RHSCLabelTableViewCell
        }
        courtAndDateCell?.configure(String.init(format:"%@ - %@",
            arguments: [ct!.court! , dateTimeFormat.string(from: ct!.courtTime!)]))
        
        eventCell = formTable.dequeueReusableCell(withIdentifier: "EventCell") as? RHSCLabelTableViewCell
        if (eventCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            eventCell = nib?[1] as? RHSCLabelTableViewCell
        }
        eventCell?.configure(String.init(format:"%@: %@",
            arguments: [ct!.event! , ct!.eventDesc!]))
        
        player1Cell = formTable.dequeueReusableCell(withIdentifier: "PlayerCell") as? RHSCTeamSelectionTableViewCell
        if (player1Cell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            player1Cell = nib?[2] as? RHSCTeamSelectionTableViewCell
        }
        player1Cell?.configure(1, forMember: ct!.players[1],
            isTeam1: ((ct!.players[1]!.name == score?.t1p1) || (ct!.players[1]!.name == score?.t1p2)))
        player1Cell?.delegate = self
        
        player2Cell = formTable.dequeueReusableCell(withIdentifier: "PlayerCell") as? RHSCTeamSelectionTableViewCell
        if (player2Cell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            player2Cell = nib?[2] as? RHSCTeamSelectionTableViewCell
        }
        player2Cell?.configure(2, forMember: ct!.players[2],
            isTeam1: ((ct!.players[2]!.name == score?.t1p1) || (ct!.players[2]!.name == score?.t1p2)))
        player2Cell?.delegate = self
        
        if ct!.court == "Court 5" {
            player3Cell = formTable.dequeueReusableCell(withIdentifier: "PlayerCell") as? RHSCTeamSelectionTableViewCell
            if (player3Cell == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
                player3Cell = nib?[2] as? RHSCTeamSelectionTableViewCell
            }
            player3Cell?.configure(3, forMember: ct!.players[3],
                isTeam1: ((ct!.players[3]!.name == score?.t1p1) || (ct!.players[3]!.name == score?.t1p2)))
            player3Cell?.delegate = self
            
            player4Cell = formTable.dequeueReusableCell(withIdentifier: "PlayerCell") as? RHSCTeamSelectionTableViewCell
            if (player4Cell == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
                player4Cell = nib?[2] as? RHSCTeamSelectionTableViewCell
            }
            player4Cell?.configure(4, forMember: ct!.players[4],
                isTeam1: ((ct!.players[4]!.name == score?.t1p1) || (ct!.players[4]!.name == score?.t1p2)))
            player4Cell?.delegate = self
            
        }

        scoreHeaderCell = formTable.dequeueReusableCell(withIdentifier: "TeamTitleCell")
        if (scoreHeaderCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            scoreHeaderCell = nib?[4] as? UITableViewCell
        }
        
        game1ScoreCell = formTable.dequeueReusableCell(withIdentifier: "GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game1ScoreCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game1ScoreCell = nib?[3] as? RHSCGameScoreTableViewCell
        }
        game1ScoreCell?.configure("Game 1",scores: [String(score!.game1p1!),String(score!.game1p2!)])
        game1ScoreCell?.delegate = self
        
        game2ScoreCell = formTable.dequeueReusableCell(withIdentifier: "GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game2ScoreCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game2ScoreCell = nib?[3] as? RHSCGameScoreTableViewCell
        }
        game2ScoreCell?.configure("Game 2",scores: [String(score!.game2p1!),String(score!.game2p2!)])
        game2ScoreCell?.delegate = self
        
        game3ScoreCell = formTable.dequeueReusableCell(withIdentifier: "GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game3ScoreCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game3ScoreCell = nib?[3] as? RHSCGameScoreTableViewCell
        }
        game3ScoreCell?.configure("Game 3",scores: [String(score!.game3p1!),String(score!.game3p2!)])
        game3ScoreCell?.delegate = self
        
        game4ScoreCell = formTable.dequeueReusableCell(withIdentifier: "GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game4ScoreCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game4ScoreCell = nib?[3] as? RHSCGameScoreTableViewCell
        }
        game4ScoreCell?.configure("Game 4",scores: [String(score!.game4p1!),String(score!.game4p2!)])
        game4ScoreCell?.delegate = self
        
        game5ScoreCell = formTable.dequeueReusableCell(withIdentifier: "GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game5ScoreCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game5ScoreCell = nib?[3] as? RHSCGameScoreTableViewCell
        }
        game5ScoreCell?.configure("Game 5",scores: [String(score!.game5p1!),String(score!.game5p2!)])
        game5ScoreCell?.delegate = self
        
        gamesWonCell = formTable.dequeueReusableCell(withIdentifier: "GamesWonCell") as? RHSCGamesWonTableViewCell
        if (gamesWonCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            gamesWonCell = nib?[5] as? RHSCGamesWonTableViewCell
        }
        var t1games = score!.game1p1 > score!.game1p2 ? 1 : 0
        var t2games = score!.game1p2 > score!.game1p1 ? 1 : 0
        t1games += score!.game2p1 > score!.game2p2 ? 1 : 0
        t2games += score!.game2p2 > score!.game2p1 ? 1 : 0
        t1games += score!.game3p1 > score!.game3p2 ? 1 : 0
        t2games += score!.game3p2 > score!.game3p1 ? 1 : 0
        t1games += score!.game4p1 > score!.game4p2 ? 1 : 0
        t2games += score!.game4p2 > score!.game4p1 ? 1 : 0
        t1games += score!.game5p1 > score!.game5p2 ? 1 : 0
        t2games += score!.game5p2 > score!.game5p1 ? 1 : 0
        gamesWonCell!.t1won.text = String(t1games)
        gamesWonCell!.t2won.text = String(t2games)
        
        if ct?.court == "Court 5" {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell, player3Cell, player4Cell],[scoreHeaderCell],[game1ScoreCell, game2ScoreCell,game3ScoreCell,game4ScoreCell,game5ScoreCell,gamesWonCell]]
        } else {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell],[scoreHeaderCell],[game1ScoreCell, game2ScoreCell,game3ScoreCell,game4ScoreCell,game5ScoreCell,gamesWonCell]]
        }
        
        for sect in cells {
            for myview in sect {
                myview?.selectionStyle = .none
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cells[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        switch section {
        //        case 0: return "Coordinates"
        //        case 1: return "Players"
        //        case 2: return "Event"
        //        default: return ""
        //        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.gray
        let txtView = view as! UITableViewHeaderFooterView
        txtView.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0:
            return 25.0
        case 1:
            return 44.0
        case 2:
            return 39.0
        default:
            return 47.0
        }
    }
    
    func didClickOnPlayerButton(_ sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
    }
    
    func scoreChanged() {
        score!.game1p1 = Int(game1ScoreCell!.team1score!.text!)
        score!.game1p2 = Int(game1ScoreCell!.team2score!.text!)
        score!.game2p1 = Int(game2ScoreCell!.team1score!.text!)
        score!.game2p2 = Int(game2ScoreCell!.team2score!.text!)
        score!.game3p1 = Int(game3ScoreCell!.team1score!.text!)
        score!.game3p2 = Int(game3ScoreCell!.team2score!.text!)
        score!.game4p1 = Int(game4ScoreCell!.team1score!.text!)
        score!.game4p2 = Int(game4ScoreCell!.team2score!.text!)
        score!.game5p1 = Int(game5ScoreCell!.team1score!.text!)
        score!.game5p2 = Int(game5ScoreCell!.team2score!.text!)
        var t1games = score!.game1p1 > score!.game1p2 ? 1 : 0
        var t2games = score!.game1p2 > score!.game1p1 ? 1 : 0
        t1games += score!.game2p1 > score!.game2p2 ? 1 : 0
        t2games += score!.game2p2 > score!.game2p1 ? 1 : 0
        t1games += score!.game3p1 > score!.game3p2 ? 1 : 0
        t2games += score!.game3p2 > score!.game3p1 ? 1 : 0
        t1games += score!.game4p1 > score!.game4p2 ? 1 : 0
        t2games += score!.game4p2 > score!.game4p1 ? 1 : 0
        t1games += score!.game5p1 > score!.game5p2 ? 1 : 0
        t2games += score!.game5p2 > score!.game5p1 ? 1 : 0
        gamesWonCell!.t1won.text = String(t1games)
        gamesWonCell!.t2won.text = String(t2games)
    }
    
    
    @IBAction func recordScores() {
        // obtain teams and values
        if player1Cell?.segField.selectedSegmentIndex == 0 {
            score!.t1p1 = ct!.players[1]?.name
            if ct!.court == "Court 5" {
                if player2Cell?.segField.selectedSegmentIndex == 0 {
                    score!.t1p2 = ct!.players[2]?.name
                    player3Cell?.segField.selectedSegmentIndex = 1
                    player4Cell?.segField.selectedSegmentIndex = 1
                } else {
                    score!.t2p1 = ct!.players[2]?.name
                    if player3Cell?.segField.selectedSegmentIndex == 0 {
                        score!.t1p2 = ct!.players[3]?.name
                        player4Cell?.segField.selectedSegmentIndex = 1
                    } else {
                        score!.t2p2 = ct!.players[3]?.name
                        player4Cell?.segField.selectedSegmentIndex = 0
                    }
                }
            } else {
                score!.t2p1 = ct!.players[2]?.name
                player2Cell?.segField.selectedSegmentIndex = 1
            }
        }
        score!.game1p1 = Int(game1ScoreCell!.team1score!.text!)
        score!.game1p2 = Int(game1ScoreCell!.team2score!.text!)
        score!.game2p1 = Int(game2ScoreCell!.team1score!.text!)
        score!.game2p2 = Int(game2ScoreCell!.team2score!.text!)
        score!.game3p1 = Int(game3ScoreCell!.team1score!.text!)
        score!.game3p2 = Int(game3ScoreCell!.team2score!.text!)
        score!.game4p1 = Int(game4ScoreCell!.team1score!.text!)
        score!.game4p2 = Int(game4ScoreCell!.team2score!.text!)
        score!.game5p1 = Int(game5ScoreCell!.team1score!.text!)
        score!.game5p2 = Int(game5ScoreCell!.team2score!.text!)
        var t1games = score!.game1p1 > score!.game1p2 ? 1 : 0
        var t2games = score!.game1p2 > score!.game1p1 ? 1 : 0
        t1games += score!.game2p1 > score!.game2p2 ? 1 : 0
        t2games += score!.game2p2 > score!.game2p1 ? 1 : 0
        t1games += score!.game3p1 > score!.game3p2 ? 1 : 0
        t2games += score!.game3p2 > score!.game3p1 ? 1 : 0
        t1games += score!.game4p1 > score!.game4p2 ? 1 : 0
        t2games += score!.game4p2 > score!.game4p1 ? 1 : 0
        t1games += score!.game5p1 > score!.game5p2 ? 1 : 0
        t2games += score!.game5p2 > score!.game5p1 ? 1 : 0
        score!.player1_won =  ((score!.t1p1 == score!.player1_id) || (score!.t1p2 == score!.player1_id)) ? t1games : t2games
        score!.player2_won =  ((score!.t1p1 == score!.player2_id) || (score!.t1p2 == score!.player2_id)) ? t1games : t2games
        if ct!.court == "Court 5" {
            score!.player3_won =  ((score!.t1p1 == score!.player3_id) || (score!.t1p2 == score!.player3_id)) ? t1games : t2games
            score!.player4_won =  ((score!.t1p1 == score!.player4_id) || (score!.t1p2 == score!.player4_id)) ? t1games : t2games
        }
        
        // call service to update
        if ((score?.id) != nil) {
            score?.updateScore(fromView: self)
        } else {
            score?.addScore(fromView: self)
        }
    }
    
    func teamChanged(forPlayer player: Int, forMember: RHSCMember?, isTeam1: Bool) {
        var teamCount = 0
        var plrCell : RHSCTeamSelectionTableViewCell? = nil
        for i in 1...4 {
            if i != player {
                switch i {
                case 1:
                    plrCell = player1Cell
                    break
                case 2:
                    plrCell = player2Cell
                    break
                case 3:
                    plrCell = player3Cell
                    break
                case 4:
                    plrCell = player4Cell
                    break
                default:
                    break
                }
                if plrCell != nil {
                    if plrCell!.segField.selectedSegmentIndex == 0 {
                        teamCount += (isTeam1 ? 1 : 0)
                        if teamCount > 1 {
                            plrCell!.segField.selectedSegmentIndex = (isTeam1 ? 1 : 0)
                            break
                        }
                    } else {
                        teamCount += (isTeam1 ? 0 : 1)
                        if teamCount > 1 {
                            plrCell!.segField.selectedSegmentIndex = (isTeam1 ? 1 : 0)
                            break
                        }
                    }
                }
            }
        }
    }
    
}
