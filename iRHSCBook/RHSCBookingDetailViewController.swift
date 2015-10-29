//
//  RHSCBookingDetailViewController.swift
//  iRHSCBook
//
//  Created by Bruce Hunter on 2015-10-28.
//  Copyright © 2015 Richmond Hill Squash Club. All rights reserved.
//

import Foundation
import MessageUI

protocol cancelBookingProtocol {

    func refreshTable()
}

class RHSCBookingDetailViewController : UIViewController,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate {

    @IBOutlet weak var courtAndTime : UILabel? = nil
    @IBOutlet weak var eventLabel : UILabel? = nil
    @IBOutlet weak var player1Label : UILabel? = nil
    @IBOutlet weak var player2Label : UILabel? = nil
    @IBOutlet weak var player3Label : UILabel? = nil
    @IBOutlet weak var player4Label : UILabel? = nil

    var user : RHSCUser? = nil
    var booking : RHSCCourtTime? = nil
    
    var delegate : AnyObject? = nil
    
    var player1 : RHSCMember? = nil
    var player2 : RHSCMember? = nil
    var player3 : RHSCMember? = nil
    var player4 : RHSCMember? = nil
    var successAlert : UIAlertView? = nil
    var errorAlert : UIAlertView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // obtain players
        let tbc = tabBarController as! RHSCTabBarController
    
        user = tbc.currentUser
    
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "EEE, MMM d - h:mm a"
    
        courtAndTime!.text = String.init(format: "%@ for %@", arguments: [(booking?.court)!,dtFormatter.stringFromDate((booking?.courtTime)!)])

        eventLabel!.text = String.init(format: "%@ match between:", arguments: [(booking?.event)!])
        
        player1 = findPlayer("player1_id",inList: tbc.memberList!)
        if (player1 != nil) {
            player1Label!.text = String.init(format: "%@ %@", arguments: [player1!.firstName!,player1!.lastName!])
        } else {
            player1Label!.text = ""
        }
        
        player2 = findPlayer("player2_id",inList: tbc.memberList!)
        if (player2 != nil) {
            player2Label!.text = String.init(format: "%@ %@", arguments: [player2!.firstName!,player2!.lastName!])
        } else {
            player2Label!.text = ""
        }
        
