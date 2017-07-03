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
class RHSCBookingsViewController : UITableViewController,cancelCourtProtocol,FileManagerDelegate {

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
        self.refreshControl?.addTarget(self, action: #selector(RHSCBookingsViewController.refreshTable), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.booking.list.count;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let curCourtTime = self.booking.list[(indexPath as NSIndexPath).row]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell", for: indexPath)
        // Configure the cell...
        let ct = self.booking.list[(indexPath as NSIndexPath).row]
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        cell.textLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,
            dtFormatter.string(from: ct.courtTime! as Date)])
        if ct.court == "Court 5" {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@,%@,%@", arguments: [ct.event!,
                ct.players[1]!.lastName!,ct.players[2]!.lastName!,
                ct.players[3]!.lastName!,ct.players[4]!.lastName!])
        } else {
            cell.detailTextLabel!.text = String.init(format: "%@ - %@,%@", arguments: [ct.event!,
                ct.players[1]!.lastName!,ct.players[2]!.lastName!])
        }
        cell.textLabel!.backgroundColor = UIColor.clear
        cell.detailTextLabel!.backgroundColor = UIColor.clear
        switch ct.event! {
        case "Lesson","Clinic","School":
            cell.textLabel!.textColor = UIColor.black
            cell.detailTextLabel!.textColor = UIColor.black
        case "T&D","MNHL","Ladder","RoundRobin","Tournament":
            cell.textLabel!.textColor = UIColor.white
            cell.detailTextLabel!.textColor = UIColor.white
        default:
            cell.textLabel!.textColor = UIColor.white
            cell.detailTextLabel!.textColor = UIColor.white
        }
        cell.accessoryType = .none
        cell.accessibilityIdentifier = cell.textLabel?.text
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = self.booking.list[(indexPath as NSIndexPath).row]
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let updateAction = UIAlertAction(title: "Update", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                if self.selectedBooking!.lock(fromView: self) {
                    let segueName = "UpdateBooking"
                    self.performSegue(withIdentifier: segueName, sender: self)
                } else {
                    self.errorAlert = UIAlertController(title: "Error",
                        message: "Unable to lock the court", preferredStyle: .alert)
                    DispatchQueue.global().async(execute: {
                        DispatchQueue.main.async(execute: {
                            self.present(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                self.errorAlert!.dismiss(animated: true, completion: nil)
                            })
                        })
                    })
                }
        })
        let unbookAction = UIAlertAction(title: "Unbook", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                if self.selectedBooking!.lock(fromView: self) {
                    let segueName = "CancelBooking"
                    self.performSegue(withIdentifier: segueName, sender: self)
                } else {
                    self.errorAlert = UIAlertController(title: "Error",
                        message: "Unable to lock the court", preferredStyle: .alert)
                    DispatchQueue.global().async(execute: {
                        DispatchQueue.main.async(execute: {
                            self.present(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                self.errorAlert!.dismiss(animated: true, completion: nil)
                            })
                        })
                    })
                }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                    tableView.deselectRow(at: indexPath, animated: false)
                //                print("TBD")
        })
        optionMenu.addAction(updateAction)
        optionMenu.addAction(unbookAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "UpdateBooking" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destination as! RHSCUpdateCourtViewController).delegate = self
            (segue.destination as! RHSCUpdateCourtViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCUpdateCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "CancelBooking" {
            // set the selectionSet and selectionDate properties
            (segue.destination as! RHSCCancelCourtViewController).delegate = self
            (segue.destination as! RHSCCancelCourtViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCCancelCourtViewController).user = tbc.currentUser
        }
    }
    
    @IBAction func syncBookings(_ sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.refreshTable()
    }
    
}
