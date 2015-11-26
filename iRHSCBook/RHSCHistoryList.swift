//
//  RHSCHistoryList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCHistoryList : NSObject {
    
    var historyList = Array<RHSCCourtTime>()
    
    func loadFromJSON(fromServer server:RHSCServer, user curUser:RHSCUser, memberList ml:RHSCMemberList) throws {
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
                self.loadFromData(data!, forUser: (curUser.name)!, memberList: ml)
            }
        })
        task.resume()
    }
    
    func loadFromData(fromData:NSData, forUser: String, memberList ml:RHSCMemberList) {
        do {
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(fromData, options: []) as? NSDictionary {
                let array : Array<NSDictionary> = jsonDictionary["history"]! as! Array<NSDictionary>
                for dict in array {
                    historyList.append(RHSCCourtTime(withJSONDictionary: dict, forUser: forUser, members: ml))
                }
            }
        } catch {
            print(error)
        }
    }
    
}