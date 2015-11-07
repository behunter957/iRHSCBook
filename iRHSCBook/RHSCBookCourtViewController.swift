//
//  RHSCBookCourtViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-06.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

class RHSCBookCourtViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var s1r0 : RHSCLabelTableViewCell? = nil
    var s1r1 : RHSCLabelTableViewCell? = nil
    var s1r2 : RHSCLabelTableViewCell? = nil
    var s2r0 : RHSCButtonTableViewCell? = nil
    var s2r1 : RHSCButtonTableViewCell? = nil
    var s2r2 : RHSCButtonTableViewCell? = nil
    var s2r3 : RHSCButtonTableViewCell? = nil
    var s3r0 : RHSCButtonTableViewCell? = nil
    var s3r1 : RHSCTextTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    var delegate : AnyObject? = nil
        
    override func viewDidLoad() {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        s1r0 = formTable.dequeueReusableCellWithIdentifier("Court Title Cell") as? RHSCLabelTableViewCell
        if (s1r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r0 = nib[0] as? RHSCLabelTableViewCell
        }
        s1r0?.configure(ct!.court)
        s1r1 = formTable.dequeueReusableCellWithIdentifier("Date Cell") as? RHSCLabelTableViewCell
        if (s1r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r1 = nib[1] as? RHSCLabelTableViewCell
        }
        s1r1?.configure(dateFormat.stringFromDate(ct!.courtTime!))
        s1r2 = formTable.dequeueReusableCellWithIdentifier("Time Cell") as? RHSCLabelTableViewCell
        if (s1r2 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r2 = nib[2] as? RHSCLabelTableViewCell
        }
        s1r2?.configure(timeFormat.stringFromDate(ct!.courtTime!))
        s2r0 = formTable.dequeueReusableCellWithIdentifier("Player 1 Cell") as? RHSCButtonTableViewCell
        if (s2r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r0 = nib[3] as? RHSCButtonTableViewCell
        }
        s2r0?.configure(user!.userid)
        s2r1 = formTable.dequeueReusableCellWithIdentifier("Player 2 Cell") as? RHSCButtonTableViewCell
        if (s2r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r1 = nib[4] as? RHSCButtonTableViewCell
        }
        s2r1?.configure("TBD")
        s2r2 = formTable.dequeueReusableCellWithIdentifier("Player 3 Cell") as? RHSCButtonTableViewCell
        if (s2r2 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r2 = nib[5] as? RHSCButtonTableViewCell
        }
        s2r2?.configure(ct!.players["player3_id"])
        s2r3 = formTable.dequeueReusableCellWithIdentifier("Player 4 Cell") as? RHSCButtonTableViewCell
        if (s2r3 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r3 = nib[6] as? RHSCButtonTableViewCell
        }
        s2r3?.configure("TBD")
        s3r0 = formTable.dequeueReusableCellWithIdentifier("Type Cell") as? RHSCButtonTableViewCell
        if (s3r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r0 = nib[7] as? RHSCButtonTableViewCell
        }
        s3r0?.configure("Friendly")
        s3r1 = formTable.dequeueReusableCellWithIdentifier("Desc Cell") as? RHSCTextTableViewCell
        if (s3r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r1 = nib[8] as? RHSCTextTableViewCell
        }
        s3r1?.configure("")

        if ct?.court == "Court 5" {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1, s2r2, s2r3],[s3r0, s3r1]]
        } else {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1],[s3r0, s3r1]]
        }
        
        for sect in cells {
            for myview in sect {
                myview?.selectionStyle = .None
            }
        }
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cells[indexPath.section][indexPath.row]!
    }
}