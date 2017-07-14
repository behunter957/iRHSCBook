//
//  RHSCTabBarController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCTabBarController : UITabBarController,UIAlertViewDelegate {

    var memberList : RHSCMemberList? = nil
    var currentUser : RHSCUser? = nil
    var server : RHSCServer? = nil
    var courtSet : String? = nil
    var showBooked : Bool = true
    var errorAlert : UIAlertController? = nil
    var fullVCList : [UIViewController] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(nibNameOrNil:String, bundle nibBundleOrNil :Bundle) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // validate logon
        let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle")
        if((settingsBundle == nil)) {
            print("Could not find Settings.bundle");
            return;
        }
        
        let defaults = UserDefaults.standard
        self.fullVCList = self.viewControllers!
        let y : [UIViewController] = [(fullVCList[0])]
        self.fullVCList.remove(at: 0)
        self.viewControllers = y
        
        self.courtSet = defaults.string(forKey: "RHSCCourtSet") ?? "All"
        defaults.set(self.courtSet, forKey: "RHSCCourtSet")
        self.showBooked = defaults.bool(forKey: "RHSCShowBooked")
        defaults.set(self.showBooked, forKey: "RHSCShowBooked")
    
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
            let srvrname = defaults.string(forKey: "RHSCServerURL") ?? "http://www.rhsquashclub.com"
//            print(srvrname)
            defaults.set(srvrname, forKey: "RHSCServerURL")
            
            self.server = RHSCServer(string: "", relativeTo: URL(string: srvrname))
//            self.server = RHSCServer(scheme: "http://", host: srvrname!, path: "")

            let userid = defaults.string(forKey: "RHSCUserID") ?? "ChangeMe"
            defaults.set(userid, forKey: "RHSCUserID")
            let passwd = defaults.string(forKey: "RHSCPassword") ?? "ChangeMe"
            defaults.set(passwd, forKey: "RHSCPassword")
            //            print("Logging on with: ",userid," ",passwd)
            
            self.currentUser = RHSCUser(forUserid: userid, forPassword: passwd)
            if self.currentUser!.validate(fromServer: server!) {
                self.memberList = RHSCMemberList()
                try! self.memberList?.loadFromJSON(fromServer: self.server!)
                if (!self.memberList!.loadedSuccessfully()) {
                    self.view.isUserInteractionEnabled = false
                    // if not found then logon failes
                    self.errorAlert = UIAlertController(title: "Load Members Failed",
                        message: "Please check settings and restart iRHSCBook or contact administrator.", preferredStyle: .alert)
                    DispatchQueue.global().async(execute: {
                        // do some task
                        DispatchQueue.main.async(execute: {
                            self.present(self.errorAlert!, animated: true, completion: nil)
                        })
                    })
                }
                self.viewControllers = fullVCList
            }


        }
    }
    
}
