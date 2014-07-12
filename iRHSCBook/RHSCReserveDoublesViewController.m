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

@property (nonatomic,strong) RHSCMember *player2Member;
@property (nonatomic,strong) RHSCMember *player3Member;
@property (nonatomic,strong) RHSCMember *player4Member;

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
    [self bookCourt];
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
        self.player2Member = setPlayer;
        [self.player2Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
    }
    if (playerNumber.intValue == 3) {
        self.player3Member = setPlayer;
        [self.player3Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
    }
    if (playerNumber.intValue == 4) {
        self.player4Member = setPlayer;
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

-(void)bookCourt
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSUpdateBookingJSON.php?b_id=%@&player1=%@&player2=%@&player3=%@&player4=%@&uid=%@&channel=%@&g2name=%@&g2phone=%@&g2email=%@&g3name=%@&g3phone=%@&g3email=%@&g4name=%@&g4phone=%@&g4email=%@",[self.courtTimeRecord bookingId],
                          tbc.currentUser.data.name,
                          self.player2Member.name,
                          self.player3Member.name,
                          self.player4Member.name,
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
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //TODO handle error in locking
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Get an array of dictionaries with the key "locations"
    // NSArray *array = [jsonDictionary objectForKey:@"user"];
    NSLog(@"%@",jsonDictionary);
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
