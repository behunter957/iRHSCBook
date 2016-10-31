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
        let url = URL(string: String.init(format: "Reserve20/IOSHistoryJSON.php?uid=%@",curUser.name!),
            relativeTo: server as URL )
        //        print(url!.absoluteString)
        let sessionCfg = URLSession.shared.configuration
        sessionCfg.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionCfg)
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data!, forUser: (curUser.name)!, memberList: ml, forMeOnly: forMe)
            }
        })
        task.resume()
    }
    
    func loadFromData(_ fromData:Data, forUser: String, memberList ml:RHSCMemberList, forMeOnly: Bool) {
        list.removeAll()
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: fromData, options: []) as? [String : Any] {
                let array : Array<[String : Any]> = jsonDictionary["history"]! as! Array<[String : Any]>
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
        let url = URL(string: String.init(format: "Reserve20/IOSHistoryJSON.php?uid=%@",
            (tbc.currentUser?.name)!),
            relativeTo: tbc.server as URL? )
        //        print(url!.absoluteString)
        //        let sessionCfg = NSURLSession.sharedSession().configuration
        //        sessionCfg.timeoutIntervalForResource = 30.0
        //        let session = NSURLSession(configuration: sessionCfg)
        let session  = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!, forMeOnly: forMe)
            }
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    // update some UI
                    // print("reloading tableview")
                    view.tableView.reloadData()
                });
            });
        })
        task.resume()
    }
    

}
