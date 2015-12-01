//
//  RHSCScore.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-29.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCScore : NSObject {
    
    var id : String? = nil
    var matchdate : String? = nil
    var matchtime : String? = nil
    var matchtype : String? = nil
    var matchevent : String? = nil
    var player1_id : String? = nil
    var player1_won : Int? = nil
    var player2_id : String? = nil
    var player2_won : Int? = nil
    var game1p1 : Int? = nil
    var game1p2 : Int? = nil
    var game2p1 : Int? = nil
    var game2p2 : Int? = nil
    var game3p1 : Int? = nil
    var game3p2 : Int? = nil
    var game4p1 : Int? = nil
    var game4p2 : Int? = nil
    var game5p1 : Int? = nil
    var game5p2 : Int? = nil
    var booking_id : String? = nil
    var isTournament : Bool = false
    var isRanked : Bool = false
    var player1_ack : Bool = false
    var player2_ack : Bool = false
    var isLocked : Bool = false
    var updDate : String? = nil
    var player3_id : String? = nil
    var player3_won : Int? = nil
    var player4_id : String? = nil
    var player4_won : Int? = nil
    var t1p1 : String? = nil
    var t2p1 : String? = nil
    var t1p2 : String? = nil
    var t2p2 : String? = nil
    
    var isValid : Bool = false

    override init() {
        super.init()
        
    }
    
    init(fromJSONDictionary jsonDictionary : NSDictionary) {
        // Assign all properties with keyed values from the dictionary
        id           = jsonDictionary["id"] as! String?
        matchdate    = jsonDictionary["matchdate"] as! String?
        matchtime    = jsonDictionary["matchtime"] as! String?
        matchtype    = jsonDictionary["matchtype"] as! String?
        matchevent   = jsonDictionary["matchevent"] as! String?
        player1_id   = jsonDictionary["player1_id"] as! String?
        player1_won  = jsonDictionary["player1_won"] as! Int?
        player2_id   = jsonDictionary["player2_id"] as! String?
        player2_won  = jsonDictionary["player2_won"] as! Int?
        game1p1      = jsonDictionary["game1p1"] as! Int?
        game1p2      = jsonDictionary["game1p2"] as! Int?
        game2p1      = jsonDictionary["game2p1"] as! Int?
        game2p2      = jsonDictionary["game2p2"] as! Int?
        game3p1      = jsonDictionary["game3p1"] as! Int?
        game3p2      = jsonDictionary["game3p2"] as! Int?
        game4p1      = jsonDictionary["game4p1"] as! Int?
        game4p2      = jsonDictionary["game4p2"] as! Int?
        game5p1      = jsonDictionary["game5p1"] as! Int?
        game5p2      = jsonDictionary["game5p2"] as! Int?
        booking_id   = jsonDictionary["booking_id"] as! String?
        isTournament = (jsonDictionary["isTournament"] as! String?) == "true"
        isRanked     = (jsonDictionary["isRanked"] as! String?) == "true"
        player1_ack  = (jsonDictionary["player1_ack"] as! String?) == "true"
        player2_ack  = (jsonDictionary["player2_ack"] as! String?) == "true"
        isLocked     = (jsonDictionary["isLocked"] as! String?) == "true"
        updDate      = jsonDictionary["updDate"] as! String?
        player3_id   = jsonDictionary["player3_id"] as! String?
        player3_won  = jsonDictionary["player3_won"] as! Int?
        player4_id   = jsonDictionary["player4_id"] as! String?
        player4_won  = jsonDictionary["player4_won"] as! Int?
        t1p1         = jsonDictionary["t1p1"] as! String?
        t2p1         = jsonDictionary["t2p1"] as! String?
        t1p2         = jsonDictionary["t1p2"] as! String?                   
        t2p2         = jsonDictionary["t2p2"] as! String?
        isValid = true
    }
    
    init(ct: RHSCCourtTime) {
        id           = nil
        matchdate    = ct.courtDateStr
        matchtime    = ct.courtTimeStr
        matchtype    = ct.event
        matchevent   = ct.eventDesc
        player1_id   = ct.players[1]?.name
        player1_won  = 0
        player2_id   = ct.players[2]?.name
        player2_won  = 0
        game1p1      = 0
        game1p2      = 0
        game2p1      = 0
        game2p2      = 0
        game3p1      = 0
        game3p2      = 0
        game4p1      = 0
        game4p2      = 0
        game5p1      = 0
        game5p2      = 0
        booking_id   = ct.bookingId
        isTournament = ct.event == "Tournament"
        isRanked     = false
        player1_ack  = false
        player2_ack  = false
        isLocked     = false
        updDate      = nil
        player3_id   = ct.players[3]?.name
        player3_won  = 0
        player4_id   = ct.players[4]?.name
        player4_won  = 0
        t1p1         = ct.players[1]?.name
        t2p1         = ct.players[2]?.name
        t1p2         = ct.players[3]?.name
        t2p2         = ct.players[3]?.name
        isValid = true
    }
    
    func assign(fromCourtTime ct: RHSCCourtTime) {
        id           = nil
        matchdate    = ct.courtDateStr
        matchtime    = ct.courtTimeStr
        matchtype    = ct.event
        matchevent   = ct.eventDesc
        player1_id   = ct.players[1]?.name
        player1_won  = 0
        player2_id   = ct.players[2]?.name
        player2_won  = 0
        game1p1      = 0
        game1p2      = 0
        game2p1      = 0
        game2p2      = 0
        game3p1      = 0
        game3p2      = 0
        game4p1      = 0
        game4p2      = 0
        game5p1      = 0
        game5p2      = 0
        booking_id   = ct.bookingId
        isTournament = ct.event == "Tournament"
        isRanked     = false
        player1_ack  = false
        player2_ack  = false
        isLocked     = false
        updDate      = nil
        player3_id   = ct.players[3]?.name
        player3_won  = 0
        player4_id   = ct.players[4]?.name
        player4_won  = 0
        t1p1         = ct.players[1]?.name
        t2p1         = ct.players[2]?.name
        t1p2         = ct.players[3]?.name
        t2p2         = ct.players[3]?.name
        isValid = true
    }
    
    func assign(fromJSONDictionary jsonDictionary : NSDictionary) {
        // Assign all properties with keyed values from the dictionary
        id           = jsonDictionary["id"] as! String?
        matchdate    = jsonDictionary["matchdate"] as! String?
        matchtime    = jsonDictionary["matchtime"] as! String?
        matchtype    = jsonDictionary["matchtype"] as! String?
        matchevent   = jsonDictionary["matchevent"] as! String?
        player1_id   = jsonDictionary["player1_id"] as! String?
        player1_won  = jsonDictionary["player1_won"] as! Int?
        player2_id   = jsonDictionary["player2_id"] as! String?
        player2_won  = jsonDictionary["player2_won"] as! Int?
        game1p1      = jsonDictionary["game1p1"] as! Int?
        game1p2      = jsonDictionary["game1p2"] as! Int?
        game2p1      = jsonDictionary["game2p1"] as! Int?
        game2p2      = jsonDictionary["game2p2"] as! Int?
        game3p1      = jsonDictionary["game3p1"] as! Int?
        game3p2      = jsonDictionary["game3p2"] as! Int?
        game4p1      = jsonDictionary["game4p1"] as! Int?
        game4p2      = jsonDictionary["game4p2"] as! Int?
        game5p1      = jsonDictionary["game5p1"] as! Int?
        game5p2      = jsonDictionary["game5p2"] as! Int?
        booking_id   = jsonDictionary["booking_id"] as! String?
        isTournament = (jsonDictionary["isTournament"] as! String?) == "true"
        isRanked     = (jsonDictionary["isRanked"] as! String?) == "true"
        player1_ack  = (jsonDictionary["player1_ack"] as! String?) == "true"
        player2_ack  = (jsonDictionary["player2_ack"] as! String?) == "true"
        isLocked     = (jsonDictionary["isLocked"] as! String?) == "true"
        updDate      = jsonDictionary["updDate"] as! String?
        player3_id   = jsonDictionary["player3_id"] as! String?
        player3_won  = jsonDictionary["player3_won"] as! Int?
        player4_id   = jsonDictionary["player4_id"] as! String?
        player4_won  = jsonDictionary["player4_won"] as! Int?
        t1p1         = jsonDictionary["t1p1"] as! String?
        t2p1         = jsonDictionary["t2p1"] as! String?
        t1p2         = jsonDictionary["t1p2"] as! String?
        t2p2         = jsonDictionary["t2p2"] as! String?
        isValid = true
    }
    
    func addScore(fromView view:UIViewController) {
        
    }
    
    func updateScore(fromView view:UIViewController) {
        
    }
    
    class func getScores(forCourtTime ct: RHSCCourtTime, fromView view:UIViewController) -> RHSCScore {
        // first make sync call to retrieve the score record
        let scores = RHSCScore()
        let tbc = view.tabBarController as! RHSCTabBarController
        let curUser = tbc.currentUser
        let server = tbc.server
        let url = NSURL(string: String.init(format: "Reserve20/IOSGetScoreJSON.php?b_id=%@&uid=%@",
            arguments: [ct.bookingId!,curUser!.name!]), relativeToURL: server )
        let sessionCfg = NSURLSession.sharedSession().configuration
        let session = NSURLSession(configuration: sessionCfg)
        let semaphore_getscore = dispatch_semaphore_create(0)
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            } else if data != nil {
                //                print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                do {
                    if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        if let array  = jsonDictionary["score"] {
                            for dict in array as! Array<NSDictionary> {
                                RHSCUser.loggedOn = true
                                // Create a new Location object for each one and initialise it with information in the dictionary
                                scores.assign(fromJSONDictionary: dict)
                            }
                        } else {
                            if let _  = jsonDictionary["empty"] {
                                scores.assign(fromCourtTime: ct)
                            } else {
                                print("unexpected response - not JSON")
                            }
                        }
                    } else {
                        print("response was not JSON")
                    }
                } catch {
                    print(error)
                }
            }
            dispatch_semaphore_signal(semaphore_getscore)
        })
        task.resume()
        dispatch_semaphore_wait(semaphore_getscore, DISPATCH_TIME_FOREVER)
        return scores
    }
    
}