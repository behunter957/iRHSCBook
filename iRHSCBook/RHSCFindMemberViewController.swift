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

class RHSCFindMemberViewController : UITableViewController,UISearchResultsUpdating,UISearchBarDelegate {

    var playerNumber : UInt16 = 0
    var delegate : AnyObject? = nil
    
    var filteredList : Array<RHSCMember> = []
    var resultSearchController : UISearchController? = nil
    
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
        
        self.resultSearchController = UISearchController.init(searchResultsController: nil)
        self.resultSearchController!.searchResultsUpdater = self
        self.resultSearchController!.dimsBackgroundDuringPresentation = false
        self.resultSearchController!.searchBar.scopeButtonTitles = []
        self.resultSearchController!.searchBar.delegate = self
        self.tableView.tableHeaderView = self.resultSearchController!.searchBar
        self.definesPresentationContext = true
        self.resultSearchController!.searchBar.sizeToFit()
        
    }
    
    func updateSearchResultsForSearchController(searchController : UISearchController) {
        let searchString = searchController.searchBar.text
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        self.filteredList.removeAll()
        for item in ml!.memberList {
            let srchtext = item.sortName
            
            if srchtext!.lowercaseString.rangeOfString((searchString?.lowercaseString)!) != nil {
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
        if (self.resultSearchController!.active)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MemberCell", forIndexPath: indexPath) as UITableViewCell?
        
        if (self.resultSearchController!.active)
        {
            let mem = self.filteredList[indexPath.row]
            cell!.textLabel?.text = mem.sortName
            return cell!
        }
        else
        {
            let tbc = self.tabBarController as! RHSCTabBarController
            let mem = tbc.memberList!.memberList[indexPath.row]
            cell!.textLabel?.text = mem.sortName
            return cell!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSLog(@"popping FindMember on table select");
        let selectedIndexPath = tableView.indexPathForSelectedRow
        var selmem : RHSCMember? = nil
        if (self.resultSearchController!.active) {
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
