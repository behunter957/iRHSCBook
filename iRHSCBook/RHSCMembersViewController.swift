//
//  RHSCMembersViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        resultSearchController.searchBar.searchBarStyle = UISearchBarStyle.prominent
        resultSearchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.characters.count > 0 {
            filteredList.removeAll(keepingCapacity: false)
            let searchPredicate = NSPredicate(format: "self.fullName contains[c] %@", searchController.searchBar.text!)
            let tbc = self.tabBarController as! RHSCTabBarController
            let array = (tbc.memberList!.memberList as NSArray).filtered(using: searchPredicate)
            // 4
            filteredList = array as! [RHSCMember]
            // 5
            tableView.reloadData()
        }
        else {
            filteredList.removeAll(keepingCapacity: false)
            let tbc = self.tabBarController as! RHSCTabBarController
            filteredList = tbc.memberList!.memberList
            tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (resultSearchController.isActive)
        {
            return self.filteredList.count
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            return tbc.memberList!.memberList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.red
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberListCell", for: indexPath)
        
        if (resultSearchController.isActive)
        {
            let mem = self.filteredList[(indexPath as NSIndexPath).row]
            cell.textLabel!.text = mem.sortName
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            let mem = tbc.memberList!.memberList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = mem.sortName
        }
        cell.textLabel!.backgroundColor = UIColor.clear
        cell.textLabel!.textColor = UIColor.black
        cell.accessoryType = .none
        cell.accessibilityIdentifier = cell.textLabel?.text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = (indexPath as NSIndexPath).row
        let segueName = "ContactMember"
        if (self.resultSearchController!.isActive) {
            selectedMember = filteredList[row];
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            selectedMember = ml!.memberList[row]
        }
        self.performSegue(withIdentifier: segueName, sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ContactMember") {
            let mdvc = segue.destination as! RHSCContactMemberViewController
            mdvc.member = selectedMember
        }
    }
    
}
