//
//  RHSCBookingsViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-29.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCBookingsViewController : UITableViewController,cancelCourtProtocol,NSFileManagerDelegate {

    var booking = RHSCMyBookingsList()
    var selectedBooking : RHSCCourtTime? = nil

    var includeAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.accessibilityIdentifier = "MyBookings"
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
        self.booking = RHSCMyBookingsList()
        // now get the booking list for the current user
        self.booking.loadAsync(fromView: self)
    
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
        return self.booking.list.count;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let curCourtTime = self.booking.list[indexPath.row]
        switch curCourtTime.status! {
        case "Booked","Reserved":
            switch curCourtTime.event! {
            case "Lesson","Clinic","School":
                cell.contentView.backgroundColor = UIColor.lessonYellow()
            case "T&D","MNHL","Ladder","RoundRobin","Tournament":
                cell.contentView.backgroundColor = UIColor.leaguePurple()
            default:
                cell.contentView.backgroundColor = UIColor.bookedBlue()
            }
            break
        default:
            cell.contentView.backgroundColor = UIColor.availableGreen()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyBookingCell", forIndexPath: indexPath)
        // Configure the cell...
        let ct = self.booking.list[indexPath.row]
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        cell.textLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,
            dtFormatter.stringFromDate(ct.courtTime!)])
        if ct.court == "Court 5" {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@,%@,%@", arguments: [ct.event!,
                ct.players[1]!.lastName!,ct.players[2]!.lastName!,
                ct.players[3]!.lastName!,ct.players[4]!.lastName!])
        } else {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@", arguments: [ct.event!,
                ct.players[1]!.lastName!,ct.players[2]!.lastName!])
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.detailTextLabel!.backgroundColor = UIColor.clearColor()
        switch ct.event! {
        case "Lesson","Clinic","School":
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.textColor = UIColor.blackColor()
        case "T&D","MNHL","Ladder","RoundRobin","Tournament":
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.detailTextLabel!.textColor = UIColor.whiteColor()
        default:
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.detailTextLabel!.textColor = UIColor.whiteColor()
        }
        cell.accessoryType = .None
        cell.accessibilityIdentifier = cell.textLabel?.text
        return cell;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = self.booking.list[indexPath.row]
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
        let updateAction = UIAlertAction(title: "Update", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                if self.selectedBooking!.lock(fromView: self) {
                    let segueName = "UpdateBooking"
                    self.performSegueWithIdentifier(segueName, sender: self)
                } else {
                    self.errorAlert = UIAlertController(title: "Error",
                        message: "Unable to lock the court", preferredStyle: .Alert)
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
        })
        let unbookAction = UIAlertAction(title: "Unbook", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                if self.selectedBooking!.lock(fromView: self) {
                    let segueName = "CancelBooking"
                    self.performSegueWithIdentifier(segueName, sender: self)
                } else {
                    self.errorAlert = UIAlertController(title: "Error",
                        message: "Unable to lock the court", preferredStyle: .Alert)
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                    tableView.deselectRowAtIndexPath(indexPath, animated: false)
                //                print("TBD")
        })
        optionMenu.addAction(updateAction)
        optionMenu.addAction(unbookAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "UpdateBooking" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCUpdateCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCUpdateCourtViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCUpdateCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "CancelBooking" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCCancelCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCCancelCourtViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCCancelCourtViewController).user = tbc.currentUser
        }
    }
    
    @IBAction func syncBookings(sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.refreshTable()
    }
    
}
