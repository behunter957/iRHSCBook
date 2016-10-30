//
//  RHSCReportNoShowViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-26.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCReportNoShowViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var courtTitleCell : RHSCLabelTableViewCell? = nil
    var dateCell : RHSCLabelTableViewCell? = nil
    var timeCell : RHSCLabelTableViewCell? = nil
    var player1Cell : RHSCLabelTableViewCell? = nil
    var player2Cell : RHSCLabelTableViewCell? = nil
    var player3Cell : RHSCLabelTableViewCell? = nil
    var player4Cell : RHSCLabelTableViewCell? = nil
    var typeCell : RHSCLabelTableViewCell? = nil
    var descCell : RHSCLabelTableViewCell? = nil
    var notesCell : RHSCTextTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    var delegate : AnyObject? = nil

    override func viewDidLoad() {
        
//        self.tableView.accessibilityIdentifier = "ReportNoShow"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        courtTitleCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Court") as? RHSCLabelTableViewCell
        if (courtTitleCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            courtTitleCell = nib?[0] as? RHSCLabelTableViewCell
        }
        courtTitleCell?.configure(ct!.court)

        dateCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Date") as? RHSCLabelTableViewCell
        if (dateCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            dateCell = nib?[1] as? RHSCLabelTableViewCell
        }
        dateCell?.configure(ct!.court)
        
        timeCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Time") as? RHSCLabelTableViewCell
        if (timeCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            timeCell = nib?[2] as? RHSCLabelTableViewCell
        }
        timeCell?.configure(ct!.court)
        
        player1Cell = formTable.dequeueReusableCell(withIdentifier: "NoShow Player1") as? RHSCLabelTableViewCell
        if (player1Cell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            player1Cell = nib?[3] as? RHSCLabelTableViewCell
        }
        player1Cell?.configure(ct!.players[1]!.buttonText())
        
        player2Cell = formTable.dequeueReusableCell(withIdentifier: "NoShow Player2") as? RHSCLabelTableViewCell
        if (player2Cell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            player2Cell = nib?[4] as? RHSCLabelTableViewCell
        }
        player2Cell?.configure(ct!.players[2]!.buttonText())
        
        if ct!.court == "Court 5" {
            player3Cell = formTable.dequeueReusableCell(withIdentifier: "NoShow Player3") as? RHSCLabelTableViewCell
            if (player3Cell == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
                player3Cell = nib?[5] as? RHSCLabelTableViewCell
            }
            player3Cell?.configure(ct!.players[3]!.buttonText())
            
            player4Cell = formTable.dequeueReusableCell(withIdentifier: "NoShow Player4") as? RHSCLabelTableViewCell
            if (player4Cell == nil) {
                let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
                player4Cell = nib?[6] as? RHSCLabelTableViewCell
            }
            player4Cell?.configure(ct!.players[4]!.buttonText())
            
        }
        
        typeCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Type") as? RHSCLabelTableViewCell
        if (typeCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            typeCell = nib?[7] as? RHSCLabelTableViewCell
        }
        typeCell?.configure(ct!.event)
        
        descCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Desc") as? RHSCLabelTableViewCell
        if (descCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            descCell = nib?[8] as? RHSCLabelTableViewCell
        }
        descCell?.configure(ct!.eventDesc)
        
        notesCell = formTable.dequeueReusableCell(withIdentifier: "NoShow Notes") as? RHSCTextTableViewCell
        if (notesCell == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCReportNoShowTableViewCell", owner: self, options: nil)
            notesCell = nib?[9] as? RHSCTextTableViewCell
        }
//        notesCell?.configure(" ")
        
        if ct?.court == "Court 5" {
            cells = [[courtTitleCell, dateCell, timeCell],[player1Cell, player2Cell, player3Cell, player4Cell],[typeCell, descCell, notesCell]]
        } else {
            cells = [[courtTitleCell, dateCell, timeCell],[player1Cell, player2Cell],[typeCell, descCell, notesCell]]
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
    
    @IBAction func reportNoShow() {
        ct!.reportNoShow(fromView: self)
    }
    
}
