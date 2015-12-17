//
//  RHSCMyBookingsList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

@objc class RHSCMyBookingsList : NSObject {

    var list = Array<RHSCCourtTime>()

    func loadFromJSON(fromServer server:RHSCServer, user curUser:RHSCUser, memberList ml:RHSCMemberList) throws {
        let url = NSURL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",curUser.name!),
            relativeToURL: server )
        //        print(url!.absoluteString)
        let sessionCfg = NSURLSession.sharedSession().configuration
        sessionCfg.timeoutIntervalForResource = 30.0
        let session = NSURLSession(configuration: sessionCfg)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data!, forUser: (curUser.name)!, memberList: ml)
            }
        })
        task.resume()
    }
        func loadFromData(fromData:NSData, forUser: String, memberList ml:RHSCMemberList) {
        do {
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(fromData, options: []) as? NSDictionary {
                let array : Array<NSDictionary> = jsonDictionary["bookings"]! as! Array<NSDictionary>
                for dict in array {
                    list.append(RHSCCourtTime(withJSONDictionary: dict, forUser: forUser, members: ml))
                }
            }
        } catch {
            print(error)
        }
    }

    func loadAsync(fromView view: UITableViewController) {
        let tbc = view.tabBarController as! RHSCTabBarController
        let url = NSURL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",
            (tbc.currentUser?.name)!),
            relativeToURL: tbc.server )
        //        print(url!.absoluteString)
        //        let sessionCfg = NSURLSession.sharedSession().configuration
        //        sessionCfg.timeoutIntervalForResource = 30.0
        //        let session = NSURLSession(configuration: sessionCfg)
        let session  = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!)
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    // update some UI
                    view.tableView.reloadData()
                });
            });
        })
        task.resume()
    }
    

}