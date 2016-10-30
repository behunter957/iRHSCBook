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
        let url = URL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",curUser.name!),
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
                self.loadFromData(data!, forUser: (curUser.name)!, memberList: ml)
            }
        })
        task.resume()
    }
        func loadFromData(_ fromData:Data, forUser: String, memberList ml:RHSCMemberList) {
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: fromData, options: []) as? NSDictionary {
                let array : Array<[String : String]> = jsonDictionary["bookings"]! as! Array<[String : String]>
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
        let url = URL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",
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
                self.loadFromData(data!, forUser: tbc.currentUser!.name!, memberList: tbc.memberList!)
            }
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    // update some UI
                    view.tableView.reloadData()
                });
            });
        })
        task.resume()
    }
    

}
