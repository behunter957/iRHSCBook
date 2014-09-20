//
//  RHSCReserveDoublesViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCReserveDoublesViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCFindMemberViewController.h"
#import "RHSCGuest.h"
#import "RHSCGuestDetailsViewController.h"

@interface RHSCReserveDoublesViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) RHSCMember *player2Member;
@property (nonatomic,strong) RHSCMember *player3Member;
@property (nonatomic,strong) RHSCMember *player4Member;
@property (nonatomic,strong) UIAlertView *successAlert;
@property (nonatomic,strong) UIAlertView *errorAlert;
@property (nonatomic,strong) RHSCGuest *guest2;
@property (nonatomic,strong) RHSCGuest *guest3;
@property (nonatomic,strong) RHSCGuest *guest4;

@end

@implementation RHSCReserveDoublesViewController

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
    self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Ladder",@"Lesson",@"Tournament", nil];
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    self.userLabel.text = [NSString stringWithFormat:@"%@ %@",tbc.currentUser.data.firstName,tbc.currentUser.data.lastName];
    self.player2Control.selectedSegmentIndex = 1;
    self.player3Control.selectedSegmentIndex = 1;
    self.player4Control.selectedSegmentIndex = 1;
    self.guest2 = [[RHSCGuest alloc] init];
    self.guest3 = [[RHSCGuest alloc] init];
    self.guest4 = [[RHSCGuest alloc] init];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.eventType.inputView = picker;
}

