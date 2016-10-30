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
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        memName = formTable.dequeueReusableCell(withIdentifier: "Member Title Cell") as? RHSCLabelTableViewCell
        if (memName == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            memName = nib?[0] as? RHSCLabelTableViewCell
        }
        memName!.configure(member!.fullName!)
        memName!.selectionStyle = .none
        
        emailAddr = formTable.dequeueReusableCell(withIdentifier: "Email Cell") as? RHSCLabelTableViewCell
        if (emailAddr == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            emailAddr = nib?[1] as? RHSCLabelTableViewCell
        }
        emailAddr!.configure(member!.email!)
        emailAddr!.selectionStyle = .none
        
        phone1 = formTable.dequeueReusableCell(withIdentifier: "Telephone Cell") as? RHSCLabelTableViewCell
        if (phone1 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            phone1 = nib?[2] as? RHSCLabelTableViewCell
        }
        phone1!.configure(member!.phone1!)
        phone1!.selectionStyle = .none
        
        phone2 = formTable.dequeueReusableCell(withIdentifier: "Alt Phone Cell") as? RHSCLabelTableViewCell
        if (phone2 == nil) {
            let nib = Bundle.main.loadNibNamed("RHSCContactMemberTableViewCell", owner: self, options: nil)
            phone2 = nib?[3] as? RHSCLabelTableViewCell
        }
        phone2!.configure(member!.phone2!)
        phone2!.selectionStyle = .none
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch  (indexPath as NSIndexPath).row {
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
        let optionMenu = UIAlertController(title: nil, message: "Choose Contact Method", preferredStyle: .actionSheet)
        let emailAction = UIAlertAction(title: "Email", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                    self.emailMember()
        })
        let phone1Action = UIAlertAction(title: "Call Primary Number", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.phone1Member()
        })
        let sms1Action = UIAlertAction(title: "Text Primary Number", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.sms1Member()
        })
        let phone2Action = UIAlertAction(title: "Call Alternate Number", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.phone2Member()
        })
        let sms2Action = UIAlertAction(title: "Text Alternate Number", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                self.sms2Member()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:
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
        self.present(optionMenu, animated: true, completion: nil)
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
            self.present(mc, animated: true, completion: nil)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot email from this device", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.errorAlert!.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    func phone1Member() {
        //    NSLog(@"Phoning using number 1");
        let cleanedString = member!.phone1!
            .components(separatedBy: CharacterSet(charactersIn: "0123456789-+()")
                .inverted).joined(separator: "")
        let phoneNumber = String.init(format: "telprompt://%@", arguments: [cleanedString])
        if (UIApplication.shared.canOpenURL(URL(string:phoneNumber)!)) {
            UIApplication.shared.openURL(URL(string:phoneNumber)!)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot phone from this device", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.errorAlert!.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    func phone2Member() {
        //    NSLog(@"Phoning using number 2");
        let cleanedString = member!.phone2!
            .components(separatedBy: CharacterSet(charactersIn: "0123456789-+()")
                .inverted).joined(separator: "")
        let phoneNumber = String.init(format: "telprompt://%@", arguments: [cleanedString])
        if (UIApplication.shared.canOpenURL(URL(string:phoneNumber)!)) {
            UIApplication.shared.openURL(URL(string:phoneNumber)!)
        } else {
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot phone from this device", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.errorAlert!.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    func sms1Member() {
        let controller = MFMessageComposeViewController()
        //    NSLog(@"Sending SMS using number 1");
        let cleanedString = member!.phone1!
            .components(separatedBy: CharacterSet(charactersIn: "0123456789-+()")
                .inverted).joined(separator: "")
        if(MFMessageComposeViewController.canSendText()) {
            controller.body = ""
            controller.recipients = Array<String>([cleanedString])
            controller.messageComposeDelegate = self;
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func sms2Member() {
        let controller = MFMessageComposeViewController()
        //    NSLog(@"Sending SMS using number 1");
        let cleanedString = member!.phone2!
            .components(separatedBy: CharacterSet(charactersIn: "0123456789-+()")
                .inverted).joined(separator: "")
        if(MFMessageComposeViewController.canSendText()) {
            controller.body = ""
            controller.recipients = Array<String>([cleanedString])
            controller.messageComposeDelegate = self;
            self.present(controller, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResult.cancelled:
            //			NSLog(@"Cancelled");
            break;
        case MessageComposeResult.failed:
            self.errorAlert = UIAlertController(title: "Unavailable",
                message: "Cannot SMS from this device", preferredStyle: .alert)
            DispatchQueue.global().async(execute: {
                // do some task
                DispatchQueue.main.async(execute: {
                    self.present(self.errorAlert!, animated: true, completion: nil)
                    let delay = 2.0 * Double(NSEC_PER_SEC)
                    let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time, execute: {
                        self.errorAlert!.dismiss(animated: true, completion: nil)
                    })
                })
            })
            break;
        case MessageComposeResult.sent:
            break;
        }
        dismiss(animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch (result) {
        case MFMailComposeResult.cancelled:
            break;
        case MFMailComposeResult.saved:
            break;
        case MFMailComposeResult.sent:
            break;
        case MFMailComposeResult.failed:
            break;
        }
        
        // Close the Mail Interface
        dismiss(animated: true, completion: nil)
    }
    
}
