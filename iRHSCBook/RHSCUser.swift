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

    init( forUserid uid : String, forPassword pwd : String) {
        super.init()
        userid = uid;
        password = pwd;
    }
    
    func validate(fromServer server:RHSCServer) {
//        print(server.absoluteString)
        let url = NSURL(string: String.init(format: "Reserve20/IOSUserLogonJSON.php?uid=%@&pwd=%@", arguments: [userid!, password!]), relativeToURL: server )
//        print(url!.absoluteString)
        let sessionCfg = NSURLSession.sharedSession().configuration
//        sessionCfg.timeoutIntervalForResource = 30.0
        let session = NSURLSession(configuration: sessionCfg)
        let semaphore_logon = dispatch_semaphore_create(0)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
//                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                do {
                    if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        let array : Array<NSDictionary> = jsonDictionary["user"]! as! Array<NSDictionary>
                        for dict in array {
                            RHSCUser.loggedOn = true
                            // Create a new Location object for each one and initialise it with information in the dictionary
                            self.data = RHSCMember(fromJSONDictionary:dict )
                        }
                    }
                } catch {
                    print(error)
                }
            }
            dispatch_semaphore_signal(semaphore_logon)
        })
        task.resume()
        dispatch_semaphore_wait(semaphore_logon, DISPATCH_TIME_FOREVER)

    }
    
    func isLoggedOn() -> Bool {
        return RHSCUser.loggedOn;
    }
    

    
}