//
//  RHSCBookCourtViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-11-06.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

class RHSCBookCourtViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, playerButtonDelegateProtocol {
    @IBOutlet var formTable: UITableView!
    
    var ct : RHSCCourtTime? = nil
    var user : RHSCUser? = nil
    
    var s1r0 : RHSCLabelTableViewCell? = nil
    var s1r1 : RHSCLabelTableViewCell? = nil
    var s1r2 : RHSCLabelTableViewCell? = nil
    var s2r0 : RHSCButtonTableViewCell? = nil
    var s2r1 : RHSCButtonTableViewCell? = nil
    var s2r2 : RHSCButtonTableViewCell? = nil
    var s2r3 : RHSCButtonTableViewCell? = nil
    var s3r0 : RHSCPickerTableViewCell? = nil
    var s3r1 : RHSCTextTableViewCell? = nil
    
    var cells : Array<Array<UITableViewCell?>> = []
    var delegate : AnyObject? = nil

    var player2Member : RHSCMember? = nil
    var player3Member : RHSCMember? = nil
    var player4Member : RHSCMember? = nil

    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    override func viewDidLoad() {
        
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
        let timeFormat = NSDateFormatter()
        timeFormat.dateFormat = "h:mm a"
        // create the cells
        s1r0 = formTable.dequeueReusableCellWithIdentifier("Court Title Cell") as? RHSCLabelTableViewCell
        if (s1r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r0 = nib[0] as? RHSCLabelTableViewCell
        }
        s1r0?.configure(ct!.court)
        s1r1 = formTable.dequeueReusableCellWithIdentifier("Date Cell") as? RHSCLabelTableViewCell
        if (s1r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r1 = nib[1] as? RHSCLabelTableViewCell
        }
        s1r1?.configure(dateFormat.stringFromDate(ct!.courtTime!))
        s1r2 = formTable.dequeueReusableCellWithIdentifier("Time Cell") as? RHSCLabelTableViewCell
        if (s1r2 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s1r2 = nib[2] as? RHSCLabelTableViewCell
        }
        s1r2?.configure(timeFormat.stringFromDate(ct!.courtTime!))
        s2r0 = formTable.dequeueReusableCellWithIdentifier("Player 1 Cell") as? RHSCButtonTableViewCell
        if (s2r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r0 = nib[3] as? RHSCButtonTableViewCell
        }
        s2r0?.configure(self,buttonNum: 1,buttonText: user!.buttonText())
        s2r1 = formTable.dequeueReusableCellWithIdentifier("Player 2 Cell") as? RHSCButtonTableViewCell
        if (s2r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s2r1 = nib[4] as? RHSCButtonTableViewCell
        }
        s2r1?.configure(self,buttonNum: 2,buttonText: "TBD")
        if ct!.court == "Court 5" {
            s2r2 = formTable.dequeueReusableCellWithIdentifier("Player 3 Cell") as? RHSCButtonTableViewCell
            if (s2r2 == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                s2r2 = nib[5] as? RHSCButtonTableViewCell
            }
            s2r2?.configure(self,buttonNum: 3,buttonText: "TBD")
            s2r3 = formTable.dequeueReusableCellWithIdentifier("Player 4 Cell") as? RHSCButtonTableViewCell
            if (s2r3 == nil) {
                let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
                s2r3 = nib[6] as? RHSCButtonTableViewCell
            }
            s2r3?.configure(self,buttonNum: 4,buttonText: "TBD")
        }
        s3r0 = formTable.dequeueReusableCellWithIdentifier("Type Cell") as? RHSCPickerTableViewCell
        if (s3r0 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r0 = nib[7] as? RHSCPickerTableViewCell
        }
        s3r0?.configure()
        s3r1 = formTable.dequeueReusableCellWithIdentifier("Desc Cell") as? RHSCTextTableViewCell
        if (s3r1 == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed("RHSCBookCourtTableViewCell", owner: self, options: nil)
            s3r1 = nib[8] as? RHSCTextTableViewCell
        }
        s3r1?.configure("")

        if ct?.court == "Court 5" {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1, s2r2, s2r3],[s3r0, s3r1]]
        } else {
            cells = [[s1r0, s1r1, s1r2],[s2r0, s2r1],[s3r0, s3r1]]
        }
        
        for sect in cells {
            for myview in sect {
                myview?.selectionStyle = .None
            }
        }
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return cells.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return cells[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cells[indexPath.section][indexPath.row]!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0: return "Coordinates"
//        case 1: return "Players"
//        case 2: return "Event"
//        default: return ""
//        }
        return nil
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.grayColor()
        let txtView = view as! UITableViewHeaderFooterView
        txtView.textLabel?.textColor = UIColor.blackColor()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func didClickOnPlayerButton(sender: RHSCButtonTableViewCell?, buttonIndex: Int) {
        let tbc = self.tabBarController as! RHSCTabBarController
        let ml = tbc.memberList
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Player", preferredStyle: .ActionSheet)
        let memberAction = UIAlertAction(title: "Member", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
//                print("Member")
                switch buttonIndex {
                case 2:
                    self.performSegueWithIdentifier("ChoosePlayer2", sender: self)
                    break
                case 3:
                    self.performSegueWithIdentifier("ChoosePlayer3", sender: self)
                    break
                case 4:
                    self.performSegueWithIdentifier("ChoosePlayer4", sender: self)
                    break
                default:
                    break
                }
        })
        let guestAction = UIAlertAction(title: "Guest", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                //                print("Guest")
                let alert = UIAlertController(title: "Identify Guest", message: "Enter the name of your Guest:", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default,
                    handler: {(thisAction: UIAlertAction) in
                        let textField = alert.textFields![0]
                        self.ct!.players[buttonIndex] = RHSCGuest(withGuestName: textField.text)
                        self.setPlayer(self.ct!.players[buttonIndex], number: UInt16(buttonIndex))
                } ))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,
                    handler: nil))
                alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Guest name:"
                    textField.text = self.ct!.players[buttonIndex] is RHSCGuest ? (self.ct!.players[buttonIndex] as! RHSCGuest).guestName : ""
                })
                self.presentViewController(alert, animated: true, completion: nil)
        })
        let TBDAction = UIAlertAction(title: "TBD", style: .Default, handler:
            {
                (alert: UIAlertAction!) -> Void in
//                print("TBD")
                switch buttonIndex {
                case 2:
                    self.ct!.players[2] = ml?.TBD
                    self.s2r1?.updateButtonText("TBD")
                    break
                case 3:
                    self.ct!.players[3] = ml?.TBD
                    self.s2r2?.updateButtonText("TBD")
                    break
                case 4:
                    self.ct!.players[4] = ml?.TBD
                    self.s2r3?.updateButtonText("TBD")
                    break
                default:
                    break
                }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
//                print("TBD")
        })
        optionMenu.addAction(memberAction)
        optionMenu.addAction(guestAction)
        optionMenu.addAction(TBDAction)
        optionMenu.addAction(cancelAction)
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }

    func setPlayer(setPlayer : RHSCMember?, number: UInt16) {
        //    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
        ct!.players[Int(number)] = setPlayer
        if number == 2 {
            s2r1?.updateButtonText(setPlayer!.buttonText())
        }
        if number == 3 {
            s2r2?.updateButtonText(setPlayer!.buttonText())
        }
        if number == 4 {
            s2r3?.updateButtonText(setPlayer!.buttonText())
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        ct!.unlock(fromView: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChoosePlayer2" {
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 2
        }
        if segue.identifier == "ChoosePlayer3" {
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 3
        }
        if segue.identifier == "ChoosePlayer4" {
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 4
        }
    }
    
    @IBAction func book() {
        //    NSLog(@"booking singles court and exiting ReserveSingles");
        self.ct!.event = self.s3r0?.eventType?.text
        self.ct!.book(fromView: self)
        self.ct!.unlock(fromView: self)
        //    [self.navigationController popViewControllerAnimated:YES];
    }

}