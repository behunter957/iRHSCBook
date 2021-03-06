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

class RHSCReserveSinglesViewController : UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,NSFileManagerDelegate {
    
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
    var successAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil
    var guest2 : RHSCGuest? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tbc = self.tabBarController as! RHSCTabBarController
        self.userLabel!.text = tbc.currentUser?.fullName
    
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d - h:mm a"
        self.courtDate!.text = dateFormat.stringFromDate(self.courtTimeRecord!.courtTime!)
    
        self.typeList = ["Friendly","Ladder","MNHL","Lesson","Tournament"]
    
        var courtType = "Front"
        if (self.courtTimeRecord!.court == "Court 1") || (self.courtTimeRecord!.court == "Court 2") {
            courtType = "Back"
        }
        self.navigationItem.title = String.init(format: "Book %@ %@",
            arguments: [courtType,self.courtTimeRecord!.court!])
        self.player2Control!.selectedSegmentIndex = 1
        self.guest2 = RHSCGuest()
    
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        self.eventType!.inputView = picker
        
        self.player2Member = tbc.memberList?.TBD
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
            self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
        }
        if (self.player2Control!.selectedSegmentIndex == 2) {
            self.player2Member = tbc.memberList!.GUEST
            self.player2Control!.setTitle("Select Member", forSegmentAtIndex: 0)
            self.performSegueWithIdentifier("SinglesGuest2", sender: self)
        }
    }
    
    func setPlayer(setPlayer : RHSCMember?, number: UInt16) {
        //    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
        self.player2Member = setPlayer;
        self.player2Control?.setTitle(setPlayer!.fullName, forSegmentAtIndex: 0)
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
        let urlstr = String.init(format: "Reserve20/IOSBookCourtJSON.php?booking_id=%@&player1_id=%@&player2_id=%@&player3_id=%@&player4_id=%@&uid=%@&channel=%@&guest2=%@&guest3=%@&guest4=%@&channel=%@&court='%@'&courtEvent=%@&reserved=false",
            arguments: [self.courtTimeRecord!.bookingId!,
                tbc.currentUser!.name!,
                (self.player2Member != nil ? self.player2Member!.name : "")!, "", "",
                tbc.currentUser!.name!,"iPhone",
                (self.guest2 != nil ? self.guest2!.name : ""), "", "",
                "iPhone", (self.courtTimeRecord?.court)!.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
                self.eventType!.text!])
//        print(urlstr)
        let url = NSURL(string: urlstr,
            relativeToURL: tbc.server )
        //        NSLog(@"fetch URL = %@",fetchURL);
//        print(url)
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
                        let delay = 2.0 * Double(NSEC_PER_SEC)
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
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.successAlert!.dismissViewControllerAnimated(true, completion: nil)
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
                } else {
                    self.errorAlert = UIAlertController(title: "Unable to Book Court",
                        message: jsonDictionary["error"] as! String?, preferredStyle: .Alert)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        // do some task
                        dispatch_async(dispatch_get_main_queue(), {
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
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
                        let delay = 2.0 * Double(NSEC_PER_SEC)
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


