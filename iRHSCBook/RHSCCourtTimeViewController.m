//
//  RHSCCourtTimeViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCCourtTimeViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCCourtTime.h"
#import "RHSCMember.h"

@interface RHSCCourtTimeViewController () 

@property (nonatomic, weak) IBOutlet UIBarButtonItem *headerButton;

@property (nonatomic, strong) NSDate* selectionDate;
@property (nonatomic, strong) NSString* selectionSet;
@property (nonatomic, weak) RHSCCourtTime* selectedCourtTime;
@property (nonatomic, strong) NSMutableArray* courtTimes;
@property (nonatomic, strong) NSString* includeInd;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic,strong) UIAlertView *successAlert;
@property (nonatomic,strong) UIAlertView *errorAlert;
@end

@implementation RHSCCourtTimeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    /*
     
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
     
     */
    
//TODO: replace code with preferences
    if (!self.selectionDate) {
        self.selectionDate = [NSDate date];
    }

    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    self.selectionSet = tbc.courtSet;
    self.includeInd = [tbc.includeBookings boolValue]?@"YES":@"NO";
    self.selectedCourtTime = nil;
    
//    [self loadSelectedCourtTimes];
    
    [self refreshLeftBarButton];

    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
}

-(void) viewDidAppear:(BOOL)animated
{
//    NSLog(@"CourtTime viewDidAppear");
    [self refreshLeftBarButton];
    [self refreshTable];
}


- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unwindFromReserve:(UIStoryboardSegue *)segue
{
//    NSLog(@"returning from Reserve");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.courtTimes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableSinglesViewCell"];
    
    RHSCCourtTime *ct = self.courtTimes[indexPath.row];
    
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setLocale:[NSLocale systemLocale]];
    [dtFormatter setDateFormat:@"h:mm a"];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",ct.court,
                           [dtFormatter stringFromDate:ct.courtTime]];
    cell.detailTextLabel.text = ct.status;
    if ([ct.status isEqualToString:@"Booked"]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor blueColor];
    }
    return cell;
}

// action for header button - modal filter view
- (IBAction)changeFilter:(id)sender
{
//    NSLog(@"filter button pushed");
}

- (IBAction)syncCourts:(id)sender
{
    [self.refreshControl endRefreshing];
    [self asyncLoadSelectedCourtTimes];
//    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
//    NSLog(@"Selected row : %d",row);
    self.selectedCourtTime = self.courtTimes[indexPath.row];
    if ([self.selectedCourtTime.status isEqualToString:@"Available"]) {
        // lock the booking
        RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        RHSCUser *curUser = tbc.currentUser;
        NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSLockBookingJSON.php?bookingId=%@&uid=%@",[self.selectedCourtTime bookingId],curUser.data.name];
//        NSLog(@"fetch URL = %@",fetchURL);
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
                // determine the correct view to navigate to
                NSString *segueName = @"ReserveSingles";
                if ([[self.courtTimes[indexPath.row] court] isEqualToString:@"Court 5"])
                {
                    segueName = @"ReserveDoubles";
                }
                [self performSegueWithIdentifier: segueName sender: self];
            } else {
                self.errorAlert = [[UIAlertView alloc] initWithTitle:@"Error locking the booking"
                                                             message:[jsonDictionary objectForKey:@"error"]
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
                [self.errorAlert show];
            }
            // check for an error return
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network error"
                                                            message:@"Unable to lock the court"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else {
        NSString *segueName = @"CancelFromAvailable";
        [self performSegueWithIdentifier: segueName sender: self];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"ChangeSelection"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setSelectionDate:self.selectionDate];
        [[segue destinationViewController] setSelectionSet:self.selectionSet];
        [[segue destinationViewController] setIncludeInd:self.includeInd];
    }
    if ([segue.identifier isEqualToString:@"ReserveSingles"]) {
        // lock the court
        // set the selectedCourtTime record
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setCourtTimeRecord:self.selectedCourtTime];
    }
    if ([segue.identifier isEqualToString:@"ReserveDoubles"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setCourtTimeRecord:self.selectedCourtTime];
    }
    if ([segue.identifier isEqualToString:@"CancelFromAvailable"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setBooking:self.selectedCourtTime];
    }
}

