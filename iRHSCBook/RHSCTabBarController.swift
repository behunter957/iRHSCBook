//
//  RHSCTabBarController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-26.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

class RHSCTabBarController : UITabBarController,UIAlertViewDelegate {

    var memberList : RHSCMemberList? = nil
    var currentUser : RHSCUser? = nil
    var server : RHSCServer? = nil
    var courtSet : String? = nil
    var includeBookings : Bool = true

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
        appDefaults["RHSCIncludeBookings"] = false
        appDefaults["RHSCServerURL"] = "www.rhsquashclub.com"
        appDefaults["RHSCUserID"] = "userid"
        appDefaults["RHSCPassword"] = "password"
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.courtSet = NSUserDefaults.standardUserDefaults().stringForKey("RHSCCourtSet")
        self.includeBookings = NSUserDefaults.standardUserDefaults().boolForKey("RHSCIncludeBookings")
    
        let networkReachability = try! Reachability.reachabilityForInternetConnection()
        let networkStatus = networkReachability.currentReachabilityStatus
        if (networkStatus == Reachability.NetworkStatus.NotReachable) {
            self.view.userInteractionEnabled = false
            // if not found then logon failes
            let alert = UIAlertView(title: "No Internet Connection",
                message: "Close the application and try later.",
                delegate: self,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        } else {
            let srvrname = NSUserDefaults.standardUserDefaults().stringForKey("RHSCServerURL")
            self.server = RHSCServer(fileURLWithPath: String.init(format: "http://%@", arguments: [srvrname!]))
            
            let userid = NSUserDefaults.standardUserDefaults().stringForKey("RHSCUserID")
            let passwd = NSUserDefaults.standardUserDefaults().stringForKey("RHSCPassword")
            
            self.currentUser = RHSCUser(fromServer: server!, userid: userid!, password: passwd!)

            self.memberList = RHSCMemberList()

            if (!self.currentUser!.isLoggedOn()) {
                self.view.userInteractionEnabled = false
                // if not found then logon failes
                let alert = UIAlertView(title: "Logon Failed",
                    message: "Please check settings and provide a valid userid and password.",
                    delegate: self,
                    cancelButtonTitle: "OK",
                    otherButtonTitles: "", "")
                alert.show()
            } else {
                try! self.memberList?.loadFromJSON(fromServer: self.server!)
                if (!self.memberList!.loadedSuccessfully()) {
                    self.view.userInteractionEnabled = false
                    // if not found then logon failes
                    let alert = UIAlertView(title: "Load Members Failed",
                        message: "Please check settings and restart iRHSCBook or contact administrator.",
                        delegate: self,
                        cancelButtonTitle: "OK",
                        otherButtonTitles: "", "")
                    alert.show()
                }
            }
        }
    }
    
}
