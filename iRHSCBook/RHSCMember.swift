//
//  RHSCMember.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-20.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCMember : NSObject {
    
    var name : String = ""
    var email : String = ""
    var phone1 : String = ""
    var phone2 : String = ""
    var type : String = ""
    var status : String = ""
    var firstName : String = ""
    var lastName : String = ""

    init(fromJSONDictionary jsonDictionary : NSDictionary) {
        // Assign all properties with keyed values from the dictionary
        name  = jsonDictionary["id"]! as! String
        firstName  = jsonDictionary["fname"]! as! String
        lastName  = jsonDictionary["lname"]! as! String
        email  = jsonDictionary["email"]! as! String
        phone1  = jsonDictionary["primary_phone"]! as! String
        phone2  = jsonDictionary["home_phone"]! as! String
        status  = jsonDictionary["status"]! as! String
        type  = jsonDictionary["member_type"]! as! String
    }
    
    init(fromName name : String,fromType type : String) {
        self.name  = name;
        firstName  = name;
        lastName  = name;
        email  = "";
        phone1  = "";
        phone2  = "";
        status  = "Active";
        self.type  = type;
    }
}