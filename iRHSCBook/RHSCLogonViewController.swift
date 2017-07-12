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
    
    var currentUser : RHSCUser? = nil
    var server : RHSCServer? = nil
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    override func viewDidLoad() {
        
        let defaults = UserDefaults.standard
        let userid = defaults.string(forKey: "RHSCUserID") ?? "ChangeMe"
        defaults.set(userid, forKey: "RHSCUserID")
        let passwd = defaults.string(forKey: "RHSCPassword") ?? "ChangeMe"
        defaults.set(passwd, forKey: "RHSCPassword")
        let srvrname = defaults.string(forKey: "RHSCServerURL") ?? "http://www.rhsquashclub.com"
        defaults.set(srvrname, forKey: "RHSCServerURL")

        let networkReachability = Reachability()!
        let networkStatus = networkReachability.currentReachabilityStatus
        if (networkStatus == Reachability.NetworkStatus.notReachable) {
            self.view.isUserInteractionEnabled = false
            // if not found then logon failes
            self.errorAlert = UIAlertController(title: "No Internet Connection",
                                                message: "Close the application and try later.", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                })
            })
        } else {
            // try to logon with the defaults
            self.currentUser = RHSCUser(forUserid: userid, forPassword: passwd)
            self.server = RHSCServer(string: "", relativeTo: URL(string: srvrname))
            if self.currentUser!.validate(fromServer: server!) {
                // valid credentials - dismiss dialog and go to tab controller
            } else {
                // invalid credentials - continue with dialog
                
                // create the cells
                r0 = formTable.dequeueReusableCell(withIdentifier: "UserID Cell") as? RHSCUserIDTableViewCell
                if (r0 == nil) {
                    let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                    r0 = nib?[0] as? RHSCUserIDTableViewCell
                }
                r1 = formTable.dequeueReusableCell(withIdentifier: "Password Cell") as? RHSCPasswordTableViewCell
                if (r1 == nil) {
                    let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                    r1 = nib?[0] as? RHSCPasswordTableViewCell
                }
                r2 = formTable.dequeueReusableCell(withIdentifier: "Logon Cell") as? RHSCButtonTableViewCell
                if (r2 == nil) {
                    let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                    r2 = nib?[3] as? RHSCButtonTableViewCell
                }
                cells = [r0, r1, r2]
                for cell in cells {
                    cell?.selectionStyle = .none
                }
            }
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
        // try to logon with the defaults
        self.currentUser = RHSCUser(forUserid: (r0?.textField.text)!, forPassword: (r1?.textField.text)!)
        if self.currentUser!.validate(fromServer: server!) {
            // valid credentials - save defaults, dismiss dialog and go to tab controller
        } else {
            // invalid credentials - put up error continue with dialog
            self.errorAlert = UIAlertController(title: "Logon Failed",
                                                message: "Please check settings and provide a valid userid and password.", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.errorAlert!.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
}

