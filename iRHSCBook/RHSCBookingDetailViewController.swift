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
        
//        self.tableView.accessibilityIdentifier = "MyBookingDetail"
        
        let tbc = tabBarController as! RHSCTabBarController
    
        user = tbc.currentUser
    
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        courtAndTime!.text = String.init(format: "%@ for %@", arguments: [(booking?.court)!,dtFormatter.string(from: (booking?.courtTime)! as Date)])

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        booking!.unlock(fromView: self)
    }
    
    func findPlayer(_ playerId : String, inList memList: RHSCMemberList) -> RHSCMember?{
        for mem in memList.memberList {
            if (mem.name == playerId){
                return mem;
            }
        }
        return nil;
    }

    @IBAction func cancelBooking(_ sender : AnyObject?) {
        booking!.cancel(fromView: self)
        booking!.unlock(fromView: self)
    }
    
    @IBAction func emailPlayers(_ sender: AnyObject) {
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
            self.present(mc, animated: true, completion: nil)
        } else {
            self.errorAlert = UIAlertController(title: "Error",
                message: "Cannot email from this device", preferredStyle: .alert)
            self.present(self.errorAlert!, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.errorAlert!.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case MFMailComposeResult.cancelled:
            //            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResult.saved:
            //            NSLog(@"Mail saved");
            break;
        case MFMailComposeResult.sent:
            //            NSLog(@"Mail sent");
            break;
        case MFMailComposeResult.failed:
            //            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
        }
    
        // Close the Mail Interface
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func smsPlayers(_ sender: AnyObject) {
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
                                        .components(separatedBy: CharacterSet(charactersIn: "0123456789-+()")
                                            .inverted).joined(separator: "")
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
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResult.cancelled:
            //			NSLog(@"Cancelled");
            break;
        case MessageComposeResult.failed:
            self.errorAlert = UIAlertController(title: "Error",
                message: "Cannot message from this device", preferredStyle: .alert)
            self.present(self.errorAlert!, animated: true, completion: nil)
            let delay = 2.0 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.errorAlert!.dismiss(animated: true, completion: nil)
            })
            break;
        case MessageComposeResult.sent:
            break;
        default:
            break;
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
