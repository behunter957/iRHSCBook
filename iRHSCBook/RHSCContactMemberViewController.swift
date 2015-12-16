//
//  RHSCContactMemberViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-10.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class RHSCContactMemberViewController : UIViewController, UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    @IBOutlet var formTable: UITableView!
    
    var member : RHSCMember? = nil
    
    var memName : RHSCLabelTableViewCell? = nil
    var emailAddr : RHSCLabelTableViewCell? = nil
    var phone1 : RHSCLabelTableViewCell? = nil
    var phone2 : RHSCLabelTableViewCell? = nil

    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    
    override func viewDidLoad() {
        
//        self.tableView.accessibilityIdentifier = "MemberDetail"
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        memName = formTable.dequeueReusableCellWithIdentifier("Member Title Cell") as? RHSCLabelTableViewCell
        if (memName == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            memName = nib[0] as? RHSCLabelTableViewCell
        }
        memName!.configure(member!.fullName!)
        memName!.selectionStyle = .None
        
        emailAddr = formTable.dequeueReusableCellWithIdentifier("Email Cell") as? RHSCLabelTableViewCell
        if (emailAddr == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            emailAddr = nib[1] as? RHSCLabelTableViewCell
        }
        emailAddr!.configure(member!.email!)
        emailAddr!.selectionStyle = .None
        
        phone1 = formTable.dequeueReusableCellWithIdentifier("Telephone Cell") as? RHSCLabelTableViewCell
        if (phone1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            phone1 = nib[2] as? RHSCLabelTableViewCell
        }
        phone1!.configure(member!.phone1!)
        phone1!.selectionStyle = .None
        
        phone2 = formTable.dequeueReusableCellWithIdentifier("Alt Phone Cell") as? RHSCLabelTableViewCell
        if (phone2 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            phone2 = nib[3] as? RHSCLabelTableViewCell
        }
        phone2!.configure(member!.phone2!)
        phone2!.selectionStyle = .None
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch  indexPath.row {
        case 0:
            return memName!
        case 1:
            return emailAddr!
        case 2:
            return phone1!
        case 3:
            return phone2!
        default:
            return memName!
        }
    }
    
    @IBAction func contactMember() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Contact Method", preferredStyle: .ActionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                    self.emailMember()
        })
        let phone1Action = UIAlertAction(title: "Call Primary Number", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.phone1Member()
        })
        let sms1Action = UIAlertAction(title: "Text Primary Number", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.sms1Member()
        })
        let phone2Action = UIAlertAction(title: "Call Alternate Number", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.phone2Member()
        })
        let sms2Action = UIAlertAction(title: "Text Alternate Number", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.sms2Member()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
        })
        if member!.email != "" {
            optionMenu.addAction(emailAction)
        }
        if member!.phone1 != "" {
            optionMenu.addAction(phone1Action)
            optionMenu.addAction(sms1Action)
        }
        if member!.phone2 != "" {
            optionMenu.addAction(phone2Action)
            optionMenu.addAction(sms2Action)
        }
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }

    
    func emailMember() {
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
    
    func phone1Member() {
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
    
    func phone2Member() {
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
    
    func sms1Member() {
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
    
    func sms2Member() {
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
    
}
