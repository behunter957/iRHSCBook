//
//  RHSCReserveSinglesViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-30.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

protocol reserveSinglesProtocol {

    func refreshTable()

}

class RHSCReserveSinglesViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,NSFileManagerDelegate,UIAlertViewDelegate {
    
    @IBOutlet weak var typePicker : UIPickerView? = nil
    
    @IBOutlet weak var player2Control : UISegmentedControl? = nil
    
    @IBOutlet weak var eventType : UITextField? = nil
    
    @IBOutlet weak var cancelButton : UIButton? = nil
    @IBOutlet weak var bookButton : UIButton? = nil
    @IBOutlet weak var courtDate : UILabel? = nil
    @IBOutlet weak var userLabel : UILabel? = nil
    
    var typeList : Array<String> = []
    var courtTimeRecord : RHSCCourtTime? = nil
    
    var delegate : AnyObject? = nil
    
    var player2Member : RHSCMember? = nil
    var successAlert : UIAlertView? = nil
    var errorAlert : UIAlertView? = nil
    var guest2 : RHSCGuest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tbc = self.tabBarController as! RHSCTabBarController
        self.userLabel!.text = String.init(format: "%@ %@", arguments: [tbc.currentUser!.data!.firstName!, tbc.currentUser!.data!.lastName!])
    
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d - h:mm a"
        self.courtDate!.text = dateFormat.stringFromDate(self.courtTimeRecord!.courtTime)
    
        self.typeList = ["Friendly","Ladder","MNHL","Lesson","Tournament"]
    
        var courtType = "Front"
        if (self.courtTimeRecord!.court == "Court 1") || (self.courtTimeRecord!.court == "Court 2") {
            courtType = "Back"
        }
        self.navigationItem.title = String.init(format: "Book %@ %@",
            arguments: [courtType,self.courtTimeRecord!.court])
        self.player2Control!.selectedSegmentIndex = 1
        self.guest2 = RHSCGuest()
    
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
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
    
    @IBAction func playerClicked(sender:AnyObject?) {
        //    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
        let tbc = self.tabBarController as! RHSCTabBarController
        if (self.player2Control!.selectedSegmentIndex == 0) {
            self.player2Control!.selectedSegmentIndex = -1
            self.performSegueWithIdentifier("SinglesPlayer2", sender: self)
        }
        if (self.player2Control!.selectedSegmentIndex == 1) {
            self.player2Member = tbc.memberList!.TBD
        }
        if (self.player2Control!.selectedSegmentIndex == 2) {
            self.player2Member = tbc.memberList!.GUEST
            self.performSegueWithIdentifier("SinglesGuest2", sender: self)
        }
        self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
    }
    
    func setPlayer(setPlayer : RHSCMember?, number: UInt16) {
        //    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
        self.player2Member = setPlayer;
        let newTitle = String.init(format: "%@ %@", arguments: [setPlayer!.firstName!,setPlayer!.lastName!])
        self.player2Control?.setTitle(newTitle, forSegmentAtIndex: 0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "SinglesPlayer2" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCFindMemberViewController).delegate = self
            (segue.destinationViewController as! RHSCFindMemberViewController).playerNumber = 2
        }
        if segue.identifier == "SinglesGuest2" {
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCGuestDetailsViewController).delegate = self
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guest = self.guest2
            (segue.destinationViewController as! RHSCGuestDetailsViewController).guestNumber = 2
        }
    }
    
    func setGuest(guest:RHSCGuest?, number:UInt16) {
        //    NSLog(@"setGuest %@",guestNumber);
        let tbc = self.tabBarController as! RHSCTabBarController
        if guest!.name == "" {
            self.player2Member = tbc.memberList!.TBD
            self.player2Control!.selectedSegmentIndex = 1
        }
        self.guest2 = guest
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
            (self.player2Member != nil ? self.player2Member!.name : "")!,"","",
            tbc.currentUser!.data!.name!,"iPhone",
            self.guest2!.name,self.guest2!.phone,self.guest2!.email,
            "","","",
            "","","",
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

