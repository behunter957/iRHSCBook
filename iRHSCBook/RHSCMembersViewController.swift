//
//  RHSCMembersViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCMembersViewController : UITableViewController, UISearchResultsUpdating {

    var filteredList : [RHSCMember] = []
    @IBOutlet var searchResultsView : UITableView? = nil
    var selectedMember : RHSCMember? = nil
    var searching : Bool = false
    var resultSearchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.accessibilityIdentifier = "Members"
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
            // 4
            filteredList = array as! [RHSCMember]
            // 5
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
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.redColor()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberListCell", forIndexPath: indexPath)
        
        if (resultSearchController.active)
        {
            let mem = self.filteredList[indexPath.row]
            cell.textLabel!.text = mem.sortName
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
        cell.accessibilityIdentifier = cell.textLabel?.text
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let segueName = "ContactMember"
        if (self.resultSearchController!.active) {
            selectedMember = filteredList[row];
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            selectedMember = ml!.memberList[row]
        }
        self.performSegueWithIdentifier(segueName, sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ContactMember") {
            let mdvc = segue.destinationViewController as! RHSCContactMemberViewController
            mdvc.member = selectedMember
        }
    }
    
}