//
//  RHSCFindMemberViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

protocol setPlayerProtocol {

    func setPlayer(player: RHSCMember?, playerNumber: UInt16)

}

class RHSCFindMemberViewController : UITableViewController,UISearchDisplayDelegate,UISearchBarDelegate {

    var playerNumber : UInt16 = 0
    var delegate : AnyObject? = nil
    
    var filteredList : Array<RHSCMember> = []
    @IBOutlet weak var searchResultsView : UITableView? = nil
    @IBOutlet weak var memberListView : UITableView? = nil
    
    var searching : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        self.filteredList = []
        self.filteredList.appendContentsOf(ml!.memberList)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if (self.searchDisplayController!.searchResultsTableView == tableView) {
            return self.filteredList.count
        } else {
            // get memberList count
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            return ml!.memberList.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath)
        if (self.searchDisplayController!.searchResultsTableView == tableView) {
            let member = self.filteredList[indexPath.row]
            cell.textLabel!.text = String.init(format: "%@, %@", arguments: [member.lastName!,member.firstName!])
            return cell;
        } else {
            // Configure the cell...
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            let member = ml!.memberList[indexPath.row];
            cell.textLabel!.text = String.init(format: "%@, %@", arguments: [member.lastName!,member.firstName!])
            return cell;
        }
    }
    
    func searchTableView() {
        let searchText = self.searchDisplayController!.searchBar.text
    
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        for item in ml!.memberList {
            let srchtext = String.init(format: "%@, %@", arguments: [item.lastName!,item.firstName!])
            
            if srchtext.lowercaseString.rangeOfString((searchText?.lowercaseString)!) != nil {
                self.filteredList.append(item)
            }
        }
    }
    
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {
        searching = false
    }
    
    func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController) {
        searching = false
        self.tableView.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .Automatic)
        self.filteredList.removeAll()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        self.filteredList.removeAll()
        if searchString?.characters.count > 1 {
            searching = true
            self.searchTableView()
        } else {
            searching = false
        }
        return true
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSLog(@"popping FindMember on table select");
        let selectedIndexPath = tableView.indexPathForSelectedRow
        var selmem : RHSCMember? = nil
        if (searching) {
            selmem = self.filteredList[selectedIndexPath!.row]
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            selmem = ml!.memberList[selectedIndexPath!.row]
        }
        if delegate is RHSCReserveSinglesViewController {
            let deltarget = (delegate as! RHSCReserveSinglesViewController)
            deltarget.setPlayer(selmem, number: 2)
        } else {
            let deltarget = (delegate as! RHSCReserveDoublesViewController)
            deltarget.setPlayer(selmem, number:self.playerNumber)
        }
        self.navigationController?.popViewControllerAnimated(false)
    }

}
