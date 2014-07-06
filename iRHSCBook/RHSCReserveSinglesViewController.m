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
    
    self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder",@"MNHL", nil];
    NSString *courtType = @"Front";
    if ([self.courtTimeRecord.court isEqualToString:@"Court 1"] || [self.courtTimeRecord.court isEqualToString:@"Court 2"])
    {
        courtType = @"Back";
    }
    self.navigationItem.title = [NSString stringWithFormat:@"Book %@ %@",courtType,self.courtTimeRecord.court];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancel
{
    NSLog(@"exiting ReserveSingles");
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self.player2Button setTitle:[NSString stringWithFormat:@"%@ %@",setPlayer.firstName,setPlayer.lastName] forState:UIControlStateNormal];
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
