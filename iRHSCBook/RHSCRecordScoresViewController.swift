//
//  RHSCRecordScoresViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-27.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCRecordScoresViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
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
        eventCell?.configure(String.init(format:"%@: %@",
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

        scoreHeaderCell = formTable.dequeueReusableCellWithIdentifier("TeamTitleCell")
        if (scoreHeaderCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            scoreHeaderCell = nib[9] as? UITableViewCell
        }

        game1ScoreCell = formTable.dequeueReusableCellWithIdentifier("GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game1ScoreCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game1ScoreCell = nib[8] as? RHSCGameScoreTableViewCell
        }
        game1ScoreCell?.configure("Game 1")
        
        game2ScoreCell = formTable.dequeueReusableCellWithIdentifier("GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game2ScoreCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game2ScoreCell = nib[8] as? RHSCGameScoreTableViewCell
        }
        game2ScoreCell?.configure("Game 2")
        
        game3ScoreCell = formTable.dequeueReusableCellWithIdentifier("GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game3ScoreCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game3ScoreCell = nib[8] as? RHSCGameScoreTableViewCell
        }
        game3ScoreCell?.configure("Game 3")
        
        game4ScoreCell = formTable.dequeueReusableCellWithIdentifier("GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game4ScoreCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game4ScoreCell = nib[8] as? RHSCGameScoreTableViewCell
        }
        game4ScoreCell?.configure("Game 4")
        
        game5ScoreCell = formTable.dequeueReusableCellWithIdentifier("GameScoreCell") as? RHSCGameScoreTableViewCell
        if (game5ScoreCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCRecordScoresTableViewCell", owner: self, options: nil)
            game5ScoreCell = nib[8] as? RHSCGameScoreTableViewCell
        }
        game5ScoreCell?.configure("Game 5")
        
        
        if ct?.court == "Court 5" {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell, player3Cell, player4Cell],[scoreHeaderCell],[game1ScoreCell, game2ScoreCell,game3ScoreCell,game4ScoreCell,game5ScoreCell]]
        } else {
            cells = [[courtAndDateCell, eventCell],[player1Cell, player2Cell],[scoreHeaderCell],[game1ScoreCell, game2ScoreCell,game3ScoreCell,game4ScoreCell,game5ScoreCell]]
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0,1:
            return 44.0
        case 2:
            return 39.0
        default:
            return 47.0
        }
    }
    
    func didClickOnPlayerButton(sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
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
    
    @IBAction func teamChanged() {
        let p1ctl = player1Cell?.segField
        let p2ctl = player2Cell?.segField
        let p3ctl = player3Cell?.segField
        let p4ctl = player4Cell?.segField
        if ct?.court == "Court 5" {
        } else {
            
        }
    }
    
}