//
//  RHSCReserveDoublesViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

protocol reserveDoublesProtocol {

    func refreshTable()

}

class RHSCReserveDoublesViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate {

    @IBOutlet weak var typePicker : UIPickerView? = nil
    @IBOutlet weak var player2Control : UISegmentedControl? = nil
    @IBOutlet weak var player3Control : UISegmentedControl? = nil
    @IBOutlet weak var player4Control : UISegmentedControl? = nil
    
    @IBOutlet weak var eventType : UITextField? = nil
    
    @IBOutlet weak var cancelButton : UIButton? = nil
    @IBOutlet weak var bookButton : UIButton? = nil
    @IBOutlet weak var courtDate : UILabel? = nil
    @IBOutlet weak var userLabel : UILabel? = nil
    var typeList : Array<String> = []
    var courtTimeRecord : RHSCCourtTime? = nil
    
    var delegate : AnyObject? = nil
    
    var player2Member : RHSCMember? = nil
    var player3Member : RHSCMember? = nil
    var player4Member : RHSCMember? = nil
    var successAlert : UIAlertView? = nil
    var errorAlert : UIAlertView? = nil
    var guest2 : RHSCGuest? = nil
    var guest3 : RHSCGuest? = nil
    var guest4 : RHSCGuest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.typeList = ["Friendly","Ladder","Lesson","Tournament"]
        let tbc = self.tabBarController as! RHSCTabBarController
        self.userLabel!.text = String.init(format: "%@ %@",
            arguments: [tbc.currentUser!.data!.firstName!,tbc.currentUser!.data!.lastName!])
        self.player2Control!.selectedSegmentIndex = 1
        self.player3Control!.selectedSegmentIndex = 1
        self.player4Control!.selectedSegmentIndex = 1
        self.guest2 = RHSCGuest()
        self.guest3 = RHSCGuest()
        self.guest4 = RHSCGuest()
    
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unlockBooking()
        //    [delegate refreshTable];
    }

    @IBAction func cancel() {
        //    NSLog(@"exiting ReserveSingles");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func book() {
        //    NSLog(@"booking singles court and exiting ReserveSingles");
        self.bookCourt()
        //    [self.navigationController popViewControllerAnimated:YES];
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.typeList.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.typeList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.eventType!.text = self.typeList[row];
        self.eventType?.resignFirstResponder()
    }
    
    @IBAction func player2Clicked(sender:AnyObject?) {
        //    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
        let tbc = self.tabBarController as! RHSCTabBarController
        if (self.player2Control!.selectedSegmentIndex == 0) {
            self.player2Control!.selectedSegmentIndex = -1
            self.performSegueWithIdentifier("DoublesPlayer2", sender: self)
        }
        if (self.player2Control!.selectedSegmentIndex == 1) {
            self.player2Member = tbc.memberList!.TBD
        }
        if (self.player2Control!.selectedSegmentIndex == 2) {
            self.player2Member = tbc.memberList!.GUEST
            self.performSegueWithIdentifier("DoublesGuest2", sender: self)
        }
        self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
    }
    
    @IBAction func player3Clicked(sender:AnyObject?) {
        //    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
        let tbc = self.tabBarController as! RHSCTabBarController
        if (self.player3Control!.selectedSegmentIndex == 0) {
            self.player3Control!.selectedSegmentIndex = -1
            self.performSegueWithIdentifier("DoublesPlayer3", sender: self)
        }
        if (self.player3Control!.selectedSegmentIndex == 1) {
            self.player3Member = tbc.memberList!.TBD
        }
        if (self.player3Control!.selectedSegmentIndex == 2) {
            self.player3Member = tbc.memberList!.GUEST
            self.performSegueWithIdentifier("DoublesGuest3", sender: self)
        }
        self.player3Control!.setTitle("Select Member", forSegmentAtIndex: 0)
    }
    
    @IBAction func player4Clicked(sender:AnyObject?) {
        //    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
        let tbc = self.tabBarController as! RHSCTabBarController
        if (self.player4Control!.selectedSegmentIndex == 0) {
            self.player4Control!.selectedSegmentIndex = -1
            self.performSegueWithIdentifier("DoublesPlayer4", sender: self)
        }
        if (self.player4Control!.selectedSegmentIndex == 1) {
            self.player4Member = tbc.memberList!.TBD
        }
        if (self.player4Control!.selectedSegmentIndex == 2) {
            self.player4Member = tbc.memberList!.GUEST
            self.performSegueWithIdentifier("DoublesGuest4", sender: self)
        }
        self.player4Control!.setTitle("Select Member", forSegmentAtIndex: 0)
    }
    
    func setPlayer(setPlayer : RHSCMember?, number: UInt16) {
        //    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
        let newTitle = String.init(format: "%@ %@", arguments: [setPlayer!.firstName!,setPlayer!.lastName!])
        if number == 2 {
            self.player2Member = setPlayer
            self.player2Control?.setTitle(newTitle, forSegmentAtIndex: 0)
        }
        if number == 3 {
            self.player3Member = setPlayer
            self.player3Control?.setTitle(newTitle, forSegmentAtIndex: 0)
        }
        if number == 4 {
            self.player4Member = setPlayer
            self.player4Control?.setTitle(newTitle, forSegmentAtIndex: 0)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new  view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "DoublesPlayer2" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 2
        }
        if segue.identifier == "DoublesGuest2" {
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCGuestDetailsViewController).delegate = self
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guest = self.guest2
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guestNumber = 2
        }
        if segue.identifier == "DoublesPlayer3" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 3
        }
        if segue.identifier == "DoublesGuest3" {
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCGuestDetailsViewController).delegate = self
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guest = self.guest3
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guestNumber = 3
        }
        if segue.identifier == "DoublesPlayer4" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 4
        }
        if segue.identifier == "DoublesGuest4" {
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCGuestDetailsViewController).delegate = self
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guest = self.guest4
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guestNumber = 4
        }
    }
    
    func setGuest(guest:RHSCGuest?, number:UInt16) {
        //    NSLog(@"setGuest %@",guestNumber);
        let tbc = self.tabBarController as! RHSCTabBarController
        if number == 2 {
            if guest!.name == "" {
                self.player2Member = tbc.memberList!.TBD
                self.player2Control!.selectedSegmentIndex = 1
            }
            self.guest2 = guest
        }
        if number == 3 {
            if guest!.name == "" {
                self.player3Member = tbc.memberList!.TBD
                self.player3Control!.selectedSegmentIndex = 1
            }
            self.guest3 = guest
        }
        if number == 4 {
            if guest!.name == "" {
                self.player4Member = tbc.memberList!.TBD
                self.player4Control!.selectedSegmentIndex = 1
            }
            self.guest4 = guest
        }
    }
    
    func unlockBooking() {
        let tbc = self.tabBarController as! RHSCTabBarController
        let fetchURL = String.init(format: "Reserve20/IOSUnlockBookingJSON.php?bookingId=%@",
            arguments: [self.courtTimeRecord!.bookingId])
        //        NSLog(@"fetch URL = %@",fetchURL);
        let target = NSURL.init(string: fetchURL, relativeToURL: tbc.server!)
        let request = NSURLRequest.init(URL: target!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        try! NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
    }
    
    
    func bookCourt() {
        let tbc = self.tabBarController as! RHSCTabBarController
        let fetchURL = String.init(format: "Reserve20/IOSUpdateBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@&g2name=%@&g2phone=%@&g2email=%@&g3name=%@&g3phone=%@&g3email=%@&g4name=%@&g4phone=%@&g4email=%@&courtEvent=%@",
            arguments: [self.courtTimeRecord!.bookingId,
                tbc.currentUser!.data!.name!,
                (self.player2Member != nil ? self.player2Member!.name : "")!,
                (self.player3Member != nil ? self.player3Member!.name : "")!,
                (self.player4Member != nil ? self.player4Member!.name : "")!,
                tbc.currentUser!.data!.name!,"iPhone",
                self.guest2!.name,self.guest2!.phone,self.guest2!.email,
                self.guest3!.name,self.guest3!.phone,self.guest3!.email,
                self.guest4!.name,self.guest4!.phone,self.guest4!.email,
                self.eventType!.text!])
        //        NSLog(@"fetch URL = %@",fetchURL);
        let target = NSURL.init(string: fetchURL, relativeToURL: tbc.server!)
        let request = NSURLRequest.init(URL: target!, cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30.0)
        // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        let data = try! NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
        if response != nil {
            //TODO handle error in locking
            let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if jsonDictionary["error"] == nil {
                successAlert = UIAlertView(title: "Success",
                    message: "Court time successfully booked. Notices will be sent to all players",
                    delegate: self,
                    cancelButtonTitle: "OK",
                    otherButtonTitles: "", "")
                successAlert!.show()
            } else {
                let alert = UIAlertView(title: "Error",
                    message: jsonDictionary["error"] as! String,
                    delegate: self,
                    cancelButtonTitle: "OK",
                    otherButtonTitles: "", "")
                alert.show()
            }
            // check for an error return
        } else {
            let alert = UIAlertView(title: "Network error",
                message: "Unable to book the court",
                delegate: self,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView == self.successAlert) {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
        
}