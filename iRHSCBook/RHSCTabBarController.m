//
//  RHSCTabBarController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCTabBarController.h"
#import "Reachability.h"

@interface RHSCTabBarController () 

@end

@implementation RHSCTabBarController

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
    
//    NSLog(@"URL = %@",[defaults stringForKey:@"RHSCServerURL"]);
//    NSLog(@"UserID = %@",[defaults stringForKey:@"RHSCUserID"]);
//    NSLog(@"Password = %@",[defaults stringForKey:@"RHSCPassword"]);
//    NSLog(@"CourtSet = %@",[defaults stringForKey:@"RHSCCourtSet"]);
//    NSLog(@"IncludeBookings = %@",[defaults stringForKey:@"RHSCIncludeBookings"]);
    self.courtSet = [defaults stringForKey:@"RHSCCourtSet"];
    self.includeBookings = [NSNumber numberWithBool:[defaults boolForKey:@"RHSCIncludeBookings"]];
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
    } else {
        NSLog(@"There IS internet connection");
    }    self.server = [[RHSCServer alloc] initWithString:[NSString stringWithFormat:@"http://%@",[defaults stringForKey:@"RHSCServerURL"]]];
    self.currentUser = [[RHSCUser alloc] initFromServer:self.server userid:[defaults stringForKey:@"RHSCUserID"] password:[defaults stringForKey:@"RHSCPassword"]];
    self.memberList = [[RHSCMemberList alloc] init];
    if (![self.currentUser isLoggedOn]) {
        [self.view setUserInteractionEnabled:NO];
        // if not found then logon failes
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logon Failed"
                                                        message:@"Please check settings and provide a valid userid and password."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.memberList loadFromJSON:self.server];
        if (![self.memberList loadedSuccessfully]) {
            [self.view setUserInteractionEnabled:NO];
            // if not found then logon failes
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Members Failed"
                                                            message:@"Please check settings and restart iRHSCBook or contact administrator."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) validateUser
{
    
}

-(void)loadMembers:(RHSCMember *)user
{
    
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
