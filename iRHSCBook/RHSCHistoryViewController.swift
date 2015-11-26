//
//  RHSCHistoryViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCHistoryViewController : UITableViewController, NSFileManagerDelegate {
    
    var historyList = RHSCHistoryList()
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
        self.refreshControl?.endRefreshing()
        self.historyList = RHSCHistoryList()
        // now get the booking list for the current user
        self.asyncLoadHistory()
        
        //    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        //    [self.bookingList loadFromJSON:tbc.server user:tbc.currentUser];
        //    [self.tableView reloadData];
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.historyList.historyList.count;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let curCourtTime = self.historyList.historyList[indexPath.row]
        cell.contentView.backgroundColor = UIColor.historyBrown()
        if curCourtTime.isNoShow {
            cell.contentView.backgroundColor = UIColor.noshowRed()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rhscHistoryTableIdentifier = "RHSCHistoryTableViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(rhscHistoryTableIdentifier)
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(rhscHistoryTableIdentifier, owner: self, options: nil)
            cell = nib[0] as! RHSCHistoryTableViewCell
        }
        // Configure the cell...
        let ct = self.historyList.historyList[indexPath.row]
        let dtFormatter = NSDateFormatter()
        dtFormatter.locale = NSLocale.systemLocale()
        dtFormatter.dateFormat = "EEE, MM d 'at' h:mm a"
        
        let rcell = (cell as! RHSCHistoryTableViewCell)
        rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.stringFromDate(ct.courtTime!)])
        rcell.noShowIndLabel!.text = ct.isNoShow ? "No Show" : "";
        rcell.typeAndPlayersLabel!.text = ct.summary!
        rcell.typeAndPlayersLabel!.textColor = UIColor.blackColor()
        rcell.courtAndTimeLabel!.textColor = UIColor.blackColor()
        rcell.noShowIndLabel!.textColor = UIColor.blackColor()

        rcell.accessoryType = .None
        return rcell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = self.historyList.historyList[indexPath.row]
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
                //                print("TBD")
        })
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
            (segue.destinationViewController as! RHSCUpdateCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCUpdateCourtViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCUpdateCourtViewController).user = tbc.currentUser
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
                self.historyList.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!)
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
