//
//  RHSCCourtTime.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCCourtTime : NSObject {
 
    var bookingId : String? = nil
    var court : String? = nil
    var courtTime : NSDate? = nil
    var status : String? = nil
    var event : String? = nil
    var eventDesc : String? = nil
    var bookedForUser : Bool = false
    var players = Dictionary<Int,RHSCMember>()
    
    func nullToString(value:AnyObject?) -> String? {
        if value is NSNull {
            return nil
        } else {
            return value as! String?
        }
    }

    init(withJSONDictionary jsonDictionary:NSDictionary, forUser userId:String, members:RHSCMemberList) {
        super.init()
        // Assign all properties with keyed values from the dictionary
        bookingId = nullToString(jsonDictionary["booking_id"])
        court = nullToString(jsonDictionary["court"])
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        courtTime = dateFormat.dateFromString(String.init(format: "%@ %@", arguments:
            [ nullToString(jsonDictionary["courtdate"])!, nullToString(jsonDictionary["courttime"])! ]))!
        status = nullToString(jsonDictionary["courtStatus"])
        event = nullToString(jsonDictionary["courtEvent"])
        eventDesc = nullToString(jsonDictionary["eventDesc"])
        let ml = members.memberDict
        bookedForUser = false;
        if let player1_id = nullToString(jsonDictionary["player1_id"]) {
            if (player1_id == userId) {
                bookedForUser = true;
            }
            players[1] = ml[player1_id]
        }
        if let player2_id = nullToString(jsonDictionary["player2_id"]) {
            if (player2_id == userId) {
                bookedForUser = true;
            }
            if player2_id == "TBD" {
                players[2] = members.TBD
            } else if player2_id == "Guest" {
                players[2] = members.GUEST
            } else {
                players[1] = ml[player2_id]
            }
        }
        if let player3_id = nullToString(jsonDictionary["player3_id"]) {
            if (player3_id == userId) {
                bookedForUser = true;
            }
            if player3_id == "TBD" {
                players[3] = members.TBD
            } else if player3_id == "Guest" {
                players[3] = members.GUEST
            } else {
                players[3] = ml[player3_id]
            }
        }
        if let player4_id = nullToString(jsonDictionary["player4_id"]) {
            if (player4_id == userId) {
                bookedForUser = true;
            }
            if player4_id == "TBD" {
                players[4] = members.TBD
            } else if player4_id == "Guest" {
                players[4] = members.GUEST
            } else {
                players[4] = ml[player4_id]
            }
        }
    }
    
}