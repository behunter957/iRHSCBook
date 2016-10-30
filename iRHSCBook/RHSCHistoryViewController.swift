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
class RHSCHistoryViewController : UITableViewController, FileManagerDelegate {
    
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
        self.refreshControl?.addTarget(self, action: #selector(RHSCHistoryViewController.refreshTable), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //    NSLog(@"MyBooking viewDidAppear");
        self.refreshTable()
    }
    
    @IBAction func onlyMineChanged(_ sender: AnyObject) {
        let incText = (self.onlyMine!.isOn ? "Showing only My History" : "Showing all History")
        self.errorAlert = UIAlertController(title: "",
            message: incText, preferredStyle: .alert)
        DispatchQueue.global().async(execute: {
            // do some task
            DispatchQueue.main.async(execute: {
                self.present(self.errorAlert!, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.errorAlert!.dismiss(animated: true, completion: nil)
                })
            })
        })
        // print(self.onlyMine!.on)
        self.history.loadAsync(fromView: self, forMe: self.onlyMine!.isOn)
    }
    
    func refreshTable() {
        history = RHSCHistoryList()
        // now get the booking list for the current user
        self.history.loadAsync(fromView: self, forMe: self.onlyMine!.isOn)
        
        //    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        //    [self.bookingList loadFromJSON:tbc.server user:tbc.currentUser];
        //    [self.tableView reloadData];
        self.refreshControl?.endRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return history.list.count;
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//       print("willDisplayCell:",indexPath.row)
        if (indexPath as NSIndexPath).row < history.list.count {
            let curCourtTime = history.list[(indexPath as NSIndexPath).row]
            cell.contentView.backgroundColor = UIColor.historyBrown()
            if curCourtTime.isNoShow {
                cell.contentView.backgroundColor = UIColor.noshowRed()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tbc = tabBarController as! RHSCTabBarController
        let uid = tbc.currentUser?.name
        var ct : RHSCCourtTime

        let rhscHistoryTableIdentifier = "RHSCHistoryTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: rhscHistoryTableIdentifier)
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(rhscHistoryTableIdentifier, owner: self, options: nil)
            cell = nib?[0] as! RHSCHistoryTableViewCell
        }
        // Configure the cell...
        if (indexPath as NSIndexPath).row < history.list.count {
            ct = history.list[(indexPath as NSIndexPath).row]
            let dtFormatter = DateFormatter()
            dtFormatter.locale = Locale.current
            dtFormatter.dateFormat = "EEE, MM d 'at' h:mm a"
        
            let rcell = (cell as! RHSCHistoryTableViewCell)
            rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.string(from: ct.courtTime! as Date)])
            rcell.noShowIndLabel!.text = ct.isNoShow ? "No Show" : "";
            rcell.typeAndPlayersLabel!.text = ct.summary!
            if ((uid == ct.players[1]?.name) || (uid == ct.players[2]?.name) || (uid == ct.players[3]?.name) || (uid == ct.players[4]?.name)) {
                rcell.typeAndPlayersLabel!.textColor = UIColor.red
            }
            rcell.accessoryType = .none
            rcell.accessibilityIdentifier = rcell.courtAndTimeLabel?.text
            return rcell;
        } else {
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedBooking = history.list[(indexPath as NSIndexPath).row]
        let tbc = tabBarController as! RHSCTabBarController
        let uid = tbc.currentUser?.name
        let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
        let reportNoShowAction = UIAlertAction(title: "Report No-Show", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "ReportNoShow", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                tableView.deselectRow(at: indexPath, animated: false)
                //                print("TBD")
        })
        if ((uid == selectedBooking!.players[1]?.name) || (uid == selectedBooking!.players[2]?.name) || (uid == selectedBooking!.players[3]?.name) || (uid == selectedBooking!.players[4]?.name)) {
            let recordScoresAction = UIAlertAction(title: "Record Scores", style: .default, handler:
                {
                    (alert: UIAlertAction!) -> Void in
                    self.performSegue(withIdentifier: "RecordScores", sender: self)
            })
            optionMenu.addAction(recordScoresAction)
        }
        optionMenu.addAction(reportNoShowAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "RecordScores" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destination as! RHSCRecordScoresViewController).delegate = self
            (segue.destination as! RHSCRecordScoresViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCRecordScoresViewController).user = tbc.currentUser
            (segue.destination as! RHSCRecordScoresViewController).score = RHSCScore.getScores(forCourtTime: self.selectedBooking!, fromView: self)
        }
        if segue.identifier == "ReportNoShow" {
            // set the selectionSet and selectionDate properties
            (segue.destination as! RHSCReportNoShowViewController).delegate = self
            (segue.destination as! RHSCReportNoShowViewController).ct = self.selectedBooking
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCReportNoShowViewController).user = tbc.currentUser
        }
    }
    
    @IBAction func syncHistory(_ sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.refreshTable()
    }
    
    
}
