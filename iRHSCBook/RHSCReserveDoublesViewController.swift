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

class RHSCReserveDoublesViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

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
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
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
            self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
        }
        if (self.player2Control!.selectedSegmentIndex == 2) {
            self.player2Member = tbc.memberList!.GUEST
            self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
            self.performSegueWithIdentifier("DoublesGuest2", sender: self)
        }
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
            self.player3Control!.setTitle("Select Member", forSegmentAtIndex: 0)
        }
        if (self.player3Control!.selectedSegmentIndex == 2) {
            self.player3Member = tbc.memberList!.GUEST
            self.player3Control!.setTitle("Select Member", forSegmentAtIndex: 0)
            self.performSegueWithIdentifier("DoublesGuest3", sender: self)
        }
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
            self.player4Control!.setTitle("Select Member", forSegmentAtIndex: 0)
        }
        if (self.player4Control!.selectedSegmentIndex == 2) {
            self.player4Member = tbc.memberList!.GUEST
            self.player4Control!.setTitle("Select Member", forSegmentAtIndex: 0)
            self.performSegueWithIdentifier("DoublesGuest4", sender: self)
        }
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
        let url = NSURL(string: String.init(format: "Reserve20/IOSUnlockBookingJSON.php?bookingId=%@",
            arguments: [self.courtTimeRecord!.bookingId!]),
            relativeToURL: tbc.server )
        //        print(url!.absoluteString)
        //        let sessionCfg = NSURLSession.sharedSession().configuration
        //        sessionCfg.timeoutIntervalForResource = 30.0
        //        let session = NSURLSession(configuration: sessionCfg)
        let session  = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
            }
        })
        task.resume()
    }
    
    
    func bookCourt() {
        let tbc = self.tabBarController as! RHSCTabBarController
        let url = NSURL(string: String.init(format: "Reserve20/IOSUpdateBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@&g2name=%@&g2phone=%@&g2email=%@&g3name=%@&g3phone=%@&g3email=%@&g4name=%@&g4phone=%@&g4email=%@&courtEvent=%@",
            arguments: [self.courtTimeRecord!.bookingId!,
                tbc.currentUser!.data!.name!,
                (self.player2Member != nil ? self.player2Member!.name : "")!,
                (self.player3Member != nil ? self.player3Member!.name : "")!,
                (self.player4Member != nil ? self.player4Member!.name : "")!,
                tbc.currentUser!.data!.name!,"iPhone",
                self.guest2!.name,self.guest2!.phone,self.guest2!.email,
                self.guest3!.name,self.guest3!.phone,self.guest3!.email,
                self.guest4!.name,self.guest4!.phone,self.guest4!.email,
                self.eventType!.text!]),
                relativeToURL: tbc.server )
        //        NSLog(@"fetch URL = %@",fetchURL);
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                self.errorAlert = UIAlertController(title: "Error",
                    message: "Unable to book the court", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                        let delay = 5.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            } else if data != nil {
                //                    print("received data")
                let jsonDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                //                print(jsonDictionary)
                if jsonDictionary["error"] == nil {
                    self.successAlert = UIAlertController(title: "Success",
                        message: "Court time successfully booked. Notices will be sent to all players", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // do some task
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(self.successAlert!, animated: true, completion: nil)
                            let delay = 5.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                } else {
                    self.errorAlert = UIAlertController(title: "Error",
                        message: "Unable to book the court", preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // do some task
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                            let delay = 5.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
               }
            } else {
                self.errorAlert = UIAlertController(title: "Error",
                    message: "Unable to book the court", preferredStyle: .Alert)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                        let delay = 5.0 * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        dispatch_after(time, dispatch_get_main_queue(), {
                            self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                    })
                })
            }
        })
        task.resume()
        
    }
    
}
