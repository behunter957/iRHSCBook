//
//  RHSCBookingDetailViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-09.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCBookingDetailViewController.h"
#import <MessageUI/MessageUI.h>
#import "RHSCTabBarController.h"
#import "RHSCCourtTime.h"
#import "RHSCMemberList.h"
#import "RHSCMember.h"

@interface RHSCBookingDetailViewController ()

@property (nonatomic, strong) RHSCMember *player1;
@property (nonatomic, strong) RHSCMember *player2;
@property (nonatomic, strong) RHSCMember *player3;
@property (nonatomic, strong) RHSCMember *player4;
@property (nonatomic,strong) UIAlertView *successAlert;
@property (nonatomic,strong) UIAlertView *errorAlert;

@end

@implementation RHSCBookingDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // obtain players
    RHSCTabBarController *tbc = (RHSCTabBarController *) self.tabBarController;
    
    self.user = tbc.currentUser;
    
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"EEE, MMM d - h:mm a"];
    
    self.courtAndTime.text = [NSString stringWithFormat:@"%@ for %@",self.booking.court,[dtFormatter stringFromDate:self.booking.courtTime]];
    self.eventLabel.text = [NSString stringWithFormat:@"%@ match with:",self.booking.event];
    self.player1 = [self findPlayer:self.booking.players[@"player1_id"] in:tbc.memberList];
    if (self.player1) {
        self.player1Label.text = [NSString stringWithFormat:@"%@ %@",self.player1.firstName,self.player1.lastName];
    } else {
        self.player1Label.text = @"";
    }
    self.player2 = [self findPlayer:self.booking.players[@"player2_id"] in:tbc.memberList];
    if (self.player2) {
        self.player2Label.text = [NSString stringWithFormat:@"%@ %@",self.player2.firstName,self.player2.lastName];
    } else {
        self.player2Label.text = @"";
    }
    if ([self.booking.court isEqualToString:@"Court 5"]) {
        self.player3 = [self findPlayer:self.booking.players[@"player3_id"] in:tbc.memberList];
        if (self.player3) {
            self.player3Label.text = [NSString stringWithFormat:@"%@ %@",self.player3.firstName,self.player3.lastName];
        } else {
            self.player3Label.text = @"";
        }
        self.player4 = [self findPlayer:self.booking.players[@"player4_id"] in:tbc.memberList];
        if (self.player4) {
            self.player4Label.text = [NSString stringWithFormat:@"%@ %@",self.player4.firstName,self.player4.lastName];
        } else {
            self.player4Label.text = @"";
        }
        
    }
}

- (RHSCMember *)findPlayer:(NSString *)playerId in:(RHSCMemberList *)memList
{
    for (RHSCMember* mem in memList.memberList)
    {
        if([mem.name isEqualToString:playerId]){
            return mem;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBooking:(id)sender {
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    NSString * fetchURL = nil;
    if ([self.booking.court isEqualToString:@"Court 5"]) {
        fetchURL = [NSString stringWithFormat:@"Reserve/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",[self.booking bookingId],
                    tbc.currentUser.data.name,
                    [[self.booking players] objectForKey:@"player2_id"],
                    [[self.booking players] objectForKey:@"player3_id"],
                    [[self.booking players] objectForKey:@"player4_id"],
                    tbc.currentUser.data.name,@"iPhone"
                    ];
    } else {
        fetchURL = [NSString stringWithFormat:@"Reserve/IOSCancelBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@",[self.booking bookingId],
                          tbc.currentUser.data.name,
                          [[self.booking players] objectForKey:@"player2_id"],@"",@"",
                          tbc.currentUser.data.name,@"iPhone"
                          ];
    }
    
    NSLog(@"fetch URL = %@",fetchURL);
    NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    // Get the data
    NSURLResponse *response;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error == nil) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonDictionary objectForKey:@"error"] == nil) {
            
            // Get an array of dictionaries with the key "locations"
            // NSArray *array = [jsonDictionary objectForKey:@"user"];
            NSLog(@"%@",jsonDictionary);
            self.successAlert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                      message:@"Booking successfully cancelled. Notices will be sent to all players"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
            [self.successAlert show];
        } else {
            self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[jsonDictionary objectForKey:@"error"]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
            [self.errorAlert show];
        }
    } else {
        self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                message:[error localizedDescription]
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
        [self.errorAlert show];
    }
}

@synthesize delegate;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successAlert) {
        [delegate refreshTable];
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
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
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
			NSLog(@"Cancelled");
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
