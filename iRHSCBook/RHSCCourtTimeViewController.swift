//
//  RHSCCourtTimeViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-29.
//  Copyright © 2015 Bruce Hunter. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class RHSCCourtTimeViewController : UITableViewController, cancelCourtProtocol,UIPickerViewDataSource,UIPickerViewDelegate,NSFileManagerDelegate {

    @IBOutlet weak var selectedSetCtrl : UISegmentedControl? = nil
    @IBOutlet weak var courtSet : UITextField? = nil
    @IBOutlet weak var selectionDay : UITextField? = nil
    @IBOutlet weak var incBookings : UISwitch? = nil

    @IBOutlet weak var headerButton : UIBarButtonItem? = nil

    var includeAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    var selectionDate : NSDate? = nil
    var selectionSet : String? = nil
    var selectedCourtTime : RHSCCourtTime? = nil
    var courtTimes : Array<RHSCCourtTime> = []
    var includeInd : String? = nil
    var setValues : Array<String> = []
    var dayValues : Array<NSDate> = []

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.separatorColor = UIColor.blackColor()
//        self.tableView.separatorInset = UIEdgeInsetsZero
        
        self.tableView.accessibilityIdentifier = "CourtTimes"
                
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
        let incText = (self.incBookings!.on ? "Showing only Booked courts" : "Showing only Available courts")
        self.errorAlert = UIAlertController(title: "",
            message: incText, preferredStyle: .Alert)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        })
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
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let curCourtTime = self.courtTimes[indexPath.row]
        switch curCourtTime.status! {
        case "Available":
            return true
        default:
            return curCourtTime.bookedForUser
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let curCourtTime = self.courtTimes[indexPath.row]
        switch curCourtTime.status! {
            case "Booked","Reserved":
                switch curCourtTime.event! {
                    case "Lesson","Clinic","School":
                        cell.contentView.backgroundColor = UIColor.lessonYellow()
                        break
                    case "T&D","MNHL","Ladder","RoundRobin","Tournament":
                        cell.contentView.backgroundColor = UIColor.leaguePurple()
                        break
                    case "Practice":
                        cell.contentView.backgroundColor = UIColor.practiceOrange()
                        break
                    default:
                        cell.contentView.backgroundColor = UIColor.bookedBlue()
                }
                break
            default:
                cell.contentView.backgroundColor = UIColor.availableGreen()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rhscCourtTimeTableIdentifier = "RHSCCourtTimeTableViewCell"
    
        var cell = tableView.dequeueReusableCellWithIdentifier(rhscCourtTimeTableIdentifier)
        if (cell == nil) {
            let nib = NSBundle.mainBundle().loadNibNamed(rhscCourtTimeTableIdentifier, owner: self, options: nil)
            cell = nib[0] as! RHSCCourtTimeTableViewCell
        }
        if indexPath.row < self.courtTimes.count {
            let ct = self.courtTimes[indexPath.row]
            
            let dtFormatter = NSDateFormatter()
            dtFormatter.locale = NSLocale.systemLocale()
            dtFormatter.dateFormat = "h:mm a"
            
            let rcell = (cell as! RHSCCourtTimeTableViewCell)
            rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.stringFromDate(ct.courtTime!)])
            rcell.statusLabel!.text = ct.status;
            if (ct.status == "Booked") || (ct.status == "Reserved") {
                rcell.statusLabel!.textColor = UIColor.redColor()
                rcell.typeAndPlayersLabel!.text = ct.summary!
                switch ct.status! {
                case "Booked","Reserved":
                    switch ct.event! {
                    case "Lesson","Clinic","School":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.blackColor()
                        rcell.courtAndTimeLabel!.textColor = UIColor.blackColor()
                        rcell.statusLabel!.textColor = UIColor.blackColor()
                        break
                    case "T&D","MNHL","Ladder","RoundRobin","Tournament":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.whiteColor()
                        rcell.courtAndTimeLabel!.textColor = UIColor.whiteColor()
                        rcell.statusLabel!.textColor = UIColor.whiteColor()
                        break
                    case "Practice":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.blackColor()
                        rcell.courtAndTimeLabel!.textColor = UIColor.blackColor()
                        rcell.statusLabel!.textColor = UIColor.blackColor()
                        break
                    default:
                        rcell.typeAndPlayersLabel!.textColor = UIColor.whiteColor()
                        rcell.courtAndTimeLabel!.textColor = UIColor.whiteColor()
                        rcell.statusLabel!.textColor = UIColor.whiteColor()
                        break
                    }
                    break
                default:
                    rcell.typeAndPlayersLabel!.textColor = UIColor.whiteColor()
                    rcell.courtAndTimeLabel!.textColor = UIColor.whiteColor()
                    rcell.statusLabel!.textColor = UIColor.whiteColor()
                }
                if (ct.bookedForUser) {
                    rcell.statusLabel!.textColor = UIColor.redColor()
                }
            } else {
                rcell.typeAndPlayersLabel!.text = ""
                rcell.typeAndPlayersLabel!.textColor = UIColor.whiteColor()
                rcell.courtAndTimeLabel!.textColor = UIColor.whiteColor()
                rcell.statusLabel!.textColor = UIColor.whiteColor()
            }
            rcell.accessoryType = .None
            rcell.accessibilityIdentifier = rcell.courtAndTimeLabel?.text
            return rcell
        } else {
            print("unexpected out of range row=\(indexPath.row), container size=\(self.courtTimes.count)" )
            return UITableViewCell()
        }
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
            if self.selectedCourtTime!.lock(fromView: self) {
                let segueName = "BookCourt"
                self.performSegueWithIdentifier(segueName, sender: self)
            } else {
                self.errorAlert = UIAlertController(title: "Error",
                    message: "Unable to lock the court", preferredStyle: .Alert)
                self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        } else {
            if (self.selectedCourtTime!.bookedForUser) {
                //TODO if court has a TBD, then present action sheet for edit or cancel
                let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .ActionSheet)
                let updateAction = UIAlertAction(title: "Update", style: .Default, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                        if self.selectedCourtTime!.lock(fromView: self) {
                            let segueName = "UpdateCourt"
                            self.performSegueWithIdentifier(segueName, sender: self)
                        } else {
                            self.errorAlert = UIAlertController(title: "Error",
                                message: "Unable to lock the court", preferredStyle: .Alert)
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
                })
                let unbookAction = UIAlertAction(title: "Unbook", style: .Default, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                        if self.selectedCourtTime!.lock(fromView: self) {
                            let segueName = "CancelCourt"
                            self.performSegueWithIdentifier(segueName, sender: self)
                        } else {
                            self.errorAlert = UIAlertController(title: "Error",
                                message: "Unable to lock the court", preferredStyle: .Alert)
                            self.presentViewController(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                            dispatch_after(time, dispatch_get_main_queue(), {
                                self.errorAlert!.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                            tableView.deselectRowAtIndexPath(indexPath, animated: false)
                })
                optionMenu.addAction(updateAction)
                optionMenu.addAction(unbookAction)
                optionMenu.addAction(cancelAction)
                self.presentViewController(optionMenu, animated: true, completion: nil)

            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "UpdateCourt" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCUpdateCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCUpdateCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCUpdateCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "BookCourt" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destinationViewController as! RHSCBookCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCBookCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCBookCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "CancelCourt" {
            // set the selectionSet and selectionDate properties
            (segue.destinationViewController as! RHSCCancelCourtViewController).delegate = self
            (segue.destinationViewController as! RHSCCancelCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destinationViewController as! RHSCCancelCourtViewController).user = tbc.currentUser
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
                    curUser!.name!]),
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
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.name!, members: tbc.memberList!))
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
                    curUser!.name!]),
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
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.name!, members: tbc.memberList!))
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
        self.includeAlert = UIAlertController(title: "",
            message: message!, preferredStyle: .Alert)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            // do some task
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(self.includeAlert!, animated: true, completion: nil)
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.includeAlert!.dismissViewControllerAnimated(true, completion: nil)
                })
            })
        })
    }
    
}