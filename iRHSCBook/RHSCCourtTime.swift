//
//  RHSCCourtTime.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-25.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

@objc class RHSCCourtTime : NSObject {
 
    var bookingId : String? = nil
    var court : String? = nil
    var courtTime : NSDate? = nil
    var courtDateStr : String? = nil
    var courtTimeStr : String? = nil
    var status : String? = nil
    var event : String? = nil
    var eventDesc : String? = nil
    var bookedForUser : Bool = false
    var summary : String? = nil
    var players = Dictionary<Int,RHSCMember>()
    var isNoShow : Bool = false

    func nullToString(value:AnyObject?) -> String? {
        if value is NSNull {
            return ""
        } else {
            return value as! String?
        }
    }

    init(withJSONDictionary jsonDictionary:NSDictionary, forUser userId:String, members:RHSCMemberList) {
        super.init()
        // Assign all properties with keyed values from the dictionary
        bookingId = nullToString(jsonDictionary["booking_id"])
        court = nullToString(jsonDictionary["court"])
        courtDateStr = nullToString(jsonDictionary["courtdate"])
        courtTimeStr = nullToString(jsonDictionary["courttime"])
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        courtTime = dateFormat.dateFromString(String.init(format: "%@ %@", arguments:
            [ courtDateStr!, courtTimeStr! ]))!
        status = nullToString(jsonDictionary["courtStatus"])
        event = nullToString(jsonDictionary["courtEvent"])
        eventDesc = nullToString(jsonDictionary["eventDesc"])
        isNoShow = (nullToString(jsonDictionary["noshow"]) == "true")
        let ml = members.memberDict
        bookedForUser = false;
        let player1_id = nullToString(jsonDictionary["player1_id"])
        let player2_id = nullToString(jsonDictionary["player2_id"])
        let player3_id = nullToString(jsonDictionary["player3_id"])
        let player4_id = nullToString(jsonDictionary["player4_id"])
        let g2name = nullToString(jsonDictionary["g2_name"])
        let g3name = nullToString(jsonDictionary["g3_name"])
        let g4name = nullToString(jsonDictionary["g4_name"])
        if ["School","Clinic","RoundRobin","T&D"].contains(event!) {
            players[1] = members.EMPTY
            players[2] = members.EMPTY
            players[3] = members.EMPTY
            players[4] = members.EMPTY
            summary = String.init(format: "%@ - %@",arguments: [event!,eventDesc!])
        } else if ["MNHL","Tournament"].contains(event!) {
            players[1] = player1_id == "" ? members.EMPTY : (player1_id == "TBD" ? members.TBD :  ml[player1_id!.lowercaseString])
            players[2] = player2_id == "" ? members.EMPTY : (player2_id == "TBD" ? members.TBD :
                (player2_id == "Guest" ? RHSCGuest(withGuestName: g2name) : ml[player2_id!.lowercaseString]))
            players[3] = player3_id == "" ? members.EMPTY : (player3_id == "TBD" ? members.TBD :
                (player3_id == "Guest" ? RHSCGuest(withGuestName: g3name) : ml[player3_id!.lowercaseString]))
            players[4] = player4_id == "" ? members.EMPTY : (player4_id == "TBD" ? members.TBD :
                (player4_id == "Guest" ? RHSCGuest(withGuestName: g4name) : ml[player4_id!.lowercaseString]))
            bookedForUser = (player1_id == userId) || (player2_id == userId) || (player3_id == userId) || (player4_id == userId)
            if court == "Court 5" {
                if (player1_id == "") || (player2_id == "") || (player3_id == "") || (player4_id == "") {
                    summary = String.init(format: "%@ - %@",
                        arguments: [event!,eventDesc!])
                } else {
                    summary = String.init(format: "%@ - %@,%@,%@,%@",
                        arguments: [event!,
                            players[1]!.lastName!,
                            players[2]!.lastName!,
                            players[3]!.lastName!,
                            players[4]!.lastName! ])
                }
            } else {
                // if players 3 and 4 remained TBD for singles court they would be auto-cancelled
                players[3] = player3_id == "TBD" ? members.EMPTY : players[3]
                players[3] = player3_id == "TBD" ? members.EMPTY : players[3]
                if (player1_id == "") || (player2_id == "") {
                    summary = String.init(format: "%@ - %@",
                        arguments: [event!,eventDesc!])
                } else {
                    summary = String.init(format: "%@ - %@,%@",
                        arguments: [event!,
                            players[1]!.lastName!,
                            players[2]!.lastName! ])
                }
            }
        } else {
            bookedForUser = (player1_id == userId) || (player2_id == userId) || (player3_id == userId) || (player4_id == userId)
            if (player1_id == "TBD") || (player1_id == "") {
                players[1] = members.TBD
            } else {
                players[1] = ml[player1_id!.lowercaseString]
            }
            if (player2_id == "TBD") || (player2_id == "") {
                players[2] = members.TBD
            } else if player2_id == "Guest" {
                players[2] = RHSCGuest(withGuestName: g2name)
            } else {
                players[2] = ml[player2_id!.lowercaseString]
            }
            if (player3_id == "TBD") || (player3_id == "") {
                players[3] = members.TBD
            } else if player3_id == "Guest" {
                players[3] = RHSCGuest(withGuestName: g3name)
            } else {
                players[3] = ml[player3_id!.lowercaseString]
            }
            if (player4_id == "TBD") || (player4_id == "") {
                players[4] = members.TBD
            } else if player4_id == "Guest" {
                players[4] = RHSCGuest(withGuestName: g4name)
            } else {
                players[4] = ml[player4_id!.lowercaseString]
            }
            if court == "Court 5" {
                summary = String.init(format: "%@ - %@,%@,%@,%@",
                    arguments: [event!,
                        players[1]!.lastName!,
                        players[2]!.lastName!,
                        players[3]!.lastName!,
                        players[4]!.lastName! ])
            } else {
                // if players 3 and 4 remained TBD for singles court they would be auto-cancelled
                players[3] = player3_id == "TBD" ? members.EMPTY : players[3]
                players[3] = player3_id == "TBD" ? members.EMPTY : players[3]
                summary = String.init(format: "%@ - %@,%@",
                    arguments: [event!,
                        players[1]!.lastName!,
                        players[2]!.lastName! ])
            }
        }
   }
    