        if (booking!.court == "Court 5") {
            player3 = findPlayer("player3_id",inList: tbc.memberList!)
            if (player3Label != nil) {
                player3Label!.text = String.init(format: "%@ %@", arguments: [player3!.firstName!,player3!.lastName!])
            } else {
                player3Label!.text = ""
            }
            player4 = findPlayer("player4_id",inList: tbc.memberList!)
            if (player4Label != nil) {
                player4Label!.text = String.init(format: "%@ %@", arguments: [player4!.firstName!,player4!.lastName!])
            } else {
                player4Label!.text = ""
            }
        }
    }
    
    func findPlayer(playerId : String, inList memList: RHSCMemberList) -> RHSCMember?{
        for mem in memList.memberList {
            if (mem.name == playerId){
                return mem;
            }
        }
        return nil;
    }

    @IBAction func cancelBooking(sender : AnyObject) throws {
        let tbc = tabBarController as! RHSCTabBarController
        var fetchURL : String? = nil;
        if (booking!.court == "Court 5") {
            fetchURL = String.init(format: "Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",
                arguments: [booking!.bookingId, (tbc.currentUser?.data?.name)!,booking!.players["player2_id"]!,
                    booking!.players["player3_id"]!,booking!.players["player4_id"]!,
                    (tbc.currentUser?.data?.name)!,"iPhone"])
            
        } else {
            fetchURL = String.init(format:"Reserve20/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",[booking!.bookingId,
                (tbc.currentUser?.data?.name)!,
                booking!.players["player2_id"]!,"","",
                    (tbc.currentUser?.data?.name)!,"iPhone"])
        }
    
        //    NSLog(@"fetch URL = %@",fetchURL);
        let target = NSURL(string:fetchURL!, relativeToURL:tbc.server)
        let request = NSURLRequest(URL:target!,
            cachePolicy:NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval:30.0)
        // Get the data
        let response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        // Sending Synchronous request using NSURLConnection
        let data = try NSURLConnection.sendSynchronousRequest(request,returningResponse: response) as NSData
        let jsonDictionary: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
        if (jsonDictionary["error"] == nil) {
            // Get an array of dictionaries with the key "locations"
            // NSArray *array = [jsonDictionary objectForKey:@"user"];
            //            NSLog(@"%@",jsonDictionary);
            let successAlert = UIAlertView(title: "Success",
                message: "CBooking successfully cancelled. Notices will be sent to all players",
                delegate: self,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            successAlert.show()
        } else {
            let alert = UIAlertView(title: "Error",
                message: jsonDictionary["error"] as! String,
                delegate: nil,
                cancelButtonTitle: "OK",
                otherButtonTitles: "", "")
            alert.show()
        }
    }
    
    func alertView(forView alertView:UIAlertView, clickedButtonAtIndex buttonIndex:NSInteger) {
        if (alertView == successAlert) {
            delegate.refreshTable()
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    - (IBAction)emailPlayers:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    // Email Subject
    NSString *emailTitle = @"";
    // Email Content
    NSString *messageBody = @"";
    // To address
    
    NSArray *toRecipents = [NSArray arrayWithObjects:[self.booking.players objectForKey:@"player1_id"],[self.booking.players objectForKey:@"player2_id"],[self.booking.players objectForKey:@"player3_id"],[self.booking.players objectForKey:@"player4_id"],nil];
    NSMutableArray *emailAddresses = [[NSMutableArray alloc] init];
    for (NSString *playerId in toRecipents) {
    for (RHSCMember *mem in ml.memberList) {
    if ([mem.name isEqualToString:playerId]) {
    if (mem.email != nil) {
    if (![mem.email isEqualToString:@"NULL"]) {
    if (![mem.name isEqualToString:tbc.currentUser.data.name]) {
    [emailAddresses addObject:mem.email];
    }
    }
    }
    break;
    }
    }
    }
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:emailAddresses];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send email"
    message:@"Cannot email from this device"
    delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [alert show];
    }
    }
    
    - (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
    {
    switch (result)
    {
    case MFMailComposeResultCancelled:
    //            NSLog(@"Mail cancelled");
    break;
    case MFMailComposeResultSaved:
    //            NSLog(@"Mail saved");
    break;
    case MFMailComposeResultSent:
    //            NSLog(@"Mail sent");
    break;
    case MFMailComposeResultFailed:
    //            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
    break;
    default:
    break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    - (IBAction)smsPlayers:(id)sender {
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
    NSArray *toRecipents = [NSArray arrayWithObjects:[self.booking.players objectForKey:@"player1_id"],[self.booking.players objectForKey:@"player2_id"],[self.booking.players objectForKey:@"player3_id"],[self.booking.players objectForKey:@"player4_id"],nil];
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    for (NSString *playerId in toRecipents) {
    for (RHSCMember *mem in ml.memberList) {
    if ([mem.name isEqualToString:playerId]) {
    if (mem.phone1 != nil) {
    if (![mem.phone1 isEqualToString:@"NULL"]) {
    if (![mem.name isEqualToString:tbc.currentUser.data.name]) {
    NSString *cleanedString = [[[mem phone1] componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    [phoneNumbers addObject:cleanedString];
    }
    }
    }
    break;
    }
    }
    }
    controller.body = @"";
    controller.recipients = phoneNumbers;
    controller.messageComposeDelegate = self;
    [self presentViewController:controller animated:YES completion:NULL];
    }
    }
    
    - (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
    {
    switch (result) {
    case MessageComposeResultCancelled:
    //			NSLog(@"Cancelled");
    break;
    case MessageComposeResultFailed: {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot send SMS"
    message:@"Cannot message from this device"
    delegate:nil
    cancelButtonTitle:@"OK"
    otherButtonTitles:nil];
    [alert show];
    break;
    }
    case MessageComposeResultSent:
    break;
    default:
    break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
    
}
