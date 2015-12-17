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
    
    init(nibNameOrNil:String, bundle nibBundleOrNil :NSBundle) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // validate logon
        let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle")
        if((settingsBundle == nil)) {
            print("Could not find Settings.bundle");
            return;
        }
        
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["RHSCCourtSet"] = "All"
        appDefaults["RHSCShowBooked"] = false
        appDefaults["RHSCServerURL"] = "http://www.rhsquashclub.com"
        appDefaults["RHSCUserID"] = "Bruce.Hunter"
        appDefaults["RHSCPassword"] = "maxwell"
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.courtSet = NSUserDefaults.standardUserDefaults().stringForKey("RHSCCourtSet")
        self.showBooked = NSUserDefaults.standardUserDefaults().boolForKey("RHSCShowBooked")
    
        let networkReachability = try! Reachability.reachabilityForInternetConnection()
        let networkStatus = networkReachability.currentReachabilityStatus
        if (networkStatus == Reachability.NetworkStatus.NotReachable) {
            self.view.userInteractionEnabled = false
            // if not found then logon failes
            self.errorAlert = UIAlertController(title: "No Internet Connection",
                message: "Close the application and try later.", preferredStyle: .Alert)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                })
            })
        } else {
            let srvrname = NSUserDefaults.standardUserDefaults().stringForKey("RHSCServerURL")
            
            self.server = RHSCServer(string: "", relativeToURL: NSURL(string: srvrname!))
//            self.server = RHSCServer(scheme: "http://", host: srvrname!, path: "")

            let userid = NSUserDefaults.standardUserDefaults().stringForKey("RHSCUserID")
            let passwd = NSUserDefaults.standardUserDefaults().stringForKey("RHSCPassword")
//            print("Logging on with: ",userid," ",passwd)
            
            self.currentUser = RHSCUser(forUserid: userid!, forPassword: passwd!)
            if self.currentUser!.validate(fromServer: server!) {
                self.memberList = RHSCMemberList()
                try! self.memberList?.loadFromJSON(fromServer: self.server!)
                if (!self.memberList!.loadedSuccessfully()) {
                    self.view.userInteractionEnabled = false
                    // if not found then logon failes
                    self.errorAlert = UIAlertController(title: "Load Members Failed",
                        message: "Please check settings and restart iRHSCBook or contact administrator.", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // do some task
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                        })
                    })
                }
            } else {
                self.view.userInteractionEnabled = false
                // if not found then logon failes
                self.errorAlert = UIAlertController(title: "Logon Failed",
                    message: "Please check settings and provide a valid userid and password.", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    })
                })
            }

        }
    }
    
}
