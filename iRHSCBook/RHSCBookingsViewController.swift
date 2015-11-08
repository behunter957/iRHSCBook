//
//  RHSCBookingsViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-29.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCBookingsViewController : UITableViewController,cancelBookingProtocol,NSFileManagerDelegate {

    var bookingList = RHSCMyBookingsList()
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
        self.bookingList = RHSCMyBookingsList()
        // now get the booking list for the current user
        self.asyncLoadBookings()
    
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
        return self.bookingList.bookingList.count;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.bookedBlue()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBookingCell", forIndexPath: indexPath)
        // Configure the cell...
        let ct = self.bookingList.bookingList[indexPath.row];
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        cell.textLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,
            dtFormatter.stringFromDate(ct.courtTime!)])
        if ct.court == "Court 5" {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@,%@,%@", arguments: ["Doubles",
                ct.players["player1_lname"]!,ct.players["player2_lname"]!,
                ct.players["player3_lname"]!,ct.players["player4_lname"]!])
        } else {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@", arguments: [ct.event!,
                ct.players["player1_lname"]!,ct.players["player2_lname"]!])
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.detailTextLabel!.textColor = UIColor.whiteColor()
        cell.accessoryType = .None
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = self.bookingList.bookingList[indexPath.row]
        let segueName = "BookingDetail"
        self.performSegueWithIdentifier(segueName, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "BookingDetail" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCBookingDetailViewController).delegate = self
            (segue.destinationViewController as! RHSCBookingDetailViewController).booking = self.selectedBooking
        }
    }
    
    @IBAction func syncBookings(sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.refreshTable()
    }
    
    func asyncLoadBookings() {
        let tbc = tabBarController as! RHSCTabBarController
        let url = NSURL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",
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
                self.bookingList.loadFromData(data!, forUser: tbc.currentUser!.name!)
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
