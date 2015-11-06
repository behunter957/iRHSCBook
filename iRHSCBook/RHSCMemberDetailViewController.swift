//
//  RHSCMemberDetailViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-27.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import MessageUI

class RHSCMemberDetailViewController : UIViewController,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var emailLabel : UILabel? = nil
    @IBOutlet weak var phone1Label : UILabel? = nil
    @IBOutlet weak var phone2Label : UILabel? = nil
    @IBOutlet weak var emailBtn : UIButton? = nil
    @IBOutlet weak var ph1SMSBtn : UIButton? = nil
    @IBOutlet weak var ph1CallBtn : UIButton? = nil
    @IBOutlet weak var ph2SMSBtn : UIButton? = nil
    @IBOutlet weak var ph2CallBtn : UIButton? = nil
    
    var errorAlert : UIAlertController? = nil
    
    var member : RHSCMember? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = String.init(format: "%@ %@", arguments: [member!.firstName!,member!.lastName!])
        
        self.emailLabel!.text = ""
        self.emailBtn!.hidden = true
        if ((member!.email) != nil) {
            if (member!.email! != "NULL") {
                self.emailLabel!.text = member!.email!
                self.emailBtn!.hidden = false
            }
        }
        self.phone1Label!.text = ""
        self.ph1SMSBtn!.hidden = true
        self.ph1CallBtn!.hidden = true
        if ((member!.phone1) != nil) {
            if (member!.phone1! != "NULL") {
                self.phone1Label!.text = member!.phone1!
                self.ph1SMSBtn!.hidden = false
                self.ph1CallBtn!.hidden = false
            }
        }
        self.phone2Label!.text = ""
        self.ph2SMSBtn!.hidden = true
        self.ph2CallBtn!.hidden = true
        if ((member!.phone2) != nil) {
            if (member!.phone2! != "NULL") {
                self.phone2Label!.text = member!.phone2!
                self.ph2SMSBtn!.hidden = false
                self.ph2CallBtn!.hidden = false
            }
        }
    }
    
    @IBAction func emailMember(sender: AnyObject) {
        if (MFMailComposeViewController.canSendMail()) {
            // Email Subject
            let emailTitle = ""
            // Email Content
            let messageBody = ""
            // To address
            let toRecipients = Array<String>(arrayLiteral: member!.email!)
    
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients(toRecipients)
    
            // Present mail view controller on screen
            self.presentViewController(mc, animated: true, completion: nil)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot email from this device", preferredStyle: .Alert)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
        }
    
        // Close the Mail Interface
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func phone1Member(sender:AnyObject) {
        //    NSLog(@"Phoning using number 1");
        let cleanedString = member!.phone1!
            .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()")
                .invertedSet).joinWithSeparator("")
        let phoneNumber = String.init(format: "telprompt://%@", arguments: [cleanedString])
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:phoneNumber)!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot phone from this device", preferredStyle: .Alert)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            })
        }
    }
    
    @IBAction func phone2Member(sender:AnyObject) {
        //    NSLog(@"Phoning using number 2");
        let cleanedString = member!.phone2!
            .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()")
                .invertedSet).joinWithSeparator("")
        let phoneNumber = String.init(format: "telprompt://%@", arguments: [cleanedString])
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:phoneNumber)!)) {
            UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot phone from this device", preferredStyle: .Alert)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            })
        }
    }
    
    @IBAction func sms1Member(sender:AnyObject) {
        let controller = MFMessageComposeViewController()
        //    NSLog(@"Sending SMS using number 1");
        let cleanedString = member!.phone1!
            .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()")
                .invertedSet).joinWithSeparator("")
        if(MFMessageComposeViewController.canSendText()) {
            controller.body = ""
            controller.recipients = Array<String>([cleanedString])
            controller.messageComposeDelegate = self;
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func sms2Member(sender:AnyObject) {
        let controller = MFMessageComposeViewController()
        //    NSLog(@"Sending SMS using number 1");
        let cleanedString = member!.phone2!
            .componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789-+()")
                .invertedSet).joinWithSeparator("")
        if(MFMessageComposeViewController.canSendText()) {
            controller.body = ""
            controller.recipients = Array<String>([cleanedString])
            controller.messageComposeDelegate = self;
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            //			NSLog(@"Cancelled");
            break;
        case MessageComposeResultFailed:
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot SMS from this device", preferredStyle: .Alert)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                // do some task
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    dispatch_after(time, dispatch_get_main_queue(), {
                        self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            })
            break;
        case MessageComposeResultSent:
            break;
        default:
            break;
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

}
