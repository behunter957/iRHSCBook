//
//  RHSCHistoryViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCHistoryViewController : UITableViewController, NSFileManagerDelegate {
    
    var history = RHSCHistoryList()
    var selectedBooking : RHSCCourtTime? = nil
    @IBOutlet weak var onlyMine : UISwitch? = nil

    var includeAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityIdentifier = "CourtHistory"
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        
        //    [self refreshTable];
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refreshTable", forControlEvents: .ValueChanged)
    }
    
    override func viewDidAppear(animated: Bool) {
        //    NSLog(@"MyBooking viewDidAppear");
        self.refreshTable()
    }
    
    @IBAction func onlyMineChanged(sender: AnyObject) {
        let incText = (self.onlyMine!.on ? "Showing only My History" : "Showing all History")
        self.errorAlert = UIAlertController(title: "",
            message: incText, preferredStyle: .Alert)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        })
        // print(self.onlyMine!.on)
        self.history.loadAsync(fromView: self, forMe: self.onlyMine!.on)
    }
    
    func refreshTable() {
        history = RHSCHistoryList()
        // now get the booking list for the current user
        self.history.loadAsync(fromView: self, forMe: self.onlyMine!.on)
        
        //    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        //    [self.bookingList loadFromJSON:tbc.server user:tbc.currentUser];
        //    [self.tableView reloadData];
        self.refreshControl?.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return history.list.count;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//       print("willDisplayCell:",indexPath.row)
        if indexPath.row < history.list.count {
            let curCourtTime = history.list[indexPath.row]
            cell.contentView.backgroundColor = UIColor.historyBrown()
            if curCourtTime.isNoShow {
                cell.contentView.backgroundColor = UIColor.noshowRed()
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let tbc = tabBarController as! RHSCTabBarController
        let uid = tbc.currentUser?.name
        var ct : RHSCCourtTime

        let rhscHistoryTableIdentifier = "RHSCHistoryTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(rhscHistoryTableIdentifier)
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(rhscHistoryTableIdentifier, owner: self, options: nil)
            cell = nib[0] as! RHSCHistoryTableViewCell
        }
        // Configure the cell...
        if indexPath.row < history.list.count {
            ct = history.list[indexPath.row]
            let dtFormatter = NSDateFormatter()
            dtFormatter.locale = NSLocale.systemLocale()
            dtFormatter.dateFormat = "EEE, MM d 'at' h:mm a"
        
            let rcell = (cell as! RHSCHistoryTableViewCell)
            rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.stringFromDate(ct.courtTime!)])
            rcell.noShowIndLabel!.text = ct.isNoShow ? "No Show" : "";
            rcell.typeAndPlayersLabel!.text = ct.summary!
            if ((uid == ct.players[1]?.name) || (uid == ct.players[2]?.name) || (uid == ct.players[3]?.name) || (uid == ct.players[4]?.name)) {
                rcell.typeAndPlayersLabel!.textColor = UIColor.redColor()
            }
            rcell.accessoryType = .None
            rcell.accessibilityIdentifier = rcell.courtAndTimeLabel?.text
            return rcell;
        } else {
            return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = history.list[indexPath.row]
        let tbc = tabBarController as! RHSCTabBarController
        let uid = tbc.currentUser?.name
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        let reportNoShowAction = UIAlertAction(title: "Report No-Show", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.performSegueWithIdentifier("ReportNoShow", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                //                print("TBD")
        })
        if ((uid == selectedBooking!.players[1]?.name) || (uid == selectedBooking!.players[2]?.name) || (uid == selectedBooking!.players[3]?.name) || (uid == selectedBooking!.players[4]?.name)) {
            let recordScoresAction = UIAlertAction(title: "Record Scores", style: .Default, handler:
                {
                    (alert: UIAlertAction!) -> Void in
                    self.performSegueWithIdentifier("RecordScores", sender: self)
            })
            optionMenu.addAction(recordScoresAction)
        }
        optionMenu.addAction(reportNoShowAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "RecordScores" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCRecordScoresViewController).delegate = self
            (segue.destinationViewController as! RHSCRecordScoresViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCRecordScoresViewController).user = tbc.currentUser
            (segue.destinationViewController as! RHSCRecordScoresViewController).score = RHSCScore.getScores(forCourtTime: self.selectedBooking!, fromView: self)
        }
        if segue.identifier == "ReportNoShow" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCReportNoShowViewController).delegate = self
            (segue.destinationViewController as! RHSCReportNoShowViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCReportNoShowViewController).user = tbc.currentUser
        }
    }
    
    @IBAction func syncHistory(sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.refreshTable()
    }
    
    
}
