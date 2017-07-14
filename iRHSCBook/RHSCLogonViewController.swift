//
//  RHSCLogonViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2017-07-12.
//  Copyright © 2017 Bruce Hunter. All rights reserved.
//

import Foundation
import MessageUI

class RHSCLogonViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, logonButtonDelegateProtocol {
    
    @IBOutlet var formTable: UITableView!
    
    var r0 : RHSCUserIDTableViewCell? = nil
    var r1 : RHSCPasswordTableViewCell? = nil
    var r2 : RHSCLogonTableViewCell? = nil
    var cells : Array<UITableViewCell?> = []

    
    var delegate : AnyObject? = nil
    
    var currentUser : RHSCUser? = nil
    var server : RHSCServer? = nil
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil


    override func viewDidLoad() {
        let tbc = self.tabBarController as! RHSCTabBarController
        formTable.backgroundColor = UIColor.black
        let defaults = UserDefaults.standard
        let userid = defaults.string(forKey: "RHSCUserID") ?? "ChangeMe"
        defaults.set(userid, forKey: "RHSCUserID")
        let passwd = defaults.string(forKey: "RHSCPassword") ?? "ChangeMe"
        defaults.set(passwd, forKey: "RHSCPassword")
        let srvrname = defaults.string(forKey: "RHSCServerURL") ?? "http://www.rhsquashclub.com"
        defaults.set(srvrname, forKey: "RHSCServerURL")

        // create the cells
        self.r0 = formTable.dequeueReusableCell(withIdentifier: "UserID Cell") as? RHSCUserIDTableViewCell
        if (self.r0 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            self.r0 = nib?[9] as? RHSCUserIDTableViewCell
        }
        self.r0?.textField.text = "User ID:"
        self.r0?.configure(userid)
        self.r1 = formTable.dequeueReusableCell(withIdentifier: "Password Cell") as? RHSCPasswordTableViewCell
        if (self.r1 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            self.r1 = nib?[10] as? RHSCPasswordTableViewCell
        }
        self.r1?.textField.text = "Password:"
        self.r1?.configure(passwd)
        self.r2 = formTable.dequeueReusableCell(withIdentifier: "Logon Cell") as? RHSCLogonTableViewCell
        if (self.r2 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            self.r2 = nib?[11] as? RHSCLogonTableViewCell
        }
        self.r2?.configure(self)
        cells = [self.r0, self.r1, self.r2]
        for cell in cells {
            cell?.selectionStyle = .none
        }
        
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
                tbc.viewControllers = tbc.fullVCList
            } else {
                // invalid credentials - continue with dialog
                
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

    func didClickOnLogonButton(_ sender: RHSCLogonTableViewCell?) {
        // try to logon with the defaults
        let tbc = self.tabBarController as! RHSCTabBarController
        UserDefaults.standard.synchronize()
        let defaults = UserDefaults.standard
        let srvrname = defaults.string(forKey: "RHSCServerURL") ?? "http://www.rhsquashclub.com"
        defaults.set((r0?.textField.text)!, forKey: "RHSCUserID")
        defaults.set((r1?.textField.text)!, forKey: "RHSCPassword")
        print(defaults)
        tbc.server = RHSCServer(string: "", relativeTo: URL(string: srvrname))
        tbc.currentUser = RHSCUser(forUserid: (r0?.textField.text)!, forPassword: (r1?.textField.text)!)
        if tbc.currentUser!.validate(fromServer: server!) {
            // valid credentials - save defaults, dismiss dialog and go to tab controller
            tbc.memberList = RHSCMemberList()
            try! tbc.memberList?.loadFromJSON(fromServer: tbc.server!)
            if (!tbc.memberList!.loadedSuccessfully()) {
                self.view.isUserInteractionEnabled = false
                // if not found then logon failes
                self.errorAlert = UIAlertController(title: "Load Members Failed",
                                                    message: "Please check settings and restart iRHSCBook or contact administrator.", preferredStyle: .alert)
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
            } else {
                tbc.viewControllers = tbc.fullVCList
            }
        } else {
            // invalid credentials - put up error continue with dialog
            self.errorAlert = UIAlertController(title: "Logon Failed",
                                                message: "Please provide a valid userid and password, or check application settings.", preferredStyle: .alert)
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

