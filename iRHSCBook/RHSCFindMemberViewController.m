//
//  RHSCFindMemberViewControllerTableViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCFindMemberViewController.h"
#import "RHSCTabBarController.h"

@interface RHSCFindMemberViewController () <UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *filteredList;
@property (nonatomic,weak) IBOutlet UITableView *searchResultsView;
@property (nonatomic,weak) IBOutlet UITableView *memberListView;

@end

@implementation RHSCFindMemberViewController

BOOL searching;

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
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    self.filteredList = [[NSMutableArray alloc] initWithArray:ml.memberList];
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
    if(self.searchDisplayController.searchResultsTableView == tableView) {
        return self.filteredList.count;
    } else {
        // get memberList count
        RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        RHSCMemberList *ml = tbc.memberList;
        return ml.memberList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.searchDisplayController.searchResultsTableView == tableView) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
        RHSCMember *member = self.filteredList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",member.lastName,member.firstName];
        return cell;
    } else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MemberCell" forIndexPath:indexPath];
    
        // Configure the cell...
        RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
        RHSCMemberList *ml = tbc.memberList;
        RHSCMember *member = ml.memberList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@, %@",member.lastName,member.firstName];
        return cell;
    
    }
}

- (void) searchTableView
{
    NSString *searchText = self.searchDisplayController.searchBar.text;
    
    RHSCTabBarController *tbc = (RHSCTabBarController *)self.tabBarController;
    RHSCMemberList *ml = tbc.memberList;
    for (RHSCMember *item in ml.memberList) {
        NSRange range = [item.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.length > 0) {
            [self.filteredList addObject:item];
        }
    }
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    searching = NO;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    searching = NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.filteredList removeAllObjects];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchText
{
    [self.filteredList removeAllObjects];
    
    if ([searchText length] > 1) {
        searching = YES;
        [self searchTableView];
    } else {
        searching = NO;
    }
    return YES;
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
