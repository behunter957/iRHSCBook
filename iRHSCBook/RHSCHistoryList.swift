//
//  RHSCHistoryList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCHistoryList : NSObject {
    
    var list = Array<RHSCCourtTime>()
    
    func loadFromJSON(fromServer server:RHSCServer, user curUser:RHSCUser, memberList ml:RHSCMemberList, forMe: Bool) throws {
        let url = NSURL(string: String.init(format: "Reserve20/IOSHistoryJSON.php?uid=%@",curUser.name!),
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
                self.loadFromData(data!, forUser: (curUser.name)!, memberList: ml, forMeOnly: forMe)
            }
        })
        task.resume()
    }
    
    func loadFromData(fromData:NSData, forUser: String, memberList ml:RHSCMemberList, forMeOnly: Bool) {
        do {
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(fromData, options: []) as? NSDictionary {
                let array : Array<NSDictionary> = jsonDictionary["history"]! as! Array<NSDictionary>
                for dict in array {
                    let ct = RHSCCourtTime(withJSONDictionary: dict, forUser: forUser, members: ml)
                    if forMeOnly {
                        if ((forUser == ct.players[1]!.name) || (forUser == ct.players[2]!.name) ||
                            (forUser == ct.players[3]!.name) || (forUser == ct.players[4]!.name)) {
                                list.append(ct)
                        }
                    } else {
                        list.append(ct)
                    }
                }
            }
        } catch {
            print(error)
        }
    }

    func loadAsync(fromView view:UITableViewController, forMe: Bool) {
        let tbc = view.tabBarController as! RHSCTabBarController
        let url = NSURL(string: String.init(format: "Reserve20/IOSHistoryJSON.php?uid=%@",
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
                self.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!, forMeOnly: forMe)
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    // update some UI
                    // print("reloading tableview")
                    view.tableView.reloadData()
                });
            });
        })
        task.resume()
    }
    

}