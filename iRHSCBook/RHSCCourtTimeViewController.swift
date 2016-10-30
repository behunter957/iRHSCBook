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
class RHSCCourtTimeViewController : UITableViewController, cancelCourtProtocol,UIPickerViewDataSource,UIPickerViewDelegate,FileManagerDelegate {

    @IBOutlet weak var selectedSetCtrl : UISegmentedControl? = nil
    @IBOutlet weak var courtSet : UITextField? = nil
    @IBOutlet weak var selectionDay : UITextField? = nil
    @IBOutlet weak var incBookings : UISwitch? = nil

    @IBOutlet weak var headerButton : UIBarButtonItem? = nil

    var includeAlert : UIAlertController? = nil
    var errorAlert : UIAlertController? = nil

    var selectionDate : Date? = nil
    var selectionSet : String? = nil
    var selectedCourtTime : RHSCCourtTime? = nil
    var courtTimes : Array<RHSCCourtTime> = []
    var includeInd : String? = nil
    var setValues : Array<String> = []
    var dayValues : Array<Date> = []

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
            self.selectionDate = Date()
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEE, MMM d"
    
        self.selectionDay!.text = dateFormat.string(from: selectionDate!)
    
        let tbc = self.tabBarController as! RHSCTabBarController
    
        self.selectionSet = tbc.courtSet
        self.courtSet!.text = self.selectionSet
    
        self.incBookings!.isOn = tbc.showBooked
    
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
        var curDate = Date()
        for _ in 1...30 {
            self.dayValues.append(curDate)
            curDate = curDate.addingTimeInterval(24*60*60)
        }
    
