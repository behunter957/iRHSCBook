//
//  RHSCRecordScoresViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCRecordScoresViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var courtAndDateCell : RHSCLabelTableViewCell? = nil
    var eventCell : RHSCLabelTableViewCell? = nil
    var player1Cell : RHSCTeamSelectionTableViewCell? = nil
    var player2Cell : RHSCTeamSelectionTableViewCell? = nil
    var player3Cell : RHSCTeamSelectionTableViewCell? = nil
    var player4Cell : RHSCTeamSelectionTableViewCell? = nil
    var team1ScoresCell : RHSCTeamScoresTableViewCell? = nil
    var team2ScoresCell : RHSCTeamScoresTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    var delegate : AnyObject? = nil
    
    override func viewDidLoad() {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        let dateTimeFormat = NSDateFormatter()
        dateTimeFormat.dateFormat = "EEE, MMM d h:mm a"
        // create the cells
        courtAndDateCell = formTable.dequeueReusableCellWithIdentifier("CourtAndDateCell") as? RHSCLabelTableViewCell
        if (courtAndDateCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            courtAndDateCell = nib[0] as? RHSCLabelTableViewCell
        }
        courtAndDateCell?.configure(String.init(format:"%@ - %@",
            arguments: [ct!.court! , dateTimeFormat.stringFromDate(ct!.courtTime!)]))
        
        eventCell = formTable.dequeueReusableCellWithIdentifier("EventCell") as? RHSCLabelTableViewCell
        if (eventCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            eventCell = nib[1] as? RHSCLabelTableViewCell
        }
        eventCell?.configure(String.init(format:"%@ - %@",
            arguments: [ct!.event! , ct!.eventDesc!]))
        
        player1Cell = formTable.dequeueReusableCellWithIdentifier("Player1Cell") as? RHSCTeamSelectionTableViewCell
        if (player1Cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            player1Cell = nib[2] as? RHSCTeamSelectionTableViewCell
        }
        player1Cell?.configure(1, setText: ct!.players[1]?.buttonText(),isTeam1: true)
        
        player2Cell = formTable.dequeueReusableCellWithIdentifier("Player1Cell") as? RHSCTeamSelectionTableViewCell
        if (player2Cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            player2Cell = nib[3] as? RHSCTeamSelectionTableViewCell
        }
        player2Cell?.configure(2, setText: ct!.players[2]?.buttonText(),isTeam1: false)
        
        if ct!.court == "Court 5" {
            player3Cell = formTable.dequeueReusableCellWithIdentifier("Player3Cell") as? RHSCTeamSelectionTableViewCell
            if (player3Cell == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
                player3Cell = nib[4] as? RHSCTeamSelectionTableViewCell
            }
            player3Cell?.configure(3, setText: ct!.players[3]?.buttonText(),isTeam1: true)
            
            player4Cell = formTable.dequeueReusableCellWithIdentifier("Player4Cell") as? RHSCTeamSelectionTableViewCell
            if (player4Cell == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
                player4Cell = nib[5] as? RHSCTeamSelectionTableViewCell
            }
            player4Cell?.configure(4, setText: ct!.players[4]?.buttonText(),isTeam1: false)
            
        }

        team1ScoresCell = formTable.dequeueReusableCellWithIdentifier("Team1ScoresCell") as? RHSCTeamScoresTableViewCell
        if (team1ScoresCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            team1ScoresCell = nib[6] as? RHSCTeamScoresTableViewCell
        }
        team1ScoresCell?.configure(1, scores: [0,0,0,0,0],gamesWon: 0)
        team1ScoresCell?.game1ScoreField.delegate = self
        team1ScoresCell?.game2ScoreField.delegate = self
        team1ScoresCell?.game3ScoreField.delegate = self
        team1ScoresCell?.game4ScoreField.delegate = self
        team1ScoresCell?.game5ScoreField.delegate = self
        
        team2ScoresCell = formTable.dequeueReusableCellWithIdentifier("Team2ScoresCell") as? RHSCTeamScoresTableViewCell
        if (team2ScoresCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            team2ScoresCell = nib[7] as? RHSCTeamScoresTableViewCell
        }
        team2ScoresCell?.configure(2, scores: [0,0,0,0,0],gamesWon: 0)
        team2ScoresCell?.game1ScoreField.delegate = self
        team2ScoresCell?.game2ScoreField.delegate = self
        team2ScoresCell?.game3ScoreField.delegate = self
        team2ScoresCell?.game4ScoreField.delegate = self
        team2ScoresCell?.game5ScoreField.delegate = self
        
        if ct?.court == "Court 5" {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell, player3Cell, player4Cell],[team1ScoresCell, team2ScoresCell]]
        } else {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell],[team1ScoresCell, team2ScoresCell]]
        }
        
        for sect in cells {
            for myview in sect {
                myview?.selectionStyle = .None
            }
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cells[indexPath.section][indexPath.row]!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        switch section {
        //        case 0: return "Coordinates"
        //        case 1: return "Players"
        //        case 2: return "Event"
        //        default: return ""
        //        }
        return nil
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
        let txtView = view as! UITableViewHeaderFooterView
        txtView.textLabel?.textColor = UIColor.blackColor()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func didClickOnPlayerButton(sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        self.updateGamesWon()
        return true
    }
    
    func updateGamesWon() {
        let t1g1:Int? = Int(team1ScoresCell!.game1ScoreField.text!)
        let t1g2:Int? = Int(team1ScoresCell!.game2ScoreField.text!)
        let t1g3:Int? = Int(team1ScoresCell!.game3ScoreField.text!)
        let t1g4:Int? = Int(team1ScoresCell!.game4ScoreField.text!)
        let t1g5:Int? = Int(team1ScoresCell!.game5ScoreField.text!)
        
        let t2g1:Int? = Int(team2ScoresCell!.game1ScoreField.text!)
        let t2g2:Int? = Int(team2ScoresCell!.game2ScoreField.text!)
        let t2g3:Int? = Int(team2ScoresCell!.game3ScoreField.text!)
        let t2g4:Int? = Int(team2ScoresCell!.game4ScoreField.text!)
        let t2g5:Int? = Int(team2ScoresCell!.game5ScoreField.text!)
        
        var t1gw = 0
        var t2gw = 0
        if ((t1g1 != nil) && (t2g1 != nil)) {
            if t1g1 > t2g1 {
                t1gw++
            }
            if t2g1 > t1g1 {
                t2gw++
            }
        }
        if ((t1g2 != nil) && (t2g2 != nil)) {
            if t1g2 > t2g2 {
                t1gw++
            }
            if t2g2 > t1g2 {
                t2gw++
            }
        }
        if ((t1g3 != nil) && (t2g3 != nil)) {
            if t1g3 > t2g3 {
                t1gw++
            }
            if t2g3 > t1g3 {
                t2gw++
            }
        }
        if ((t1g4 != nil) && (t2g4 != nil)) {
            if t1g4 > t2g4 {
                t1gw++
            }
            if t2g4 > t1g4 {
                t2gw++
            }
        }
        if ((t1g5 != nil) && (t2g5 != nil)) {
            if t1g5 > t2g5 {
                t1gw++
            }
            if t2g5 > t1g5 {
                t2gw++
            }
        }
        team1ScoresCell!.gamesWonField.text = String(t1gw)
        team2ScoresCell!.gamesWonField.text = String(t2gw)
    }

    @IBAction func recordScores() {
        return
        let tbc = tabBarController as! RHSCTabBarController
        let fetchURL = String.init(format: "Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",
            arguments: [ct!.bookingId!, (tbc.currentUser?.name)!,ct!.players[2]!.name!,
                ct!.players[3]!.name!,ct!.players[4]!.name!,
                (tbc.currentUser?.name)!,"iPhone"])
        
        let url = NSURL(string: fetchURL, relativeToURL: tbc.server )
        //        print(url!.absoluteString)
        let sessionCfg = NSURLSession.sharedSession().configuration
        sessionCfg.timeoutIntervalForResource = 30.0
        let session = NSURLSession(configuration: sessionCfg)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                self.errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                    message: "Error: \(error!.localizedDescription)", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            } else {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                if (statusCode == 200) && (data != nil) {
                    let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    if jsonDictionary["error"] == nil {
                        self.successAlert = UIAlertController(title: "Success",
                            message: "Booking successfully cancelled. Notices will be sent to all players", preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(self.successAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    self.successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    } else {
                        self.errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                            message: jsonDictionary["error"] as! String?, preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    self.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    }
                } else {
                    self.errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                        message: "Error (status code \(statusCode))", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                }
            }
        })
        task.resume()
    }
    
}