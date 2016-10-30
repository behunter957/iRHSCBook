//
//  RHSCFindMemberViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
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


protocol setPlayerProtocol {

    func setPlayer(_ player: RHSCMember?, playerNumber: UInt16)

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
        self.filteredList.append(contentsOf: ml!.memberList)
        
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
            filteredList = array as! [RHSCMember]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as UITableViewCell
        
        if (resultSearchController.isActive)
        {
            let mem = self.filteredList[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = mem.sortName
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

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.backgroundColor = UIColor.red
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    NSLog(@"popping FindMember on table select");
        let selectedIndexPath = tableView.indexPathForSelectedRow
        var selmem : RHSCMember? = nil
        if (resultSearchController.isActive) {
            selmem = self.filteredList[(selectedIndexPath! as NSIndexPath).row]
        } else {
            let tbc = self.tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            selmem = ml!.memberList[(selectedIndexPath! as NSIndexPath).row]
        }
        if delegate is RHSCBookCourtViewController {
            let deltarget = (delegate as! RHSCBookCourtViewController)
            deltarget.setPlayer(selmem, number: playerNumber)
        }
        if delegate is RHSCUpdateCourtViewController {
            let deltarget = (delegate as! RHSCUpdateCourtViewController)
            deltarget.setPlayer(selmem, number: playerNumber)
        }
        resultSearchController.isActive = false
        self.navigationController?.popViewController(animated: false)
    }

}