@synthesize delegate;

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unlockBooking];
//    [delegate refreshTable];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancel
{
//    NSLog(@"exiting ReserveDoubles");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) book
{
//    NSLog(@"booking doubles court and exiting ReserveDoubles");
    [self bookCourt];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.typeList.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.typeList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.eventType.text = self.typeList[row];
    [self.eventType resignFirstResponder];
}

-(IBAction) player2Clicked:(id)sender
{
//    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    if (self.player2Control.selectedSegmentIndex == 0) {
        self.player2Control.selectedSegmentIndex = -1;
        NSString *segueName = @"DoublesPlayer2";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    if (self.player2Control.selectedSegmentIndex == 1) {
        self.player2Member = tbc.memberList.TBD;
        [self.player2Control setTitle:@"Select Member" forSegmentAtIndex:0];
    }
    if (self.player2Control.selectedSegmentIndex == 2) {
        self.player2Member = tbc.memberList.GUEST;
        [self.player2Control setTitle:@"Select Member" forSegmentAtIndex:0];
        NSString *segueName = @"DoublesGuest2";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    [self.player2Control setTitle:@"Select Member" forSegmentAtIndex:0];
}

-(IBAction) player3Clicked:(id)sender
{
//    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    if (self.player3Control.selectedSegmentIndex == 0) {
        self.player3Control.selectedSegmentIndex = -1;
        NSString *segueName = @"DoublesPlayer3";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    if (self.player3Control.selectedSegmentIndex == 1) {
        self.player3Member = tbc.memberList.TBD;
        [self.player3Control setTitle:@"Select Member" forSegmentAtIndex:0];
    }
    if (self.player3Control.selectedSegmentIndex == 2) {
        self.player3Member = tbc.memberList.GUEST;
        [self.player3Control setTitle:@"Select Member" forSegmentAtIndex:0];
        NSString *segueName = @"DoublesGuest3";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    [self.player3Control setTitle:@"Select Member" forSegmentAtIndex:0];
}

-(IBAction) player4Clicked:(id)sender
{
//    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    if (self.player4Control.selectedSegmentIndex == 0) {
        self.player4Control.selectedSegmentIndex = -1;
        NSString *segueName = @"DoublesPlayer4";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    if (self.player4Control.selectedSegmentIndex == 1) {
        self.player4Member = tbc.memberList.TBD;
        [self.player4Control setTitle:@"Select Member" forSegmentAtIndex:0];
    }
    if (self.player4Control.selectedSegmentIndex == 2) {
        self.player4Member = tbc.memberList.GUEST;
        [self.player4Control setTitle:@"Select Member" forSegmentAtIndex:0];
        NSString *segueName = @"DoublesGuest4";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    [self.player4Control setTitle:@"Select Member" forSegmentAtIndex:0];
}

-(void)setPlayer:(RHSCMember *)setPlayer number:(NSNumber *)playerNumber
{
//    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
    NSString *newTitle = [NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName];
    if (playerNumber.intValue == 2) {
        self.player2Member = setPlayer;
        [self.player2Control setTitle:newTitle forSegmentAtIndex:0];
    }
    if (playerNumber.intValue == 3) {
        self.player3Member = setPlayer;
        [self.player3Control setTitle:newTitle forSegmentAtIndex:0];
    }
    if (playerNumber.intValue == 4) {
        self.player4Member = setPlayer;
        [self.player4Control setTitle:newTitle forSegmentAtIndex:0];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"DoublesPlayer2"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setPlayerNumber:[NSNumber numberWithInt:2]];
    }
    if ([segue.identifier isEqualToString:@"DoublesPlayer3"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setPlayerNumber:[NSNumber numberWithInt:3]];
    }
    if ([segue.identifier isEqualToString:@"DoublesPlayer4"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setPlayerNumber:[NSNumber numberWithInt:4]];
    }
    if ([segue.identifier isEqualToString:@"DoublesGuest2"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setGuest:self.guest2];
        [[segue destinationViewController] setGuestNumber:[NSNumber numberWithInt:2]];
    }
    if ([segue.identifier isEqualToString:@"DoublesGuest3"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setGuest:self.guest3];
        [[segue destinationViewController] setGuestNumber:[NSNumber numberWithInt:3]];
    }
    if ([segue.identifier isEqualToString:@"DoublesGuest4"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setGuest:self.guest4];
        [[segue destinationViewController] setGuestNumber:[NSNumber numberWithInt:4]];
    }
}

-(void)setGuest:(RHSCGuest *)guest number:(NSNumber *) guestNumber
{
//    NSLog(@"setGuest %@",guestNumber);
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    if ([guestNumber intValue] == 2) {
        if ([guest.name isEqualToString:@""]) {
            self.player2Member = tbc.memberList.TBD;
            self.player2Control.selectedSegmentIndex = 1;
        }
        self.guest2 = guest;
    }
    if ([guestNumber intValue] == 3) {
        if ([guest.name isEqualToString:@""]) {
            self.player3Member = tbc.memberList.TBD;
            self.player3Control.selectedSegmentIndex = 1;
        }
        self.guest3 = guest;
    }
    if ([guestNumber intValue] == 4) {
        if ([guest.name isEqualToString:@""]) {
            self.player4Member = tbc.memberList.TBD;
            self.player4Control.selectedSegmentIndex = 1;
        }
        self.guest4 = guest;
    }
}

-(void)unlockBooking
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve20/IOSUnlockBookingJSON.php?bookingId=%@",[self.courtTimeRecord bookingId]];

//    NSLog(@"fetch URL = %@",fetchURL);
    
    NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    // Get the data
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
}

-(void)bookCourt
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSUpdateBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@&g2name=%@&g2phone=%@&g2email=%@&g3name=%@&g3phone=%@&g3email=%@&g4name=%@&g4phone=%@&g4email=%@&courtEvent=%@",[self.courtTimeRecord bookingId],
                          tbc.currentUser.data.name,
                          self.player2Member?self.player2Member.name:@"",
                          self.player3Member?self.player3Member.name:@"",
                          self.player4Member?self.player4Member.name:@"",
                          tbc.currentUser.data.name,@"iPhone",
                          self.guest2.name,self.guest2.phone,self.guest2.email,
                          self.guest3.name,self.guest3.phone,self.guest3.email,
                          self.guest4.name,self.guest4.phone,self.guest4.email,
                          self.eventType.text];
 
//    NSLog(@"fetch URL = %@",fetchURL);
    
    NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    // Get the data
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error == nil) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonDictionary objectForKey:@"error"] == nil) {
            
            // Get an array of dictionaries with the key "locations"
            // NSArray *array = [jsonDictionary objectForKey:@"user"];

//            NSLog(@"%@",jsonDictionary);
            
            self.successAlert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                      message:@"Court time successfully booked. Notices will be sent to all players"
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.successAlert) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