    func book(fromView view: UIViewController) {
        var successAlert : UIAlertController? = nil
        var errorAlert : UIAlertController? = nil
        
        let tbc = view.tabBarController as! RHSCTabBarController
        let g2name = players[2] is RHSCGuest ? (players[2] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let g3name = players[3] is RHSCGuest ? (players[3] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let g4name = players[4] is RHSCGuest ? (players[4] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let pl2 = (players[2] != nil ? players[2]?.name : "")!
        let pl3 = court == "Court 5" ? (players[3] != nil ? players[3]?.name : "")! : ""
        let pl4 = court == "Court 5" ? (players[4] != nil ? players[4]?.name : "")! : ""
        let urlstr = String.init(format: "Reserve20/IOSBookCourtJSON.php?booking_id=%@&player1_id=%@&player2_id=%@&player3_id=%@&player4_id=%@&uid=%@&channel=%@&guest2=%@&guest3=%@&guest4=%@&channel=%@&court=%@&courtEvent=%@&reserved=false",
            arguments: [bookingId!,
                tbc.currentUser!.name!, pl2, pl3, pl4,
                tbc.currentUser!.name!,"iPhone", g2name!, g3name!, g4name!,
                "iPhone", court!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
                event!])
        //        print(urlstr)
        let url = NSURL(string: urlstr, relativeToURL: tbc.server )
        //        NSLog(@"fetch URL = %@",fetchURL);
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                errorAlert = UIAlertController(title: "Unable to Book Court",
                    message: "Error: \(error!.localizedDescription)", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        view.presentViewController(errorAlert!, animated: true, completion: nil)
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            view.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            } else {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                if (statusCode == 200) && (data != nil) {
                    let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    if jsonDictionary["error"] == nil {
                        successAlert = UIAlertController(title: "Success",
                            message: "Court time successfully booked. Notices will be sent to all players", preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(successAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    } else {
                        errorAlert = UIAlertController(title: "Unable to Book Court",
                            message: jsonDictionary["error"] as! String?, preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(errorAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    }
                } else {
                    errorAlert = UIAlertController(title: "Unable to Book Court",
                        message: "Error (status code \(statusCode))", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        dispatch_async(dispatch_get_main_queue(), {
                            view.presentViewController(errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                view.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                }
            }
        })
        task.resume()
        
    }

    
    func update(fromView view:UIViewController) {
        var successAlert : UIAlertController? = nil
        var errorAlert : UIAlertController? = nil

        let tbc = view.tabBarController as! RHSCTabBarController
        let g2name = players[2] is RHSCGuest ? (players[2] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let g3name = players[3] is RHSCGuest ? (players[3] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let g4name = players[4] is RHSCGuest ? (players[4] as! RHSCGuest).guestName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) : ""
        let pl2 = (players[2] != nil ? players[2]?.name : "")!
        let pl3 = court == "Court 5" ? (players[3] != nil ? players[3]?.name : "")! : ""
        let pl4 = court == "Court 5" ? (players[4] != nil ? players[4]?.name : "")! : ""
        let urlstr = String.init(format: "Reserve20/IOSUpdateBookingJSON.php?booking_id=%@&player1_id=%@&player2_id=%@&player3_id=%@&player4_id=%@&uid=%@&channel=%@&guest2=%@&guest3=%@&guest4=%@&channel=%@&court=%@&courtEvent=%@&reserved=false",
            arguments: [bookingId!,
                tbc.currentUser!.name!, pl2, pl3, pl4,
                tbc.currentUser!.name!,"iPhone", g2name!, g3name!, g4name!,
                "iPhone", (court)!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
                event!])
        //        print(urlstr)
        let url = NSURL(string: urlstr, relativeToURL: tbc.server )
        //        NSLog(@"fetch URL = %@",fetchURL);
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                errorAlert = UIAlertController(title: "Unable to Update Booking",
                    message: "Error: \(error!.localizedDescription)", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        view.presentViewController(errorAlert!, animated: true, completion: nil)
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            view.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            } else {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                if (statusCode == 200) && (data != nil) {
                    let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    if jsonDictionary["error"] == nil {
                        successAlert = UIAlertController(title: "Success",
                            message: "Booking successfully updated. Notices will be sent to all players", preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(successAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    } else {
                        errorAlert = UIAlertController(title: "Unable to Update Booking",
                            message: jsonDictionary["error"] as! String?, preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(errorAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    }
                } else {
                    errorAlert = UIAlertController(title: "Unable to Update Booking",
                        message: "Error (status code \(statusCode))", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        dispatch_async(dispatch_get_main_queue(), {
                            view.presentViewController(errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                view.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                }
            }
        })
        task.resume()
    }

    func cancel(fromView view: UIViewController) {
        var successAlert : UIAlertController? = nil
        var errorAlert : UIAlertController? = nil
        
        let tbc = view.tabBarController as! RHSCTabBarController
        let fetchURL = String.init(format: "Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",
            arguments: [bookingId!, (tbc.currentUser?.name)!,players[2]!.name!,
                players[3]!.name!,players[4]!.name!,
                (tbc.currentUser?.name)!,"iPhone"])
        
        let url = NSURL(string: fetchURL, relativeToURL: tbc.server )
        //        print(url!.absoluteString)
        let sessionCfg = NSURLSession.sharedSession().configuration
        sessionCfg.timeoutIntervalForResource = 30.0
        let session = NSURLSession(configuration: sessionCfg)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                    message: "Error: \(error!.localizedDescription)", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        view.presentViewController(errorAlert!, animated: true, completion: nil)
                        let delay = 2.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            view.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            } else {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                if (statusCode == 200) && (data != nil) {
                    let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    if jsonDictionary["error"] == nil {
                        successAlert = UIAlertController(title: "Success",
                            message: "Booking successfully cancelled. Notices will be sent to all players", preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(successAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    } else {
                        errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                            message: jsonDictionary["error"] as! String?, preferredStyle: .Alert)
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            dispatch_async(dispatch_get_main_queue(), {
                                view.presentViewController(errorAlert!, animated: true, completion: nil)
                                let delay = 2.0 * Double(NSEC_PER_SEC)
                                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                                dispatch_after(time, dispatch_get_main_queue(), {
                                    errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                    view.navigationController?.popViewControllerAnimated(true)
                                })
                            })
                        })
                    }
                } else {
                    errorAlert = UIAlertController(title: "Unable to Cancel Booking",
                        message: "Error (status code \(statusCode))", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        dispatch_async(dispatch_get_main_queue(), {
                            view.presentViewController(errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                view.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                }
            }
        })
        task.resume()
    }

    
}