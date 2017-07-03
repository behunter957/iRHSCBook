//
//  RHSCMemberList.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
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
        let url = URL(string: "Reserve20/IOSMemberListJSON.php", relativeTo: server as URL )
        //        print(url!.absoluteString)
//        let sessionCfg = NSURLSession.sharedSession().configuration
//        sessionCfg.timeoutIntervalForResource = 30.0
//        let session = NSURLSession(configuration: sessionCfg)
        let session = URLSession.shared
        let semaphore_memlist = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                self.loadFromData(data)
            }
            semaphore_memlist.signal()
        })
        task.resume()
        _ = semaphore_memlist.wait(timeout: DispatchTime.distantFuture)
        
    }
    
    func loadFromData(_ data : Data?) {
        // Now create a NSDictionary from the JSON data
        do {
            if let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                let array = jsonDictionary["members"]! as! Array<[String : Any]>
                for dict in array {
                    // Create a new Location object for each one and initialise it with information in the dictionary
                    let member = RHSCMember(fromJSONDictionary:dict )
                    // Add the Location object to the array
                    memberDict[member.name!.lowercased() ] = member
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
