//
//  RHSCMember.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-20.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation

@objc class RHSCMember : NSObject {
    
    var name : String? = nil
    var email : String? = nil
    var phone1 : String? = nil
    var phone2 : String? = nil
    var type : String? = nil
    var status : String? = nil
    var firstName : String? = nil
    var lastName : String? = nil
    var sortName : String? = nil
    var fullName : String? = nil
    
    override init() {
        super.init()
    }

    init(fromJSONDictionary jsonDictionary : NSDictionary) {
        // Assign all properties with keyed values from the dictionary
        name  = jsonDictionary["id"] as! String?
        firstName  = jsonDictionary["fname"] as! String?
        lastName  = jsonDictionary["lname"] as! String?
        email  = jsonDictionary["email"] as! String?
        phone1  = jsonDictionary["primary_phone"] as! String?
        phone2  = jsonDictionary["home_phone"] as! String?
        status  = jsonDictionary["status"] as! String?
        type  = jsonDictionary["member_type"] as! String?
        if firstName != "" {
            if lastName != "" {
                sortName = "\(lastName!), \(firstName!)"
                fullName = "\(firstName!) \(lastName!)"
            } else {
                sortName = firstName!
                fullName = firstName!
            }
        } else {
            if lastName != "" {
                sortName = lastName!
                fullName = lastName!
            } else {
                sortName = "Unknown"
                fullName = "Unknown"
            }
        }
    }
    
    init(fromName name : String, fromType type : String) {
        self.name  = name
        firstName  = ""
        lastName  = name
        if firstName != "" {
            if lastName != "" {
                sortName = "\(lastName!), \(firstName!)"
                fullName = "\(firstName!) \(lastName!)"
            } else {
                sortName = firstName!
                fullName = firstName!
            }
        } else {
            if lastName != "" {
                sortName = lastName!
                fullName = lastName!
            } else {
                sortName = ""
                fullName = ""
            }
        }
        email  = ""
        phone1  = ""
        phone2  = ""
        status  = "Active"
        self.type  = type
    }
    
    init(name : String) {
        self.name  = name
        firstName  = ""
        lastName  = name
        if firstName != "" {
            if lastName != "" {
                sortName = "\(lastName!), \(firstName!)"
                fullName = "\(firstName!) \(lastName!)"
            } else {
                sortName = firstName!
                fullName = firstName!
            }
        } else {
            if lastName != "" {
                sortName = lastName!
                fullName = lastName!
            } else {
                sortName = "Unknown"
                fullName = "Unknown"
            }
        }
        email  = ""
        phone1  = ""
        phone2  = ""
        status  = "Active"
        self.type  = "Single"
    }
    
    func assign(fromJSONDictionary jsonDictionary : NSDictionary) {
        // Assign all properties with keyed values from the dictionary
        name  = jsonDictionary["id"] as! String?
        firstName  = jsonDictionary["fname"] as! String?
        lastName  = jsonDictionary["lname"] as! String?
        email  = jsonDictionary["email"] as! String?
        phone1  = jsonDictionary["primary_phone"] as! String?
        phone2  = jsonDictionary["home_phone"] as! String?
        status  = jsonDictionary["status"] as! String?
        type  = jsonDictionary["member_type"] as! String?
        if firstName != "" {
            if lastName != "" {
                sortName = "\(lastName!), \(firstName!)"
                fullName = "\(firstName!) \(lastName!)"
            } else {
                sortName = firstName!
                fullName = firstName!
            }
        } else {
            if lastName != "" {
                sortName = lastName!
                fullName = lastName!
            } else {
                sortName = "Unknown"
                fullName = "Unknown"
            }
        }
    }
    
    func buttonText() -> String {
        return fullName!
    }
}