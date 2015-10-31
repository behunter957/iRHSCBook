//
//  RHSCBookingDetailViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-28.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import MessageUI

protocol cancelBookingProtocol {

    func refreshTable()
}

class RHSCBookingDetailViewController : UIViewController,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate {

    @IBOutlet weak var courtAndTime : UILabel? = nil
    @IBOutlet weak var eventLabel : UILabel? = nil
    @IBOutlet weak var player1Label : UILabel? = nil
    @IBOutlet weak var player2Label : UILabel? = nil
    @IBOutlet weak var player3Label : UILabel? = nil
    @IBOutlet weak var player4Label : UILabel? = nil

    var user : RHSCUser? = nil
    var booking : RHSCCourtTime? = nil
    
    var delegate : cancelBookingProtocol? = nil
    
    var player1 : RHSCMember? = nil
    var player2 : RHSCMember? = nil
    var player3 : RHSCMember? = nil
    var player4 : RHSCMember? = nil
    var successAlert : UIAlertView? = nil
    var errorAlert : UIAlertView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // obtain players
        let tbc = tabBarController as! RHSCTabBarController
    
        user = tbc.currentUser
    
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        courtAndTime!.text = String.init(format: "%@ for %@", arguments: [(booking?.court)!,dtFormatter.stringFromDate((booking?.courtTime)!)])

        eventLabel!.text = String.init(format: "%@ match between:", arguments: [(booking?.event)!])
        
        player1 = findPlayer("player1_id",inList: tbc.memberList!)
        if (player1 != nil) {
            player1Label!.text = String.init(format: "%@ %@", arguments: [player1!.firstName!,player1!.lastName!])
        } else {
            player1Label!.text = ""
        }
        
        player2 = findPlayer("player2_id",inList: tbc.memberList!)
        if (player2 != nil) {
            player2Label!.text = String.init(format: "%@ %@", arguments: [player2!.firstName!,player2!.lastName!])
        } else {
            player2Label!.text = ""
        }
        
        if (booking!.court == "Court 5") {
            player3 = findPlayer("player3_id",inList: tbc.memberList!)
            if (player3Label != nil) {
                player3Label!.text = String.init(format: "%@ %@", arguments: [player3!.firstName!,player3!.lastName!])
            } else {
                player3Label!.text = ""
            }
            player4 = findPlayer("player4_id",inList: tbc.memberList!)
            if (player4Label != nil) {
                player4Label!.text = String.init(format: "%@ %@", arguments: [player4!.firstName!,player4!.lastName!])
            } else {
                player4Label!.text = ""
            }
        }
    }
    
    func findPlayer(playerId : String, inList memList: RHSCMemberList) -> RHSCMember?{
        for mem in memList.memberList {
            if (mem.name == playerId){
                return mem;
            }
        }
        return nil;
    }

    @IBAction func cancelBooking(sender : AnyObject) throws {
        let tbc = tabBarController as! RHSCTabBarController
        var fetchURL : String? = nil;
        if (booking!.court == "Court 5") {
            fetchURL = String.init(format: "Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",
                arguments: [booking!.bookingId, (tbc.currentUser?.data?.name)!,booking!.players["player2_id"]!,
                    booking!.players["player3_id"]!,booking!.players["player4_id"]!,
                    (tbc.currentUser?.data?.name)!,"iPhone"])
            
        } else {
            fetchURL = String.init(format:"Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",[booking!.bookingId,
                (tbc.currentUser?.data?.name)!,
                booking!.players["player2_id"]!,"","",
                    (tbc.currentUser?.data?.name)!,"iPhone"])
        }
    
        //    NSLog(@"fetch URL = %@",fetchURL);
        let target = NSURL(string:fetchURL!, relativeToURL:tbc.server)
        let request = NSURLRequest(URL:target!,
            cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval:30.0)
        // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        // Sending Synchronous request using NSURLConnection
        let data = try NSURLConnection.sendSynchronousRequest(request,returningResponse: response) as NSData
        let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        if (jsonDictionary["error"] == nil) {
            // Get an array of dictionaries with the key "locations"
            // NSArray *array = [jsonDictionary objectForKey:@"user"];
            //            NSLog(@"%@",jsonDictionary);
            let alert = UIAlertView(title: "Success",
                message: "Booking successfully cancelled. Notices will be sent to all players",
                delegate: self,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        } else {
            let alert = UIAlertView(title: "Error",
                message: jsonDictionary["error"] as! String,
                delegate: nil,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        }
    }
    
    func alertView(forView alertView:UIAlertView, clickedButtonAtIndex buttonIndex:NSInteger) {
        if (alertView == successAlert) {
            delegate!.refreshTable()
            self.navigationController!.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func emailPlayers(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let tbc = tabBarController as! RHSCTabBarController
            let ml = tbc.memberList
            // Email Subject
            let emailTitle = ""
            // Email Content
            let messageBody = ""
            // To address
            let toRecipents = [booking!.players["player1_id"],
                booking!.players["player2_id"],
                booking!.players["player3_id"],
                booking!.players["player4_id"]]
            var emailAddresses = Array<String>()
            for playerId in toRecipents {
                for mem in ml!.memberList {
                    if (mem.name == playerId) {
                        if (mem.email != nil) {
                            if (mem.email != "NULL") {
                                if (mem.name != tbc.currentUser!.data!.name) {
                                    emailAddresses.append(mem.email!)
                                }
                            }
                        }
                        break;
                    }
                }
            }
    
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self;
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(emailAddresses)
    
            // Present mail view controller on screen
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            let alert = UIAlertView(title: "Cannot send email",
                message: "Cannot email from this device",
                delegate: nil,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case MFMailComposeResultCancelled:
            //            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            //            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            //            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            //            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
        }
    
        // Close the Mail Interface
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func smsPlayers(sender: AnyObject) {
        let tbc = tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        let controller = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            let toRecipents = [booking!.players["player1_id"],
                booking!.players["player2_id"],
                booking!.players["player3_id"],
                booking!.players["player4_id"]]
            var phoneNumbers = Array<String>()
            for playerId in toRecipents {
                for mem in ml!.memberList {
                    if (mem.name == playerId) {
                        if (mem.email != nil) {
                            if (mem.email != "NULL") {
                                if (mem.name != tbc.currentUser!.data!.name) {
                                    let cleanedString = mem.phone1!
                                        .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()")
                                            .invertedSet).joinWithSeparator("")
                                    phoneNumbers.append(cleanedString)
                                }
                            }
                        }
                        break;
                    }
                }
            }
            controller.body = ""
            controller.recipients = phoneNumbers
            controller.messageComposeDelegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            //			NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            let alert = UIAlertView(title: "Cannot send SMS",
                message: "Cannot message from this device",
                delegate: nil,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
