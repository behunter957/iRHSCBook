//
//  RHSCMembersViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

class RHSCMembersViewController : UITableViewController,UISearchResultsUpdating,UISearchBarDelegate {

    var filteredList : Array<RHSCMember> = []
    @IBOutlet var searchResultsView : UITableView? = nil
    var selectedMember : RHSCMember? = nil
    var searching : Bool = false
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController : UISearchController) {
        let searchString = searchController.searchBar.text
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        self.filteredList.removeAll()
        for item in ml!.memberList {
            let srchtext = String.init(format: "%@, %@", arguments: [item.lastName!,item.firstName!])
            
            if srchtext.lowercaseString.rangeOfString((searchString?.lowercaseString)!) != nil {
                self.filteredList.append(item)
            }
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.resultSearchController.active)
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
        
        if (self.resultSearchController.active)
        {
            let mem = self.filteredList[indexPath.row]
            cell.textLabel!.text = String.init(format: "%@, %@", arguments: [mem.lastName!,mem.firstName!])
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            let mem = tbc.memberList!.memberList[indexPath.row]
            cell.textLabel?.text = String.init(format: "%@, %@", arguments: [mem.lastName!,mem.firstName!])
        }
        cell.textLabel!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.textColor = UIColor.blackColor()
        cell.accessoryType = .None
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let segueName = "MemberDetail"
        if (self.resultSearchController.active) {
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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if (segue.identifier == "MemberDetail") {
            let mdvc = segue.destinationViewController as! RHSCMemberDetailViewController
            mdvc.member = selectedMember
        }
    }
    
}