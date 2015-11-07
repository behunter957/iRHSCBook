//
//  RHSCBookCourtViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-06.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

class RHSCBookCourtViewController : UITableViewController {
    
    var ct : RHSCCourtTime? = nil
    @IBOutlet weak var s1r0 : UITableViewCell? = nil
    @IBOutlet weak var s1r1 : UITableViewCell? = nil
    @IBOutlet weak var s1r2 : UITableViewCell? = nil
    @IBOutlet weak var s2r0 : UITableViewCell? = nil
    @IBOutlet weak var s2r1 : UITableViewCell? = nil
    @IBOutlet weak var s2r2 : UITableViewCell? = nil
    @IBOutlet weak var s2r3 : UITableViewCell? = nil
    @IBOutlet weak var s3r0 : UITableViewCell? = nil
    @IBOutlet weak var s3r1 : UITableViewCell? = nil
    var cells : Array<Array<UITableViewCell?>> = [[],[],[]]
    var delegate : AnyObject? = nil
        
    override func viewDidLoad() {
        
        let titleCell = RHSCCourtTitleTableViewCell()
        titleCell.courtNameLabel = UILabel()
        titleCell.courtNameLabel?.text = ct?.court
        cells[0].append(titleCell)
        let dateCell = RHSCCourtInfoTableViewCell()
        dateCell.infoNameLabel = UILabel()
        dateCell.infoNameLabel?.text = "Date"
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d"
        dateCell.infoValueLabel = UILabel()
        dateCell.infoValueLabel?.text = dateFormat.stringFromDate((ct?.courtTime)!)
        cells[0].append(dateCell)
        let timeCell = RHSCCourtInfoTableViewCell()
        timeCell.infoNameLabel = UILabel()
        timeCell.infoNameLabel?.text = "Time"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        timeCell.infoValueLabel = UILabel()
        timeCell.infoValueLabel?.text = timeFormat.stringFromDate((ct?.courtTime)!)
        cells[0].append(timeCell)
        
        let p1Cell = RHSCCourtInfoTableViewCell()
        p1Cell.infoNameLabel = UILabel()
        p1Cell.infoValueLabel = UILabel()
        p1Cell.infoNameLabel?.text = "Player 1"
        p1Cell.infoValueLabel?.text = ct?.players["player1_id"]
        cells[1].append(p1Cell)
        let p2Cell = RHSCCourtInfoTableViewCell()
        p2Cell.infoNameLabel = UILabel()
        p2Cell.infoValueLabel = UILabel()
        p2Cell.infoNameLabel?.text = "Player 2"
        p2Cell.infoValueLabel?.text = ct?.players["player2_id"]
        cells[1].append(p2Cell)
        if ct?.court == "Court 5" {
            let p3Cell = RHSCCourtInfoTableViewCell()
            p3Cell.infoNameLabel = UILabel()
            p3Cell.infoValueLabel = UILabel()
            p3Cell.infoNameLabel?.text = "Player 3"
            p3Cell.infoValueLabel?.text = ct?.players["player3_id"]
            cells[1].append(p3Cell)
            let p4Cell = RHSCCourtInfoTableViewCell()
            p4Cell.infoNameLabel = UILabel()
            p4Cell.infoValueLabel = UILabel()
            p4Cell.infoNameLabel?.text = "Player 4"
            p4Cell.infoValueLabel?.text = ct?.players["player4_id"]
            cells[1].append(p4Cell)
        }
        
        let eventCell = RHSCCourtInfoTableViewCell()
        eventCell.infoNameLabel = UILabel()
        eventCell.infoValueLabel = UILabel()
        eventCell.infoNameLabel?.text = "Type"
        eventCell.infoValueLabel?.text = ct?.event
        cells[2].append(eventCell)
        let descCell = RHSCCourtInfoTableViewCell()
        descCell.infoNameLabel = UILabel()
        descCell.infoValueLabel = UILabel()
        descCell.infoNameLabel?.text = "Desc"
        descCell.infoValueLabel?.text = ct?.eventDesc
        cells[2].append(descCell)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        switch section {
        case 1: return 3
        case 2: return (ct?.court == "Court 5" ? 4 : 2)
        case 3: return 2
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cells[indexPath.section - 1][indexPath.row]!
    }
}