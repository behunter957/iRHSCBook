//
//  RHSCCourtTime.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation

@objc class RHSCCourtTime : NSObject {
 
    var bookingId : String
    var court : String
    var courtTime : NSDate
    var status : String
    var event : String
    var bookedForUser : Bool
    var players : Dictionary<String,String> = Dictionary<String,String>()

    init(withJSONDictionary jsonDictionary:NSDictionary, forUser userId:String) {
        // Assign all properties with keyed values from the dictionary
        bookingId = jsonDictionary["booking_id"]! as! String
        court = jsonDictionary["court"]! as! String
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        courtTime = dateFormat.dateFromString(String.init(format: "%@ %@", arguments:
            [ jsonDictionary["courtdate"]! as! String, jsonDictionary["courttime"]! as! String ]))!
        status = jsonDictionary["courtStatus"]! as! String
        event = jsonDictionary["courtEvent"]! as! String
        bookedForUser = false;
        if (jsonDictionary["player1_id"] != nil) {
            if (jsonDictionary["player1_id"]!.isEqualToString(userId)) {
                bookedForUser = true;
            }
            if (jsonDictionary["player1_lname"] != nil) {
                players.updateValue(jsonDictionary["player1_id"]! as! String, forKey: "player1_id")
                players.updateValue(jsonDictionary["player1_lname"]! as! String, forKey: "player1_lname")
            } else {
                players.updateValue("", forKey: "player1_id")
                players.updateValue("", forKey: "player1_lname")
            }
        } else {
            players.updateValue("", forKey: "player1_id")
            players.updateValue("", forKey: "player1_lname")
        }
        if (jsonDictionary["player2_id"] != nil) {
            if (jsonDictionary["player2_id"]!.isEqualToString(userId)) {
                bookedForUser = true;
            }
            if (jsonDictionary["player2_lname"] != nil) {
                players.updateValue(jsonDictionary["player2_id"]! as! String, forKey: "player2_id")
                players.updateValue(jsonDictionary["player2_lname"]! as! String, forKey: "player2_lname")
            } else {
                players.updateValue("", forKey: "player2_id")
                players.updateValue("", forKey: "player2_lname")
            }
        } else {
            players.updateValue("", forKey: "player2_id")
            players.updateValue("", forKey: "player2_lname")
        }
        if (jsonDictionary["player3_id"] != nil) {
            if (jsonDictionary["player3_id"]!.isEqualToString(userId)) {
                bookedForUser = true;
            }
            if (jsonDictionary["player3_lname"] != nil) {
                players.updateValue(jsonDictionary["player3_id"]! as! String, forKey: "player3_id")
                players.updateValue(jsonDictionary["player3_lname"]! as! String, forKey: "player3_lname")
            } else {
                players.updateValue("", forKey: "player3_id")
                players.updateValue("", forKey: "player3_lname")
            }
        } else {
            players.updateValue("", forKey: "player3_id")
            players.updateValue("", forKey: "player3_lname")
        }
        if (jsonDictionary["player4_id"] != nil) {
            if (jsonDictionary["player4_id"]!.isEqualToString(userId)) {
                bookedForUser = true;
            }
            if (jsonDictionary["player4_lname"] != nil) {
                players.updateValue(jsonDictionary["player4_id"]! as! String, forKey: "player4_id")
                players.updateValue(jsonDictionary["player4_lname"]! as! String, forKey: "player4_lname")
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