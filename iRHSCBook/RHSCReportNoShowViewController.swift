//
//  RHSCReportNoShowViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-26.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCReportNoShowViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var courtTitleCell : RHSCLabelTableViewCell? = nil
    var dateCell : RHSCLabelTableViewCell? = nil
    var timeCell : RHSCLabelTableViewCell? = nil
    var player1Cell : RHSCLabelTableViewCell? = nil
    var player2Cell : RHSCLabelTableViewCell? = nil
    var player3Cell : RHSCLabelTableViewCell? = nil
    var player4Cell : RHSCLabelTableViewCell? = nil
    var typeCell : RHSCLabelTableViewCell? = nil
    var descCell : RHSCLabelTableViewCell? = nil
    var notesCell : RHSCTextTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    var delegate : AnyObject? = nil

    override func viewDidLoad() {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        courtTitleCell = formTable.dequeueReusableCellWithIdentifier("NoShow Court") as? RHSCLabelTableViewCell
        if (courtTitleCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            courtTitleCell = nib[0] as? RHSCLabelTableViewCell
        }
        courtTitleCell?.configure(ct!.court)

        dateCell = formTable.dequeueReusableCellWithIdentifier("NoShow Date") as? RHSCLabelTableViewCell
        if (dateCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            dateCell = nib[1] as? RHSCLabelTableViewCell
        }
        dateCell?.configure(ct!.court)
        
        timeCell = formTable.dequeueReusableCellWithIdentifier("NoShow Time") as? RHSCLabelTableViewCell
        if (timeCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            timeCell = nib[2] as? RHSCLabelTableViewCell
        }
        timeCell?.configure(ct!.court)
        
        player1Cell = formTable.dequeueReusableCellWithIdentifier("NoShow Player1") as? RHSCLabelTableViewCell
        if (player1Cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            player1Cell = nib[3] as? RHSCLabelTableViewCell
        }
        player1Cell?.configure(ct!.players[1]!.buttonText())
        
        player2Cell = formTable.dequeueReusableCellWithIdentifier("NoShow Player2") as? RHSCLabelTableViewCell
        if (player2Cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            player2Cell = nib[4] as? RHSCLabelTableViewCell
        }
        player2Cell?.configure(ct!.players[2]!.buttonText())
        
        if ct!.court == "Court 5" {
            player3Cell = formTable.dequeueReusableCellWithIdentifier("NoShow Player3") as? RHSCLabelTableViewCell
            if (player3Cell == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
                player3Cell = nib[5] as? RHSCLabelTableViewCell
            }
            player3Cell?.configure(ct!.players[3]!.buttonText())
            
            player4Cell = formTable.dequeueReusableCellWithIdentifier("NoShow Player4") as? RHSCLabelTableViewCell
            if (player4Cell == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
                player4Cell = nib[6] as? RHSCLabelTableViewCell
            }
            player4Cell?.configure(ct!.players[4]!.buttonText())
            
        }
        
        typeCell = formTable.dequeueReusableCellWithIdentifier("NoShow Type") as? RHSCLabelTableViewCell
        if (typeCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            typeCell = nib[7] as? RHSCLabelTableViewCell
        }
        typeCell?.configure(ct!.event)
        
        descCell = formTable.dequeueReusableCellWithIdentifier("NoShow Desc") as? RHSCLabelTableViewCell
        if (descCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            descCell = nib[8] as? RHSCLabelTableViewCell
        }
        descCell?.configure(ct!.eventDesc)
        
        notesCell = formTable.dequeueReusableCellWithIdentifier("NoShow Notes") as? RHSCTextTableViewCell
        if (notesCell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            notesCell = nib[9] as? RHSCTextTableViewCell
        }
//        notesCell?.configure(" ")
        
        if ct?.court == "Court 5" {
            cells = [[courtTitleCell, dateCell, timeCell],[player1Cell, player2Cell, player3Cell, player4Cell],[typeCell, descCell, notesCell]]
        } else {
            cells = [[courtTitleCell, dateCell, timeCell],[player1Cell, player2Cell],[typeCell, descCell, notesCell]]
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
    
    @IBAction func reportNoShow() {
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
