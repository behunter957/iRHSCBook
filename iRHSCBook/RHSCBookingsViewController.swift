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

    var bookingList : RHSCMyBookingsList? = nil
    var selectedBooking : RHSCCourtTime? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
        //    [self refreshTable];
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: "refreshTable", forControlEvents: .ValueChanged)
        self.refreshControl = refresh
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
        return self.bookingList!.bookingList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBookingCell", forIndexPath: indexPath)
        // Configure the cell...
        let ct = self.bookingList!.bookingList[indexPath.row];
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "EEE, MMMM d - h:mm a"
    
        cell.textLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court,
            dtFormatter.stringFromDate(ct.courtTime)])
        if ct.court == "Court 5" {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@,%@,%@", arguments: ["Doubles",
                ct.players["player1_lname"]!,ct.players["player2_lname"]!,
                ct.players["player3_lname"]!,ct.players["player4_lname"]!])
        } else {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@", arguments: [ct.event,
                ct.players["player1_lname"]!,ct.players["player2_lname"]!])
        }
        return cell;
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = self.bookingList?.bookingList[indexPath.row]
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
        let fetchURL = String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@", arguments: [(tbc.currentUser?.data?.name)!])
        //    NSLog(@"fetch URL = %@",fetchURL);
    
        let target = NSURL.init(fileURLWithPath: fetchURL, relativeToURL: tbc.server)
        // Get the data
        let task = NSURLSession.sharedSession().dataTaskWithURL(target) {(data, response, error) in
            // handle response
            // Now create a NSDictionary from the JSON data
            if (error == nil) {
                try! self.bookingList?.loadFromData(data!, forUser: tbc.currentUser!.data!.name!)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        task.resume()
    }


}
