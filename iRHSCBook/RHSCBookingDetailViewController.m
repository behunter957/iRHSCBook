//
//  RHSCBookingDetailViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-09.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCBookingDetailViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCCourtTime.h"
#import "RHSCMemberList.h"
#import "RHSCMember.h"

@interface RHSCBookingDetailViewController ()

@property (nonatomic, strong) RHSCMember *player1;
@property (nonatomic, strong) RHSCMember *player2;
@property (nonatomic, strong) RHSCMember *player3;
@property (nonatomic, strong) RHSCMember *player4;

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
