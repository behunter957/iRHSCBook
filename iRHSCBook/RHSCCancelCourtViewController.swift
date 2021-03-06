//
//  RHSCCancelCourtViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-09.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

protocol cancelCourtProtocol {
    
    func refreshTable()
}

class RHSCCancelCourtViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, playerButtonDelegateProtocol {
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
    var s3r0 : RHSCPickerTableViewCell? = nil
    var s3r1 : RHSCTextTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    var delegate : cancelCourtProtocol? = nil
    
    var player2Member : RHSCMember? = nil
    var player3Member : RHSCMember? = nil
    var player4Member : RHSCMember? = nil
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    override func viewDidLoad() {
        
//        self.tableView.accessibilityIdentifier = "CancelCourt"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        s1r0 = formTable.dequeueReusableCell(withIdentifier: "Court Title Cell") as? RHSCLabelTableViewCell
        if (s1r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r0 = nib?[0] as? RHSCLabelTableViewCell
        }
        s1r0?.configure(ct!.court)
        s1r1 = formTable.dequeueReusableCell(withIdentifier: "Date Cell") as? RHSCLabelTableViewCell
        if (s1r1 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r1 = nib?[1] as? RHSCLabelTableViewCell
        }
        s1r1?.configure(dateFormat.string(from: ct!.courtTime!))
        s1r2 = formTable.dequeueReusableCell(withIdentifier: "Time Cell") as? RHSCLabelTableViewCell
        if (s1r2 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r2 = nib?[2] as? RHSCLabelTableViewCell
        }
        s1r2?.configure(timeFormat.string(from: ct!.courtTime!))
        s2r0 = formTable.dequeueReusableCell(withIdentifier: "Player 1 Cell") as? RHSCButtonTableViewCell
        if (s2r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r0 = nib?[3] as? RHSCButtonTableViewCell
        }
        s2r0?.configure(self,buttonNum: 1,buttonText: user!.buttonText())
        s2r1 = formTable.dequeueReusableCell(withIdentifier: "Player 2 Cell") as? RHSCButtonTableViewCell
        if (s2r1 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r1 = nib?[4] as? RHSCButtonTableViewCell
        }
        s2r1?.configure(self,buttonNum: 2,buttonText: ct!.players[2]!.buttonText())
        if ct!.court == "Court 5" {
            s2r2 = formTable.dequeueReusableCell(withIdentifier: "Player 3 Cell") as? RHSCButtonTableViewCell
            if (s2r2 == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                s2r2 = nib?[5] as? RHSCButtonTableViewCell
            }
            s2r2?.configure(self,buttonNum: 3,buttonText: ct!.players[3]!.buttonText())
            s2r3 = formTable.dequeueReusableCell(withIdentifier: "Player 4 Cell") as? RHSCButtonTableViewCell
            if (s2r3 == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                s2r3 = nib?[6] as? RHSCButtonTableViewCell
            }
            s2r3?.configure(self,buttonNum: 4,buttonText: ct!.players[4]!.buttonText())
        }
        s3r0 = formTable.dequeueReusableCell(withIdentifier: "Type Cell") as? RHSCPickerTableViewCell
        if (s3r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r0 = nib?[7] as? RHSCPickerTableViewCell
        }
        s3r0?.configure((ct?.event)!)
        s3r1 = formTable.dequeueReusableCell(withIdentifier: "Desc Cell") as? RHSCTextTableViewCell
        if (s3r1 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r1 = nib?[8] as? RHSCTextTableViewCell
        }
        s3r1?.configure(ct?.eventDesc)
        
        if ct?.court == "Court 5" {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1, s2r2, s2r3],[s3r0, s3r1]]
        } else {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1],[s3r0, s3r1]]
        }
        
        for sect in cells {
            for myview in sect {
                myview?.selectionStyle = .none
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cells[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ct!.unlock(fromView: self)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //        switch section {
        //        case 0: return "Coordinates"
        //        case 1: return "Players"
        //        case 2: return "Event"
        //        default: return ""
        //        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.gray
        let txtView = view as! UITableViewHeaderFooterView
        txtView.textLabel?.textColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func didClickOnPlayerButton(_ sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
    }
    
    @IBAction func cancelBooking() {
        ct!.cancel(fromView: self)
        ct!.unlock(fromView: self)
    }
    
}
