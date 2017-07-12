//
//  RHSCLogonViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2017-07-12.
//  Copyright © 2017 Bruce Hunter. All rights reserved.
//

import Foundation
import MessageUI

class RHSCLogonViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var formTable: UITableView!
    
    var r0 : RHSCUserIDTableViewCell? = nil
    var r1 : RHSCPasswordTableViewCell? = nil
    var r2 : RHSCButtonTableViewCell? = nil
    var cells : Array<UITableViewCell?> = []

    
    var delegate : AnyObject? = nil
    
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    override func viewDidLoad() {
        
        //        self.tableView.accessibilityIdentifier = "BookCourt"
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        r0 = formTable.dequeueReusableCell(withIdentifier: "UserID Cell") as? RHSCUserIDTableViewCell
        if (r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            r0 = nib?[0] as? RHSCUserIDTableViewCell
        }
        r1 = formTable.dequeueReusableCell(withIdentifier: "Password Cell") as? RHSCPasswordTableViewCell
        if (r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            r0 = nib?[0] as? RHSCPasswordTableViewCell
        }
        r2 = formTable.dequeueReusableCell(withIdentifier: "Logon Cell") as? RHSCButtonTableViewCell
        if (r2 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            r2 = nib?[3] as? RHSCButtonTableViewCell
        }
        cells = [r0, r1, r2]
        for sect in cells {
            sect?.selectionStyle = .none
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.cells[(indexPath as NSIndexPath).row]!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
    
    func didClickOnLogonButton(_ sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func logon() {
    }
    
}

