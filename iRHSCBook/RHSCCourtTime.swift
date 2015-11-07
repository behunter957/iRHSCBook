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
    var players : Dictionary<String,String> = Dictionary<String,String>()
    
    func nullToString(value:AnyObject?) -> String? {
        if value is NSNull {
            return nil
        } else {
            return value as! String?
        }
    }

    init(withJSONDictionary jsonDictionary:NSDictionary, forUser userId:String) {
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
        bookedForUser = false;
        if let player1_id = nullToString(jsonDictionary["player1_id"]) {
            if (player1_id == userId) {
                bookedForUser = true;
            }
            if let player1_lname = nullToString(jsonDictionary["player1_lname"]) {
                players.updateValue(player1_id, forKey: "player1_id")
                players.updateValue(player1_lname, forKey: "player1_lname")
            } else {
                players.updateValue("", forKey: "player1_id")
                players.updateValue("", forKey: "player1_lname")
            }
        } else {
            players.updateValue("", forKey: "player1_id")
            players.updateValue("", forKey: "player1_lname")
        }
        if let player2_id = nullToString(jsonDictionary["player2_id"]) {
            if (player2_id == userId) {
                bookedForUser = true;
            }
            if let player2_lname = nullToString(jsonDictionary["player2_lname"]) {
                players.updateValue(player2_id, forKey: "player2_id")
                players.updateValue(player2_lname, forKey: "player2_lname")
            } else {
                players.updateValue("", forKey: "player2_id")
                players.updateValue("", forKey: "player2_lname")
            }
        } else {
            players.updateValue("", forKey: "player2_id")
            players.updateValue("", forKey: "player2_lname")
        }
        if let player3_id = nullToString(jsonDictionary["player3_id"]) {
            if (player3_id == userId) {
                bookedForUser = true;
            }
            if let player3_lname = nullToString(jsonDictionary["player3_lname"]) {
                players.updateValue(player3_id, forKey: "player3_id")
                players.updateValue(player3_lname, forKey: "player3_lname")
            } else {
                players.updateValue("", forKey: "player3_id")
                players.updateValue("", forKey: "player3_lname")
            }
        } else {
            players.updateValue("", forKey: "player3_id")
            players.updateValue("", forKey: "player3_lname")
        }
        if let player4_id = nullToString(jsonDictionary["player4_id"]) {
            if (player4_id == userId) {
                bookedForUser = true;
            }
            if let player4_lname = nullToString(jsonDictionary["player4_lname"]) {
                players.updateValue(player4_id, forKey: "player4_id")
                players.updateValue(player4_lname, forKey: "player4_lname")
            } else {
                players.updateValue("", forKey: "player4_id")
                players.updateValue("", forKey: "player4_lname")
            }
        } else {
            players.updateValue("", forKey: "player4_id")
            players.updateValue("", forKey: "player4_lname")
        }
    }
    
}