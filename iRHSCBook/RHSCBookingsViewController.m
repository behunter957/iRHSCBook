//
//  RHSCBookingsViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCBookingsViewController.h"
#import "RHSCBookingDetailViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCMyBookingsList.h"
#import "RHSCCourtTime.h"
#import "RHSCServer.h"
#import "RHSCMember.h"
#import "RHSCUser.h"

@interface RHSCBookingsViewController () <cancelBookingProtocol>

@property (nonatomic, strong) RHSCMyBookingsList *bookingList;
@property (nonatomic, strong) RHSCCourtTime *selectedBooking;

@end

@implementation RHSCBookingsViewController

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
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self refreshTable];
}

-(void)refreshTable
{
    self.bookingList = [[RHSCMyBookingsList alloc] init];
    // now get the booking list for the current user
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    [self.bookingList loadFromJSON:tbc.server user:tbc.currentUser];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    return self.bookingList.bookingList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyBookingCell" forIndexPath:indexPath];
    
    // Configure the cell...
    RHSCCourtTime *ct = self.bookingList.bookingList[indexPath.row];
    NSDateFormatter* dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"EEE, MMMM d - h:mm a"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",ct.court,
                           [dtFormatter stringFromDate:ct.courtTime]];
    if ([ct.court isEqualToString:@"Court 5"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@,%@,%@,%@",@"Doubles",
                                 [ct.players objectForKey:@"player1_lname"],[ct.players objectForKey:@"player2_lname"],[ct.players objectForKey:@"player3_lname"],[ct.players objectForKey:@"player4_lname"]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@,%@",ct.event,
                                     [ct.players objectForKey:@"player1_lname"],[ct.players objectForKey:@"player2_lname"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSLog(@"Selected row : %d",row);
    self.selectedBooking = self.bookingList.bookingList[indexPath.row];
    NSString *segueName = @"BookingDetail";
    [self performSegueWithIdentifier: segueName sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"BookingDetail"]) {
        // set the selectionSet and selectionDate properties
        [[segue destinationViewController] setDelegate:self];
        [[segue destinationViewController] setBooking:self.selectedBooking];
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
