//
//  RHSCMemberList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCMemberList : NSObject {

    var memberList : Array<RHSCMember> = Array<RHSCMember>()
    var TBD : RHSCMember? = nil
    var GUEST : RHSCMember? = nil
    var isLoaded : Bool = false
    
    func loadFromJSON(fromServer server :RHSCServer) throws {
    // Create a NSURLRequest with the given URL
        let logonURL : String = "Reserve20/IOSMemberListJSON.php"
        let target = NSURL(string:logonURL, relativeToURL:server)
        let request = NSURLRequest(URL:target!,
                cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval:30.0)
    // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        // Sending Synchronous request using NSURLConnection
        let responseData = try NSURLConnection.sendSynchronousRequest(request,returningResponse: response) as NSData
        try loadFromData(responseData)
    }
    
    func loadFromData(data : NSData) throws {
        // Now create a NSDictionary from the JSON data
        let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
    
        // Get an array of dictionaries with the key "locations"
        let array : Array<NSDictionary> = jsonDictionary["members"]! as! Array<NSDictionary>
        // Iterate through the array of dictionaries
        for dict in array {
            // Create a new Location object for each one and initialise it with information in the dictionary
            let member = RHSCMember(fromJSONDictionary:dict )
            // Add the Location object to the array
            memberList.append(member)
        }
        isLoaded = (self.memberList.count != 0);
        memberList.append(RHSCMember(fromName: "TBD", fromType: "Active"))
        memberList.append(RHSCMember(fromName: "GUEST", fromType: "Active"))
    }
    
    func find(member name : String) -> RHSCMember? {
        for tst in memberList {
            if tst.name == name {
                return tst;
            }
        }
        return nil;
    }
    
    func loadedSuccessfully() -> Bool
    {
        return isLoaded;
    }
    
    
}
