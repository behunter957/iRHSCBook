//
//  RHSCBookingDetailViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-28.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
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
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

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
        
        player1 = booking?.players[1]
        if (player1 != nil) {
            player1Label!.text = player1!.fullName
        } else {
            player1Label!.text = ""
        }
        
        player2 = booking?.players[2]
        if (player2 != nil) {
            player2Label!.text = player2!.fullName
        } else {
            player2Label!.text = ""
        }
        
        if (booking!.court == "Court 5") {
            player3 = booking?.players[3]
            if (player3Label != nil) {
                player3Label!.text = player3!.fullName
            } else {
                player3Label!.text = ""
            }
            player4 = booking?.players[4]
            if (player4Label != nil) {
                player4Label!.text = player4!.fullName
            } else {
                player4Label!.text = ""
            }
        }
        self.view.backgroundColor = UIColor.bookedBlue()
    }
    
    func findPlayer(playerId : String, inList memList: RHSCMemberList) -> RHSCMember?{
        for mem in memList.memberList {
            if (mem.name == playerId){
                return mem;
            }
        }
        return nil;
    }

    @IBAction func cancelBooking(sender : AnyObject?) {
        booking!.cancel(fromView: self)
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
            let toRecipents = [booking!.players[1]!.name!,
                booking!.players[2]!.name!,
                booking!.players[3]!.name!,
                booking!.players[4]!.name!]
            var emailAddresses = Array<String>()
            for playerId in toRecipents {
                for mem in ml!.memberList {
                    if (mem.name == playerId) {
                        if (mem.email != nil) {
                            if (mem.email != "NULL") {
                                if (mem.name != tbc.currentUser!.name) {
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
            self.errorAlert = UIAlertController(title: "Error",
                message: "Cannot email from this device", preferredStyle: .Alert)
            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
            })
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
            let toRecipents = [booking!.players[1]!.name!,
                booking!.players[2]!.name!,
                booking!.players[3]!.name!,
                booking!.players[4]!.name!]
            var phoneNumbers = Array<String>()
            for playerId in toRecipents {
                for mem in ml!.memberList {
                    if (mem.name == playerId) {
                        if (mem.email != nil) {
                            if (mem.email != "NULL") {
                                if (mem.name != tbc.currentUser!.name) {
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
            self.errorAlert = UIAlertController(title: "Error",
                message: "Cannot message from this device", preferredStyle: .Alert)
            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
            })
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
