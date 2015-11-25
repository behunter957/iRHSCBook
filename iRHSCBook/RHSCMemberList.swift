//
//  RHSCMemberList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCMemberList : NSObject {

    var memberList = [RHSCMember]()
    var memberDict = Dictionary<String,RHSCMember>()
    var TBD = RHSCMember(fromName: "TBD", fromType: "Single")
    var GUEST = RHSCMember(fromName: "Guest", fromType: "Single")
    var EMPTY = RHSCMember(fromName: "", fromType: "Single")

    var isLoaded : Bool = false
    
    func loadFromJSON(fromServer server :RHSCServer) throws {
        let url = NSURL(string: "Reserve20/IOSMemberListJSON.php", relativeToURL: server )
        //        print(url!.absoluteString)
//        let sessionCfg = NSURLSession.sharedSession().configuration
//        sessionCfg.timeoutIntervalForResource = 30.0
//        let session = NSURLSession(configuration: sessionCfg)
        let session = NSURLSession.sharedSession()
        let semaphore_memlist = dispatch_semaphore_create(0)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data)
            }
            dispatch_semaphore_signal(semaphore_memlist)
        })
        task.resume()
        dispatch_semaphore_wait(semaphore_memlist, DISPATCH_TIME_FOREVER)
        
    }
    
    func loadFromData(data : NSData?) {
        // Now create a NSDictionary from the JSON data
        do {
            if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                let array : Array<NSDictionary> = jsonDictionary["members"]! as! Array<NSDictionary>
                for dict in array {
                    // Create a new Location object for each one and initialise it with information in the dictionary
                    let member = RHSCMember(fromJSONDictionary:dict )
                    // Add the Location object to the array
                    memberDict[member.name!.lowercaseString ] = member
                    memberList.append(member)
                }
                isLoaded = (self.memberList.count != 0);
//                memberList.append(RHSCMember(fromName: "TBD", fromType: "Active"))
//                memberList.append(RHSCMember(fromName: "GUEST", fromType: "Active"))
            }
        } catch {
            print(error)
        }
    }
    
    func find(member name : String) -> RHSCMember? {
        return memberDict[name]
    }
    
    func loadedSuccessfully() -> Bool
    {
        return isLoaded;
    }
    
    
}
