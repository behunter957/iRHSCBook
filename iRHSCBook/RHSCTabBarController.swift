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
        
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["RHSCCourtSet"] = "All" as AnyObject?
        appDefaults["RHSCShowBooked"] = false as AnyObject?
        appDefaults["RHSCServerURL"] = "http://www.rhsquashclub.com" as AnyObject?
        appDefaults["RHSCUserID"] = "Bruce.Hunter" as AnyObject?
        appDefaults["RHSCPassword"] = "maxwell" as AnyObject?
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
        
        self.courtSet = UserDefaults.standard.string(forKey: "RHSCCourtSet")
        self.showBooked = UserDefaults.standard.bool(forKey: "RHSCShowBooked")
    
        let networkReachability = try! Reachability.reachabilityForInternetConnection()
        let networkStatus = networkReachability.currentReachabilityStatus
        if (networkStatus == Reachability.NetworkStatus.notReachable) {
            self.view.isUserInteractionEnabled = false
            // if not found then logon failes
            self.errorAlert = UIAlertController(title: "No Internet Connection",
                message: "Close the application and try later.", preferredStyle: .alert)
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                })
            })
        } else {
            let srvrname = UserDefaults.standard.string(forKey: "RHSCServerURL")
            
            self.server = RHSCServer(string: "", relativeTo: URL(string: srvrname!))
//            self.server = RHSCServer(scheme: "http://", host: srvrname!, path: "")

            let userid = UserDefaults.standard.string(forKey: "RHSCUserID")
            let passwd = UserDefaults.standard.string(forKey: "RHSCPassword")
//            print("Logging on with: ",userid," ",passwd)
            
            self.currentUser = RHSCUser(forUserid: userid!, forPassword: passwd!)
            if self.currentUser!.validate(fromServer: server!) {
                self.memberList = RHSCMemberList()
                try! self.memberList?.loadFromJSON(fromServer: self.server!)
                if (!self.memberList!.loadedSuccessfully()) {
                    self.view.isUserInteractionEnabled = false
                    // if not found then logon failes
                    self.errorAlert = UIAlertController(title: "Load Members Failed",
                        message: "Please check settings and restart iRHSCBook or contact administrator.", preferredStyle: .alert)
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                        // do some task
                        DispatchQueue.main.async(execute: {
                            self.present(self.errorAlert!, animated: true, completion: nil)
                        })
                    })
                }
            } else {
                self.view.isUserInteractionEnabled = false
                // if not found then logon failes
                self.errorAlert = UIAlertController(title: "Logon Failed",
                    message: "Please check settings and provide a valid userid and password.", preferredStyle: .alert)
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                    // do some task
                    DispatchQueue.main.async(execute: {
                        self.present(self.errorAlert!, animated: true, completion: nil)
                    })
                })
            }

        }
    }
    
}
