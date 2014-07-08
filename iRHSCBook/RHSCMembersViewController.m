//
//  RHSCMembersViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMembersViewController.h"
#import "RHSCTabBarController.h"
#import "RHSCMemberList.h"
#import "RHSCMemberDetailViewController.h"
#import "RHSCMember.h"

@interface RHSCMembersViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation RHSCMembersViewController

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
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    return ml.memberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemberListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    RHSCMember *member = ml.memberList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",member.lastName,member.firstName];
    
    return cell;
}

-(IBAction)phoneMember:(id)sender
{
    // get the currently selected table row
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    RHSCMember *member = ml.memberList[selectedIndexPath.row];
    NSLog(@"Phone member: %@",member.name);
}

-(IBAction)smsMember:(id)sender
{
    // get the currently selected table row
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    RHSCMember *member = ml.memberList[selectedIndexPath.row];
    NSLog(@"SMS member: %@",member.name);
}

-(IBAction)emailMember:(id)sender
{
    // get the currently selected table row
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    RHSCMember *member = ml.memberList[selectedIndexPath.row];
    NSLog(@"Email member: %@",member.name);
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"segue: %@",segue.identifier);
    if ([segue.identifier isEqualToString:@"MemberDetail"]) {
        // set the selectedCourtTime record
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        RHSCMemberList *ml = tbc.memberList;
        RHSCMember *member = ml.memberList[selectedIndexPath.row];
        [[segue destinationViewController] setMember:member];
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
