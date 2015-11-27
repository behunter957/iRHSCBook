//
//  RHSCGuest.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation

@objc class RHSCGuest : RHSCMember {
    
    var guestName : String = ""
    
    init(withGuestName gName: String?) {
        super.init()
        name = "Guest"
        type = "Single"
        status = "Active"
        guestName = gName!
        firstName = ""
        lastName = "Guest"
        fullName = "Guest"
    }
    
    override func buttonText() -> String {
        return "Guest: \(guestName)"
    }
}