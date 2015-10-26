//
//  RHSCUser.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCUser : NSObject {
    
    var data : RHSCMember? = nil
    static var loggedOn : Bool = false
    var userid : String? = nil
    var password : String? = nil

    init( fromServer srvr : RHSCServer, userid uid : String, password pwd : String) {
        userid = uid;
        password = pwd;
        data = RHSCUser.userFromJSON(fromServer: srvr, userid: uid, password: pwd)
    }
    
    class func userFromJSON(fromServer server:RHSCServer,userid uid:String, password pwd:String) -> RHSCMember? {
        let logonURL : String = String.init(format: "Reserve20/IOSUserLogonJSON.php?uid=%@&pwd=%@", uid,pwd)
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
                let array : Array<NSDictionary> = jsonDictionary["user"]! as! Array<NSDictionary>
                // Iterate through the array of dictionaries
                for dict in array {
                    loggedOn = true
                    // Create a new Location object for each one and initialise it with information in the dictionary
                    return RHSCMember(fromJSONDictionary:dict )
                }
            }
        } catch {
            
        }
        return nil;
    }
    
    func isLoggedOn() -> Bool {
        return RHSCUser.loggedOn;
    }
    

    
}