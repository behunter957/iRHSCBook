//
//  RHSCCourtTimeViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-29.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCCourtTimeViewController : UITableViewController,reserveSinglesProtocol,reserveDoublesProtocol, cancelBookingProtocol,UIPickerViewDataSource,UIPickerViewDelegate,NSFileManagerDelegate {

    @IBOutlet weak var selectedSetCtrl : UISegmentedControl? = nil
    @IBOutlet weak var courtSet : UITextField? = nil
    @IBOutlet weak var selectionDay : UITextField? = nil
    @IBOutlet weak var incBookings : UISwitch? = nil

    @IBOutlet weak var headerButton : UIBarButtonItem? = nil

    var includeAlert : UIAlertView? = nil

    var selectionDate : NSDate? = nil
    var selectionSet : String? = nil
    var selectedCourtTime : RHSCCourtTime? = nil
    var courtTimes : Array<RHSCCourtTime> = []
    var includeInd : String? = nil
    var setValues : Array<String> = []
    var dayValues : Array<NSDate> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations.
        self.clearsSelectionOnViewWillAppear = false;
    
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
        //TODO: replace code with preferences
        if ((self.selectionDate == nil)) {
            self.selectionDate = NSDate()
        }
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
    
        self.selectionDay!.text = dateFormat.stringFromDate(selectionDate!)
    
        let tbc = self.tabBarController as! RHSCTabBarController
    
        self.selectionSet = tbc.courtSet
        self.courtSet!.text = self.selectionSet
    
        self.incBookings!.on = tbc.includeBookings
    
        self.selectedCourtTime = nil;
    
        //    [self loadSelectedCourtTimes];
    
        //    [self refreshLeftBarButton];
        self.setValues = ["All","Singles","Doubles","Front","Back"]
    
        let setPicker = UIPickerView()
        setPicker.tag = 1
        setPicker.dataSource = self
        setPicker.delegate = self
        self.courtSet!.inputView = setPicker
    
        self.dayValues = []
        var curDate = NSDate()
        for _ in 1...30 {
            self.dayValues.append(curDate)
            curDate = curDate.dateByAddingTimeInterval(24*60*60)
        }
    
        let dayPicker = UIPickerView()
        dayPicker.tag = 2;
        dayPicker.dataSource = self;
        dayPicker.delegate = self;
        self.selectionDay!.inputView = dayPicker;
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refreshTable", forControlEvents: .ValueChanged)
    }

    override func viewDidAppear(animated: Bool) {
        //    NSLog(@"CourtTime viewDidAppear");
        //    [self refreshLeftBarButton];
        self.refreshTable()
    }
    
    @IBAction func includeChanged() {
        let incText = (self.incBookings!.on ? "Include" : "Exclude")
//        self.showStatus(String.init(format: "%@ bookings", arguments: [incText]), timeout: 0.5)
        self.asyncLoadSelectedCourtTimes()
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return self.setValues.count;
        }
        if (pickerView.tag == 2) {
            return self.dayValues.count;
        }
        return 0;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return self.setValues[row]
        }
        if (pickerView.tag == 2) {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "EEEE, MMMM d"
            return dateFormat.stringFromDate(self.dayValues[row])
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            self.courtSet!.text = self.setValues[row]
            self.selectionSet = self.setValues[row]
            self.courtSet?.resignFirstResponder()
        }
        if (pickerView.tag == 2) {
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "EEE, MMM d"
            self.selectionDate = self.dayValues[row]
            self.selectionDay!.text = dateFormat.stringFromDate(self.selectionDate!)
            self.selectionDay?.resignFirstResponder()
        }
        self.asyncLoadSelectedCourtTimes()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.courtTimes.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rhscCourtTimeTableIdentifier = "RHSCCourtTimeTableViewCell"
    
        var cell = tableView.dequeueReusableCellWithIdentifier(rhscCourtTimeTableIdentifier)
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(rhscCourtTimeTableIdentifier, owner: self, options: nil)
            cell = nib[0] as! RHSCCourtTimeTableViewCell
        }
    
        let ct = self.courtTimes[indexPath.row]
    
        let dtFormatter = NSDateFormatter()
        dtFormatter.locale = NSLocale.systemLocale()
        dtFormatter.dateFormat = "h:mm a"
    
        let rcell = (cell as! RHSCCourtTimeTableViewCell)
        rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.stringFromDate(ct.courtTime!)])
        rcell.statusLabel!.text = ct.status;
        if (ct.status == "Booked") || (ct.status == "Reserved") {
            rcell.statusLabel!.textColor = UIColor.redColor()
            if ct.court == "Court 5" {
                rcell.typeAndPlayersLabel!.text = String.init(format: "%@ - %@,%@,%@,%@",
                    arguments: [ct.event!,
                        ct.players["player1_lname"]!,
                        ct.players["player3_lname"]!,
                        ct.players["player2_lname"]!,
                        ct.players["player4_lname"]! ])
            } else {
                rcell.typeAndPlayersLabel!.text = String.init(format: "%@ - %@,%@",
                    arguments: [ct.event!,
                        ct.players["player1_lname"]!,
                        ct.players["player2_lname"]! ])
            }
            if (ct.bookedForUser) {
                rcell.statusLabel!.textColor = UIColor.redColor()
                rcell.accessoryType = .DisclosureIndicator
            } else {
                rcell.statusLabel!.textColor = UIColor.blackColor()
                rcell.accessoryType = .None
            }
        } else {
            rcell.typeAndPlayersLabel!.text = ""
            rcell.statusLabel!.textColor = UIColor.init(colorLiteralRed: 7/255.0, green: 128/255.0, blue: 9/255.0, alpha: 1.0)
            rcell.accessoryType = .DisclosureIndicator
        }
        return rcell;
    }

    @IBAction func syncCourts(sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.asyncLoadSelectedCourtTimes()
        //    [self.tableView reloadData];
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedCourtTime = self.courtTimes[indexPath.row]
        if self.selectedCourtTime!.status == "Available" {
            // lock the booking
            let tbc = self.tabBarController as! RHSCTabBarController
            let curUser = tbc.currentUser
            let url = NSURL(string: String.init(format: "Reserve20/IOSLockBookingJSON.php?bookingId=%@&uid=%@",
                arguments: [self.selectedCourtTime!.bookingId!, curUser!.data!.name!]),
                relativeToURL: tbc.server )
            print(url!.absoluteString)
            //            let sessionCfg = NSURLSession.sharedSession().configuration
            //            sessionCfg.timeoutIntervalForResource = 30.0
            //            let session = NSURLSession(configuration: sessionCfg)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                    let alert = UIAlertView(title: "Network error",
                        message: "Unable to lock the court",
                        delegate: nil,
                        cancelButtonTitle: "OK",
                        otherButtonTitles: "", "")
                    alert.show()
                } else if data != nil {
                    print("received data")
                    let jsonDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    if jsonDictionary["error"] == nil {
                        // determine the correct view to navigate to
                        var segueName = "ReserveSingles"
                        if self.courtTimes[indexPath.row].court == "Court 5" {
                            segueName = "ReserveDoubles"
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                            // do some task
                            dispatch_async(dispatch_get_main_queue(), {
                                // update some UI
                                print("segueing to \(segueName)")
                                self.performSegueWithIdentifier(segueName, sender: self)
                            });
                        });
                    } else {
                        let alert = UIAlertView(title: "Error locking the booking",
                            message: jsonDictionary["error"] as! String,
                            delegate: nil,
                            cancelButtonTitle: "OK",
                            otherButtonTitles: "", "")
                        alert.show()
                    }
                }
            })
            task.resume()
        } else {
            if (self.selectedCourtTime!.bookedForUser) {
                self.performSegueWithIdentifier("CancelFromAvailable", sender: self)
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "ReserveSingles" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCReserveSinglesViewController).delegate = self
            (segue.destinationViewController as! RHSCReserveSinglesViewController).courtTimeRecord = self.selectedCourtTime
        }
        if segue.identifier == "ReserveDoubles" {
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCReserveDoublesViewController).delegate = self
            (segue.destinationViewController as! RHSCReserveDoublesViewController).courtTimeRecord = self.selectedCourtTime
        }
        if segue.identifier == "CancelFromAvailable" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCBookingDetailViewController).delegate = self
            (segue.destinationViewController as! RHSCBookingDetailViewController).booking = self.selectedCourtTime
        }
    }
    
    func setSetSelection(setSelection:String) {
        //    NSLog(@"delegate setSetSelection %@",setSelection);
        self.selectionSet = setSelection;
        //   [self refreshLeftBarButton];
    }
    
    func setDateSelection(setDate:NSDate) {
        //    NSLog(@"delegate setDateSelection %@",setDate);
        self.selectionDate = setDate;
        //    [self refreshLeftBarButton];
    }
    
    func setInclude(setSwitch:String) {
        //    NSLog(@"delegate setInclude %@",setSwitch);
        self.includeInd = setSwitch
        //    [self loadSelectedCourtTimes];
        //    [self.tableView reloadData];
    }
    
    //-(void)refreshLeftBarButton
    //{
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    [dateFormat setDateFormat:@"EEE, MMM d"];
    //
    //    NSString *fmtStr = @"%@ courts for %@";
    //    if ([self.selectionSet isEqualToString:@"Doubles"]) {
    //        fmtStr = @"%@ court for %@";
    //    }
    //    self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:fmtStr,self.selectionSet,[dateFormat stringFromDate:self.selectionDate]];
    //}
    
    func asyncLoadSelectedCourtTimes() {
        let tbc = tabBarController as! RHSCTabBarController
        let curUser = tbc.currentUser
        if (curUser!.isLoggedOn()) {
            let dtFormatter = NSDateFormatter()
            dtFormatter.locale = NSLocale.systemLocale()
            dtFormatter.dateFormat = "yyyy/MM/dd"
            let curDate = dtFormatter.stringFromDate(self.selectionDate!)
            let url = NSURL(string: String.init(format: "Reserve20/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",
                arguments: [curDate, self.selectionSet!,
                    (self.incBookings!.on ? "YES" : "NO"),
                    curUser!.data!.name!]),
                relativeToURL: tbc.server )
//                print(url!.absoluteString)
//            let sessionCfg = NSURLSession.sharedSession().configuration
//            sessionCfg.timeoutIntervalForResource = 30.0
//            let session = NSURLSession(configuration: sessionCfg)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                } else if data != nil {
//                    print("received data")
                    let jsonDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    // Get an array of dictionaries with the key "locations"
                    let array : Array<NSDictionary> = jsonDictionary["courtTimes"]! as! Array<NSDictionary>
                    // Iterate through the array of dictionaries
                    self.courtTimes.removeAll()
                    for dict in array {
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.data!.name!))
                    }
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    // do some task
                    dispatch_async(dispatch_get_main_queue(), {
                        // update some UI
//                            print("reloading tableview")
                            self.tableView.reloadData()
                        });
                    });
            })
            task.resume()
        }
    }
    
    
    func loadSelectedCourtTimes() throws {
        let tbc = tabBarController as! RHSCTabBarController
        let curUser = tbc.currentUser
        if (curUser!.isLoggedOn()) {
            let dtFormatter = NSDateFormatter()
            dtFormatter.locale = NSLocale.systemLocale()
            dtFormatter.dateFormat = "yyyy/MM/dd"
            let curDate = dtFormatter.stringFromDate(self.selectionDate!)
            let semaphore_loadcourt = dispatch_semaphore_create(0)
            let url = NSURL(string: String.init(format: "Reserve20/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",
                arguments: [curDate, self.selectionSet!,
                    (self.incBookings!.on ? "YES" : "NO"),
                    curUser!.data!.name!]),
                relativeToURL: tbc.server )
            //        print(url!.absoluteString)
            let sessionCfg = NSURLSession.sharedSession().configuration
            sessionCfg.timeoutIntervalForResource = 30.0
            let session = NSURLSession(configuration: sessionCfg)
            let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Error: \(error!.localizedDescription) \(error!.userInfo)")
                } else if data != nil {
                    let jsonDictionary: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(data!,options: []) as! NSDictionary
                    // Get an array of dictionaries with the key "locations"
                    let array : Array<NSDictionary> = jsonDictionary["courtTimes"]! as! Array<NSDictionary>
                    // Iterate through the array of dictionaries
                    self.courtTimes.removeAll()
                    for dict in array {
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.data!.name!))
                    }
                }
                dispatch_semaphore_signal(semaphore_loadcourt)
            })
            task.resume()
            dispatch_semaphore_wait(semaphore_loadcourt, DISPATCH_TIME_FOREVER)
            self.tableView.reloadData()
        }

    }
    
    func refreshTable() {
        //TODO: refresh your data
        self.refreshControl?.endRefreshing()
        self.asyncLoadSelectedCourtTimes()
        self.dayValues = [];
        var curDate = NSDate()
        for _ in 1...30 {
            self.dayValues.append(curDate)
            curDate = curDate.dateByAddingTimeInterval(24*60*60)
        }
        //    [self.tableView reloadData];
    }
    
    func showStatus(message:String?,timeout:Double) {
        includeAlert = UIAlertView(title: "",
            message: message!,
            delegate: nil,
            cancelButtonTitle: nil,
            otherButtonTitles: "", "")
        includeAlert!.show()
        NSTimer.scheduledTimerWithTimeInterval(timeout,
            target:self,
            selector:"timerExpired",
            userInfo:nil,
            repeats:false)
    }
    
    func timerExpired(timer:NSTimer) {
        includeAlert?.dismissWithClickedButtonIndex(0, animated: true)
    }
    
    
    
}