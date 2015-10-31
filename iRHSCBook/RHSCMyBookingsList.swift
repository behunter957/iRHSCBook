//
//  RHSCMyBookingsList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCMyBookingsList : NSObject {

    var bookingList : Array<RHSCCourtTime> = Array<RHSCCourtTime>()

    func loadFromJSON(fromServer server:RHSCServer, user curUser:RHSCUser) throws {
        let url = NSURL(string: String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",curUser.data!.name!),
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
                self.loadFromData(data!, forUser: (curUser.data?.name)!)
            }
        })
        task.resume()
    }
    
    func loadFromData(fromData:NSData, forUser: String) {
        do {
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(fromData, options: []) as? NSDictionary {
                let array : Array<NSDictionary> = jsonDictionary["bookings"]! as! Array<NSDictionary>
                for dict in array {
                    bookingList.append(RHSCCourtTime(withJSONDictionary: dict, forUser: forUser))
                }
            }
        } catch {
            print(error)
        }
    }
    
}