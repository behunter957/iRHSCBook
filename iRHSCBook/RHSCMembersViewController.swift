//
//  RHSCMembersViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

class RHSCMembersViewController : UITableViewController,UISearchDisplayDelegate,UISearchBarDelegate {

    var filteredList : Array<RHSCMember> = []
    @IBOutlet var searchResultsView : UITableView? = nil
    var selectedMember : RHSCMember? = nil
    var searching : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList;
        filteredList = ml!.copy() as! Array<RHSCMember>
        //    NSLog(@"viewDidLoad for members view");
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        var member : RHSCMember? = nil
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MemberListCell", forIndexPath: indexPath)
        if (self.searchDisplayController!.searchResultsTableView == tableView) {
            member = self.filteredList[indexPath.row]
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            member = ml!.memberList[indexPath.row]
        }
        cell.textLabel!.text = String.init(format: "%@, %@", arguments: [member!.lastName!,member!.firstName!])
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let segueName = "MemberDetail"
        if (searching) {
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
    
    func searchTableView() {
        let searchText = self.searchDisplayController!.searchBar.text
    
        let tbc = tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        for item in ml!.memberList {
            let srchtext = String.init(format:"%@ %@", arguments: [item.lastName!,item.firstName!])
            if (srchtext.lowercaseString.rangeOfString(searchText!) != nil) {
                filteredList.append(item)
            }
        }
    }
    
    func searchDisplayControllerWillBeginSearch(controller: UISearchDisplayController) {
        searching = false
    }
    
    func searchDisplayControllerWillEndSearch(controller: UISearchDisplayController) {
        searching = false
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        filteredList.removeAll()
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        filteredList.removeAll()
        
        if (searchString?.characters.count > 1) {
            searching = true
            searchTableView()
        } else {
            searching = false
        }
        return true
    }
    

}