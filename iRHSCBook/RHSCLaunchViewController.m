//
//  RHSCLaunchViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-12.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCLaunchViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCUser.h"
#import "RHSCServer.h"

@interface RHSCLaunchViewController ()

@end

@implementation RHSCLaunchViewController

RHSCServer *srvr;
RHSCUser *usr;
NSString *courtSet;
bool includeBookings;

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
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // validate logon
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    NSUserDefaults *defaults = [NSUserDefaults  standardUserDefaults];
    
    NSLog(@"URL = %@",[defaults stringForKey:@"RHSCServerURL"]);
    NSLog(@"UserID = %@",[defaults stringForKey:@"RHSCUserID"]);
    NSLog(@"Password = %@",[defaults stringForKey:@"RHSCPassword"]);
    NSLog(@"CourtSet = %@",[defaults stringForKey:@"RHSCCourtSet"]);
    NSLog(@"IncludeBookings = %@",[defaults stringForKey:@"RHSCIncludeBookings"]);
    courtSet = [defaults stringForKey:@"RHSCCourtSet"];
    includeBookings = [defaults boolForKey:@"RHSCIncludeBookings"];
    srvr = [[RHSCServer alloc] initWithString:[NSString stringWithFormat:@"http://%@",[defaults stringForKey:@"RHSCServerURL"]]];
    usr = [[RHSCUser alloc] initFromServer:srvr userid:[defaults stringForKey:@"RHSCUserID"] password:[defaults stringForKey:@"RHSCPassword"]];
    if (![usr isLoggedOn]) {
        // if not found then logon failes
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logon Failed"
                                                        message:@"Please check settings and provide a valid userid and password."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        //segue to the tabbar controller
        [self performSegueWithIdentifier: @"LaunchApp" sender: self];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"LaunchApp"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setServer:srvr];
        [[segue destinationViewController] setCurrentUser:usr];
        [[segue destinationViewController] setCourtSet:courtSet];
        [[segue destinationViewController] setIncludeBookings:[NSNumber numberWithBool:includeBookings]];
    }

}

@end
