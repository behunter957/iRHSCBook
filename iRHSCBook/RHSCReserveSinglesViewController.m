//
//  RHSCReserveSinglesViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCReserveSinglesViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCFindMemberViewController.h"
#import "RHSCMember.h"

@interface RHSCReserveSinglesViewController ()
@property (nonatomic,strong) RHSCMember *player2Member;
@property (nonatomic,strong) UIAlertView *successAlert;
@property (nonatomic,strong) UIAlertView *errorAlert;


@end

@implementation RHSCReserveSinglesViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder",@"MNHL", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    self.userLabel.text = [NSString stringWithFormat:@"%@ %@",tbc.currentUser.data.firstName,tbc.currentUser.data.lastName];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d - h:mm a"];
    self.courtDate.text = [dateFormat stringFromDate:self.courtTimeRecord.courtTime];
    
    self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder",@"MNHL", nil];
    
    NSString *courtType = @"Front";
    if ([self.courtTimeRecord.court isEqualToString:@"Court 1"] || [self.courtTimeRecord.court isEqualToString:@"Court 2"])
    {
        courtType = @"Back";
    }
    self.navigationItem.title = [NSString stringWithFormat:@"Book %@ %@",courtType,self.courtTimeRecord.court];
    self.player2Control.selectedSegmentIndex = -1;
}

@synthesize delegate;

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unlockBooking];
    [delegate refreshTable];
}

- (IBAction) cancel
{
    NSLog(@"exiting ReserveSingles");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) book
{
    NSLog(@"booking singles court and exiting ReserveSingles");
    [self bookCourt];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction) playerClicked:(id)sender
{
    NSLog(@"segment clicked = %ld",(long) self.player2Control.selectedSegmentIndex);
    if (self.player2Control.selectedSegmentIndex == 0) {
        self.player2Control.selectedSegmentIndex = -1;
        NSString *segueName = @"SinglesPlayer2";
        [self performSegueWithIdentifier: segueName sender: self];
    }
    [self.player2Control setTitle:@"Select Member" forSegmentAtIndex:0];
}

-(void)setPlayer:(RHSCMember *)setPlayer number:(NSNumber *)playerNumber
{
    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
    self.player2Member = setPlayer;
    NSString *newTitle = [NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName];
    [self.player2Button setTitle:newTitle forState:UIControlStateNormal];
    [self.player2Control setTitle:newTitle forSegmentAtIndex:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"SinglesPlayer"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setPlayerNumber:[NSNumber numberWithInt:2]];
    }
    if ([segue.identifier isEqualToString:@"SinglesPlayer2"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setPlayerNumber:[NSNumber numberWithInt:2]];
    }
}

-(void)unlockBooking
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSUnlockBookingJSON.php?bookingId=%@",[self.courtTimeRecord bookingId]];
    NSLog(@"fetch URL = %@",fetchURL);
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
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSUpdateBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@&g2name=%@&g2phone=%@&g2email=%@&g3name=%@&g3phone=%@&g3email=%@&g4name=%@&g4phone=%@&g4email=%@",[self.courtTimeRecord bookingId],
                          tbc.currentUser.data.name,
                          self.player2Member.name,@"",@"",
                          tbc.currentUser.data.name,@"iPhone",
                          @"",@"",@"",
                          @"",@"",@"",
                          @"",@"",@""
                          ];
    NSLog(@"fetch URL = %@",fetchURL);
    NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    // Get the data
    NSURLResponse *response;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //TODO handle error in locking
    if (error == nil) {
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([jsonDictionary objectForKey:@"error"] == nil) {
            
            // Get an array of dictionaries with the key "locations"
            // NSArray *array = [jsonDictionary objectForKey:@"user"];
            NSLog(@"%@",jsonDictionary);
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