-(void)setSetSelection:(NSString *)setSelection
{
//    NSLog(@"delegate setSetSelection %@",setSelection);
    self.selectionSet = setSelection;
    [self refreshLeftBarButton];
}

-(void)setDateSelection:(NSDate *)setDate
{
//    NSLog(@"delegate setDateSelection %@",setDate);
    self.selectionDate = setDate;
    [self refreshLeftBarButton];
}

-(void)setInclude:(NSString *)setSwitch
{
//    NSLog(@"delegate setInclude %@",setSwitch);
    self.includeInd = setSwitch;
//    [self loadSelectedCourtTimes];
//    [self.tableView reloadData];
}

-(void)refreshLeftBarButton
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMM d"];
    
    NSString *fmtStr = @"%@ courts for %@";
    if ([self.selectionSet isEqualToString:@"Doubles"]) {
        fmtStr = @"%@ court for %@";
    }
    self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:fmtStr,self.selectionSet,[dateFormat stringFromDate:self.selectionDate]];
}

-(void)asyncLoadSelectedCourtTimes
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCUser *curUser = tbc.currentUser;
    if ([curUser isLoggedOn]) {
        NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setLocale:[NSLocale systemLocale]];
        [dtFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *curDate = [dtFormatter stringFromDate:self.selectionDate];
        
        NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",curDate,self.selectionSet,self.includeInd,curUser.data.name];
        
        NSLog(@"fetch URL = %@",fetchURL);
        
        NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
        // Get the data
        NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:30.0];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    // handle response
                    // Now create a NSDictionary from the JSON data
                    if (error == nil) {
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        // Create a new array to hold the locations
                        self.courtTimes = [[NSMutableArray alloc] init];
                        
                        // Get an array of dictionaries with the key "locations"
                        NSArray *array = [jsonDictionary objectForKey:@"courtTimes"];
                        // Iterate through the array of dictionaries
                        for(NSDictionary *dict in array) {
                            // Create a new Location object for each one and initialise it with information in the dictionary
                            RHSCCourtTime *courtTimeObj = [[RHSCCourtTime alloc] initWithJSONDictionary:dict];
                            // Add the court time object to the array
                            [self.courtTimes addObject:courtTimeObj];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        [self.tableView reloadData];
                    });
                }] resume];
    }
}

-(void)loadSelectedCourtTimes
{
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCUser *curUser = tbc.currentUser;
    if ([curUser isLoggedOn]) {
        NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setLocale:[NSLocale systemLocale]];
        [dtFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *curDate = [dtFormatter stringFromDate:self.selectionDate];
        
        NSString *fetchURL = [NSString stringWithFormat:@"Reserve/IOSTimesJSON.php?scheddate=%@&courttype=%@&include=%@&uid=%@",curDate,self.selectionSet,self.includeInd,curUser.data.name];
        
//        NSLog(@"fetch URL = %@",fetchURL);
        
        NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:tbc.server];
        NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:30.0];
        
        // Get the data
        NSURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        // Now create a NSDictionary from the JSON data
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // Create a new array to hold the locations
        self.courtTimes = [[NSMutableArray alloc] init];
        
        // Get an array of dictionaries with the key "locations"
        NSArray *array = [jsonDictionary objectForKey:@"courtTimes"];
        // Iterate through the array of dictionaries
        for(NSDictionary *dict in array) {
            // Create a new Location object for each one and initialise it with information in the dictionary
            RHSCCourtTime *courtTimeObj = [[RHSCCourtTime alloc] initWithJSONDictionary:dict];
            // Add the court time object to the array
            [self.courtTimes addObject:courtTimeObj];
        }
    }
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self asyncLoadSelectedCourtTimes];
//    [self.tableView reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
