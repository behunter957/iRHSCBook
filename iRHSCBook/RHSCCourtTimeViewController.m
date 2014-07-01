//
//  RHSCCourtTimeViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCCourtTimeViewController.h"
#import "RHSCCourtFilterViewController.h"
#import "RHSCReserveSinglesViewController.h"
#import "RHSCReserveDoublesViewController.h"
#import "RHSCCourtTime.h"

@interface RHSCCourtTimeViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *headerButton;

@property (nonatomic, strong) NSDate* selectionDate;
@property (nonatomic, strong) NSString* selectionSet;
@property (nonatomic, weak) RHSCCourtTime* selectedCourtTime;
@property (nonatomic, strong) NSMutableArray* courtTimes;

@end

@implementation RHSCCourtTimeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.selectionDate = [NSDate date];
        self.selectionSet = @"Singles";
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
    if (!self.selectionDate) {
        self.selectionDate = [NSDate date];
    }
    if (!self.selectionSet) {
        self.selectionSet = @"Singles";
    }
    self.selectedCourtTime = nil;
    
    [self loadSelectedCourtTimes];
    
    [self refreshLeftBarButton];
}

- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}

// action for header button - modal filter view
- (IBAction)changeFilter:(id)sender
{
    NSLog(@"filter button pushed");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSLog(@"Selected row : %d",row);
    self.selectedCourtTime = self.courtTimes[indexPath.row];
    NSString *segueName = @"ReserveSingles";
    if ([[self.courtTimes[indexPath.row] court] isEqualToString:@"Doubles"])
    {
        segueName = @"ReserveDoubles";
    }
   [self performSegueWithIdentifier: segueName sender: self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"ChangeSelection"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setSelectionDate:self.selectionDate];
        [[segue destinationViewController] setSelectionSet:self.selectionSet];
    }
    if ([segue.identifier isEqualToString:@"ReserveSingles"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setCourtTimeRecord:self.selectedCourtTime];
    }
    if ([segue.identifier isEqualToString:@"ReserveDoubles"]) {
        // set the selectedCourtTime record
        [[segue destinationViewController] setCourtTimeRecord:self.selectedCourtTime];
    }
}

-(void)setSetSelection:(NSString *)setSelection
{
    NSLog(@"delegate setSetSelection %@",setSelection);
    self.selectionSet = setSelection;
    [self refreshLeftBarButton];
}

-(void)setDateSelection:(NSDate *)setDate
{
    NSLog(@"delegate setDateSelection %@",setDate);
    self.selectionDate = setDate;
    [self refreshLeftBarButton];
}

-(void)refreshLeftBarButton
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d"];
    
    NSString *fmtStr = @"%@ courts for %@";
    if ([self.selectionSet isEqualToString:@"Doubles"]) {
        fmtStr = @"%@ court for %@";
    }
    self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:fmtStr,self.selectionSet,[dateFormat stringFromDate:self.selectionDate]];
}

-(void)loadSelectedCourtTimes
{
    // temporary code to populate the datasource
    self.courtTimes = [[NSMutableArray alloc] init];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setLocale:[NSLocale systemLocale]];
    [dtFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* curDate = [dtFormatter dateFromString:@"2014-07-01 00:06:00"];
    NSArray* courtNames = [[NSArray alloc] initWithObjects:@"Court 1",@"Court 2",@"Court 3",@"Court 4", @"Doubles", nil];;
    for (int i = 0; i < 20; i++) {
        for (int j = 0; j < courtNames.count; j++) {
            RHSCCourtTime *ct = [[RHSCCourtTime alloc] init];
            [ct setStatus:@"Available"];
            [ct setCourt:courtNames[j]];
            [ct setCourtTime:curDate];
            [self.courtTimes addObject:ct];
        }
        curDate = [curDate dateByAddingTimeInterval:40*60];
    }
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