        let dayPicker = UIPickerView()
        dayPicker.tag = 2;
        dayPicker.dataSource = self;
        dayPicker.delegate = self;
        self.selectionDay!.inputView = dayPicker;
    
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(RHSCCourtTimeViewController.refreshTable), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        //    NSLog(@"CourtTime viewDidAppear");
        //    [self refreshLeftBarButton];
        self.refreshTable()
    }
    
    @IBAction func includeChanged() {
        let incText = (self.incBookings!.isOn ? "Showing only Booked courts" : "Showing only Available courts")
        self.errorAlert = UIAlertController(title: "",
            message: incText, preferredStyle: .alert)
        DispatchQueue.global().async(execute: {
            // do some task
            DispatchQueue.main.async(execute: {
                self.present(self.errorAlert!, animated: true, completion: nil)
                let delay = 1.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.errorAlert!.dismiss(animated: true, completion: nil)
                })
            })
        })
        self.asyncLoadSelectedCourtTimes()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return self.setValues.count;
        }
        if (pickerView.tag == 2) {
            return self.dayValues.count;
        }
        return 0;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return self.setValues[row]
        }
        if (pickerView.tag == 2) {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "EEEE, MMMM d"
            return dateFormat.string(from: self.dayValues[row])
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            self.courtSet!.text = self.setValues[row]
            self.selectionSet = self.setValues[row]
            self.courtSet?.resignFirstResponder()
        }
        if (pickerView.tag == 2) {
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "EEE, MMM d"
            self.selectionDate = self.dayValues[row]
            self.selectionDay!.text = dateFormat.string(from: self.selectionDate!)
            self.selectionDay?.resignFirstResponder()
        }
        self.asyncLoadSelectedCourtTimes()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.courtTimes.count;
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let curCourtTime = self.courtTimes[(indexPath as NSIndexPath).row]
        switch curCourtTime.status! {
        case "Available":
            return true
        default:
            return curCourtTime.bookedForUser
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let curCourtTime = self.courtTimes[(indexPath as NSIndexPath).row]
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rhscCourtTimeTableIdentifier = "RHSCCourtTimeTableViewCell"
    
        var cell = tableView.dequeueReusableCell(withIdentifier: rhscCourtTimeTableIdentifier)
        if (cell == nil) {
            let nib = Bundle.main.loadNibNamed(rhscCourtTimeTableIdentifier, owner: self, options: nil)
            cell = nib?[0] as! RHSCCourtTimeTableViewCell
        }
        if (indexPath as NSIndexPath).row < self.courtTimes.count {
            let ct = self.courtTimes[(indexPath as NSIndexPath).row]
            
            let dtFormatter = DateFormatter()
            dtFormatter.locale = Locale.current
            dtFormatter.dateFormat = "h:mm a"
            
            let rcell = (cell as! RHSCCourtTimeTableViewCell)
            rcell.courtAndTimeLabel!.text = String.init(format: "%@ - %@", arguments: [ct.court!,dtFormatter.string(from: ct.courtTime! as Date)])
            rcell.statusLabel!.text = ct.status;
            if (ct.status == "Booked") || (ct.status == "Reserved") {
                rcell.statusLabel!.textColor = UIColor.red
                rcell.typeAndPlayersLabel!.text = ct.summary!
                switch ct.status! {
                case "Booked","Reserved":
                    switch ct.event! {
                    case "Lesson","Clinic","School":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.black
                        rcell.courtAndTimeLabel!.textColor = UIColor.black
                        rcell.statusLabel!.textColor = UIColor.black
                        break
                    case "T&D","MNHL","Ladder","RoundRobin","Tournament":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.white
                        rcell.courtAndTimeLabel!.textColor = UIColor.white
                        rcell.statusLabel!.textColor = UIColor.white
                        break
                    case "Practice":
                        rcell.typeAndPlayersLabel!.textColor = UIColor.black
                        rcell.courtAndTimeLabel!.textColor = UIColor.black
                        rcell.statusLabel!.textColor = UIColor.black
                        break
                    default:
                        rcell.typeAndPlayersLabel!.textColor = UIColor.white
                        rcell.courtAndTimeLabel!.textColor = UIColor.white
                        rcell.statusLabel!.textColor = UIColor.white
                        break
                    }
                    break
                default:
                    rcell.typeAndPlayersLabel!.textColor = UIColor.white
                    rcell.courtAndTimeLabel!.textColor = UIColor.white
                    rcell.statusLabel!.textColor = UIColor.white
                }
                if (ct.bookedForUser) {
                    rcell.statusLabel!.textColor = UIColor.red
                }
            } else {
                rcell.typeAndPlayersLabel!.text = ""
                rcell.typeAndPlayersLabel!.textColor = UIColor.white
                rcell.courtAndTimeLabel!.textColor = UIColor.white
                rcell.statusLabel!.textColor = UIColor.white
            }
            rcell.accessoryType = .none
            rcell.accessibilityIdentifier = rcell.courtAndTimeLabel?.text
            return rcell
        } else {
            print("unexpected out of range row=\((indexPath as NSIndexPath).row), container size=\(self.courtTimes.count)" )
            return UITableViewCell()
        }
    }

    @IBAction func syncCourts(_ sender:AnyObject?) {
        self.refreshControl?.endRefreshing()
        self.asyncLoadSelectedCourtTimes()
        //    [self.tableView reloadData];
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    NSInteger row = indexPath.row;
        //    NSLog(@"Selected row : %d",row);
        self.selectedCourtTime = self.courtTimes[(indexPath as NSIndexPath).row]
        if self.selectedCourtTime!.status == "Available" {
            // lock the booking
            if self.selectedCourtTime!.lock(fromView: self) {
                let segueName = "BookCourt"
                self.performSegue(withIdentifier: segueName, sender: self)
            } else {
                self.errorAlert = UIAlertController(title: "Error",
                    message: "Unable to lock the court", preferredStyle: .alert)
                self.present(self.errorAlert!, animated: true, completion: nil)
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.errorAlert!.dismiss(animated: true, completion: nil)
                })
            }
        } else {
            if (self.selectedCourtTime!.bookedForUser) {
                //TODO if court has a TBD, then present action sheet for edit or cancel
                let optionMenu = UIAlertController(title: nil, message: "Menu", preferredStyle: .actionSheet)
                let updateAction = UIAlertAction(title: "Update", style: .default, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                        if self.selectedCourtTime!.lock(fromView: self) {
                            let segueName = "UpdateCourt"
                            self.performSegue(withIdentifier: segueName, sender: self)
                        } else {
                            self.errorAlert = UIAlertController(title: "Error",
                                message: "Unable to lock the court", preferredStyle: .alert)
                            self.present(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                self.errorAlert!.dismiss(animated: true, completion: nil)
                            })
                        }
                })
                let unbookAction = UIAlertAction(title: "Unbook", style: .default, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                        if self.selectedCourtTime!.lock(fromView: self) {
                            let segueName = "CancelCourt"
                            self.performSegue(withIdentifier: segueName, sender: self)
                        } else {
                            self.errorAlert = UIAlertController(title: "Error",
                                message: "Unable to lock the court", preferredStyle: .alert)
                            self.present(self.errorAlert!, animated: true, completion: nil)
                            let delay = 2.0 * Double(NSEC_PER_SEC)
                            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                                self.errorAlert!.dismiss(animated: true, completion: nil)
                            })
                        }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
                    {
                        (alert: UIAlertAction!) -> Void in
                            tableView.deselectRow(at: indexPath, animated: false)
                })
                optionMenu.addAction(updateAction)
                optionMenu.addAction(unbookAction)
                optionMenu.addAction(cancelAction)
                self.present(optionMenu, animated: true, completion: nil)

            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        //    NSLog(@"segue: %@",segue.identifier);
        if segue.identifier == "UpdateCourt" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destination as! RHSCUpdateCourtViewController).delegate = self
            (segue.destination as! RHSCUpdateCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCUpdateCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "BookCourt" {
            // lock the court
            // set the selectedCourtTime record
            (segue.destination as! RHSCBookCourtViewController).delegate = self
            (segue.destination as! RHSCBookCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCBookCourtViewController).user = tbc.currentUser
        }
        if segue.identifier == "CancelCourt" {
            // set the selectionSet and selectionDate properties
            (segue.destination as! RHSCCancelCourtViewController).delegate = self
            (segue.destination as! RHSCCancelCourtViewController).ct = self.selectedCourtTime
            let tbc = self.tabBarController as! RHSCTabBarController
            (segue.destination as! RHSCCancelCourtViewController).user = tbc.currentUser
        }
    }
    
    func setSetSelection(_ setSelection:String) {
        //    NSLog(@"delegate setSetSelection %@",setSelection);
        self.selectionSet = setSelection;
        //   [self refreshLeftBarButton];
    }
    
    func setDateSelection(_ setDate:Date) {
        //    NSLog(@"delegate setDateSelection %@",setDate);
        self.selectionDate = setDate;
        //    [self refreshLeftBarButton];
    }
    
    func setInclude(_ setSwitch:String) {
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
            let dtFormatter = DateFormatter()
            dtFormatter.locale = Locale.current
            dtFormatter.dateFormat = "yyyy/MM/dd"
            let curDate = dtFormatter.string(from: self.selectionDate!)
            let url = URL(string: String.init(format: "Reserve20/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",
                arguments: [curDate, self.selectionSet!,
                    (self.incBookings!.isOn ? "YES" : "NO"),
                    curUser!.name!]),
                relativeTo: tbc.server as URL? )
//                print(url!.absoluteString)
//            let sessionCfg = NSURLSession.sharedSession().configuration
//            sessionCfg.timeoutIntervalForResource = 30.0
//            let session = NSURLSession(configuration: sessionCfg)
            let session = URLSession.shared
            let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else if data != nil {
//                    print("received data")
                    let jsonDictionary: [String : String] = try! JSONSerialization.jsonObject(with: data!,options: []) as! [String : String]
                    // Get an array of dictionaries with the key "locations"
                    let array : Array<[String : String]> = jsonDictionary["courtTimes"]! as! Array<[String : String]>
                    // Iterate through the array of dictionaries
                    self.courtTimes.removeAll()
                    for dict in array {
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.name!, members: tbc.memberList!))
                    }
                }
                DispatchQueue.global().async(execute: {
                    // do some task
                    DispatchQueue.main.async(execute: {
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
            let dtFormatter = DateFormatter()
            dtFormatter.locale = Locale.current
            dtFormatter.dateFormat = "yyyy/MM/dd"
            let curDate = dtFormatter.string(from: self.selectionDate!)
            let semaphore_loadcourt = DispatchSemaphore(value: 0)
            let url = URL(string: String.init(format: "Reserve20/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",
                arguments: [curDate, self.selectionSet!,
                    (self.incBookings!.isOn ? "YES" : "NO"),
                    curUser!.name!]),
                relativeTo: tbc.server as URL? )
            //        print(url!.absoluteString)
            let sessionCfg = URLSession.shared.configuration
            sessionCfg.timeoutIntervalForResource = 30.0
            let session = URLSession(configuration: sessionCfg)
            let task = session.dataTask(with: url!, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else if data != nil {
                    let jsonDictionary: [String : String] = try! JSONSerialization.jsonObject(with: data!,options: []) as! [String : String]
                    // Get an array of dictionaries with the key "locations"
                    let array : Array<[String : String]> = jsonDictionary["courtTimes"]! as! Array<[String : String]>
                    // Iterate through the array of dictionaries
                    self.courtTimes.removeAll()
                    for dict in array {
                        self.courtTimes.append(RHSCCourtTime(withJSONDictionary: dict, forUser: curUser!.name!, members: tbc.memberList!))
                    }
                }
                semaphore_loadcourt.signal()
            })
            task.resume()
            _ = semaphore_loadcourt.wait(timeout: DispatchTime.distantFuture)
            self.tableView.reloadData()
        }

    }
    
    func refreshTable() {
        //TODO: refresh your data
        self.refreshControl?.endRefreshing()
        self.asyncLoadSelectedCourtTimes()
        self.dayValues = [];
        var curDate = Date()
        for _ in 1...30 {
            self.dayValues.append(curDate)
            curDate = curDate.addingTimeInterval(24*60*60)
        }
        //    [self.tableView reloadData];
    }
    
    func showStatus(_ message:String?,timeout:Double) {
        self.includeAlert = UIAlertController(title: "",
            message: message!, preferredStyle: .alert)
        DispatchQueue.global().async(execute: {
            // do some task
            DispatchQueue.main.async(execute: {
                self.present(self.includeAlert!, animated: true, completion: nil)
                let delay = 2.0 * Double(NSEC_PER_SEC)
                let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time, execute: {
                    self.includeAlert!.dismiss(animated: true, completion: nil)
                })
            })
        })
    }
    
}
