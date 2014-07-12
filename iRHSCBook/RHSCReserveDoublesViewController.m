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

@interface RHSCReserveDoublesViewController ()

@end

@implementation RHSCReserveDoublesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder", nil];
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    self.userLabel.text = [NSString stringWithFormat:@"%@ %@",tbc.currentUser.data.firstName,tbc.currentUser.data.lastName];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancel
{
    NSLog(@"exiting ReserveDoubles");
    [self unlockBooking];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) book
{
    NSLog(@"booking doubles court and exiting ReserveDoubles");
    [self unlockBooking];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)setPlayer:(RHSCMember *)setPlayer number:(NSNumber *)playerNumber
{
    NSLog(@"delegate setPlayer %@ to %@",playerNumber,setPlayer.name);
    if (playerNumber.intValue == 2) {
        [self.player2Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
    }
    if (playerNumber.intValue == 3) {
        [self.player3Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
    }
    if (playerNumber.intValue == 4) {
        [self.player4Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue: %@",segue.identifier);
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
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //TODO handle error in locking
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
