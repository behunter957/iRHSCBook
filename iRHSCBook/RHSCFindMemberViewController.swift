//
//  RHSCFindMemberViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol setPlayerProtocol {

    func setPlayer(player: RHSCMember?, playerNumber: UInt16)

}

class RHSCFindMemberViewController : UITableViewController,UISearchResultsUpdating {

    var playerNumber : UInt16 = 0
    var delegate : AnyObject? = nil
    
    var filteredList : Array<RHSCMember> = []
    var resultSearchController : UISearchController!
    
    @IBOutlet weak var searchResultsView : UITableView? = nil
    @IBOutlet weak var memberListView : UITableView? = nil
    
    var searching : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.accessibilityIdentifier = "FindMember"
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        //self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        
        self.filteredList = []
        self.filteredList.appendContentsOf(ml!.memberList)
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController.searchResultsUpdater = self
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = false
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
            filteredList.removeAll(keepCapacity: false)
            let searchPredicate = NSPredicate(format: "self.fullName contains[c] %@", searchController.searchBar.text!)
            let tbc = self.tabBarController as! RHSCTabBarController
            let array = (tbc.memberList!.memberList as NSArray).filteredArrayUsingPredicate(searchPredicate)
            filteredList = array as! [RHSCMember]
            tableView.reloadData()
        }
        else {
            filteredList.removeAll(keepCapacity: false)
            let tbc = self.tabBarController as! RHSCTabBarController
            filteredList = tbc.memberList!.memberList
            tableView.reloadData()
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (resultSearchController.active)
        {
            return self.filteredList.count
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            return tbc.memberList!.memberList.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath) as UITableViewCell
        
        if (resultSearchController.active)
        {
            let mem = self.filteredList[indexPath.row]
            cell.textLabel?.text = mem.sortName
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            let mem = tbc.memberList!.memberList[indexPath.row]
            cell.textLabel?.text = mem.sortName
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.accessoryType = .None
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.redColor()
    }
    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSLog(@"popping FindMember on table select");
        let selectedIndexPath = tableView.indexPathForSelectedRow
        var selmem : RHSCMember? = nil
        if (resultSearchController.active) {
            selmem = self.filteredList[selectedIndexPath!.row]
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            selmem = ml!.memberList[selectedIndexPath!.row]
        }
        if delegate is RHSCBookCourtViewController {
            let deltarget = (delegate as! RHSCBookCourtViewController)
            deltarget.setPlayer(selmem, number: playerNumber)
        }
        if delegate is RHSCUpdateCourtViewController {
            let deltarget = (delegate as! RHSCUpdateCourtViewController)
            deltarget.setPlayer(selmem, number: playerNumber)
        }
        resultSearchController.active = false
        self.navigationController?.popViewControllerAnimated(false)
    }

}
