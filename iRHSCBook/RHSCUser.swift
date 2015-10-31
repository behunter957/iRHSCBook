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
        let session = NSURLSession.sharedSession()
        var semaphore = dispatch_semaphore_create(0)
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
            dispatch_semaphore_signal(semaphore)
        })
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)

    }

    
        
//        let logonURL : String = String.init(format: "Reserve20/IOSUserLogonJSON.php?uid=%@&pwd=%@", uid,pwd)
//        let target = NSURL(string:logonURL, relativeToURL:server)
//        let request = NSURLRequest(URL:target!,
//            cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
//            timeoutInterval:30.0)
//        // Get the data
//        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
//        // Sending Synchronous request using NSURLConnection
//        let responseData = try NSURLConnection.sendSynchronousRequest(request,returningResponse: response) as NSData
//        let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(responseData,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
//
//            // Get an array of dictionaries with the key "locations"
//        let array : Array<NSDictionary> = jsonDictionary["user"]! as! Array<NSDictionary>
//            // Iterate through the array of dictionaries
//        for dict in array {
//            loggedOn = true
//            // Create a new Location object for each one and initialise it with information in the dictionary
//            return RHSCMember(fromJSONDictionary:dict )
//        }
//        return nil
//    }
    
    func isLoggedOn() -> Bool {
        return RHSCUser.loggedOn;
    }
    

    
}