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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func refreshTable() {
        history = RHSCHistoryList()
        // now get the booking list for the current user
        self.asyncLoadHistory()
        
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
    
    func asyncLoadHistory() {
        let tbc = tabBarController as! RHSCTabBarController
        let url = NSURL(string: String.init(format: "Reserve20/IOSHistoryJSON.php?uid=%@",
            (tbc.currentUser?.name)!),
            relativeToURL: tbc.server )
        //        print(url!.absoluteString)
        //        let sessionCfg = NSURLSession.sharedSession().configuration
        //        sessionCfg.timeoutIntervalForResource = 30.0
        //        let session = NSURLSession(configuration: sessionCfg)
        let session  = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.history.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!)
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    // update some UI
                    //                    print("reloading tableview")
                    self.tableView.reloadData()
                });
            });
        })
        task.resume()
    }
    
    
}
