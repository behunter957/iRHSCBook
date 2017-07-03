//
//  RHSCUser.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation

@objc class RHSCUser : RHSCMember {
    
    static var loggedOn : Bool = false
    var userid : String? = nil
    var password : String? = nil

    init( forUserid uid : String, forPassword pwd : String) {
        userid = uid;
        password = pwd;
        super.init(name: userid!)
    }
    
    func validate(fromServer server:RHSCServer) -> Bool {
        
//        print(server.absoluteString)
        let url = URL(string: String.init(format: "Reserve20/IOSUserLogonJSON.php?uid=%@&pwd=%@", arguments: [userid!, password!]), relativeTo: server as URL )
//        print(url!.absoluteString)
        let sessionCfg = URLSession.shared.configuration
//        sessionCfg.timeoutIntervalForResource = 30.0
        let session = URLSession(configuration: sessionCfg)
        let semaphore_logon = DispatchSemaphore(value: 0)
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription)")
            } else if data != nil {
//                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                do {
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] {
                        if let array = jsonDictionary["user"]! as? Array<[String : Any]> {
                            for dict in array {
                                RHSCUser.loggedOn = true
                                // Create a new Location object for each one and initialise it with information in the dictionary
                                
                                self.assign(fromJSONDictionary: dict)
                            }
                        } else {
                            print("user not found")
                        }
                    } else {
                        print("response was not JSON")
                    }
                } catch {
                    print(error)
                }
            }
            semaphore_logon.signal()
        })
        task.resume()
        _ = semaphore_logon.wait(timeout: DispatchTime.distantFuture)
        return RHSCUser.loggedOn
    }
    
    func isLoggedOn() -> Bool {
        return RHSCUser.loggedOn;
    }
    

    
}
