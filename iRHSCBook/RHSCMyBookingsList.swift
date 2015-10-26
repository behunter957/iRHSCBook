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

    func loadFromJSON(fromServer server:RHSCServer, user curUser:RHSCUser) {
        let logonURL : String = String.init(format: "Reserve20/IOSMyBookingsJSON.php?uid=%@",curUser.data!.name)
        let target = NSURL(string:logonURL, relativeToURL:server)
        let request = NSURLRequest(URL:target!,
            cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval:30.0)
        // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        let error: AutoreleasingUnsafeMutablePointer<NSErrorPointer?> = nil
        // Sending Synchronous request using NSURLConnection
        do {
            let responseData = try NSURLConnection.sendSynchronousRequest(request,returningResponse: response) as NSData
            if (error == nil) {
                let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                // Get an array of dictionaries with the key "locations"
                let array : Array<NSDictionary> = jsonDictionary["bookings"]! as! Array<NSDictionary>
                // Iterate through the array of dictionaries
                for dict in array {
                    bookingList.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser.userid!))
                }
            }
        } catch {
            
        }
    }
    
}