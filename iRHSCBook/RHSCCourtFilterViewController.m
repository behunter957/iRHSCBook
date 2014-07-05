//
//  RHSCCourtFilterViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCCourtFilterViewController.h"

@interface RHSCCourtFilterViewController ()

@property (nonatomic, strong) NSMutableArray *dateList;
@property (nonatomic, strong) NSDate* pickedDate;
@property (nonatomic, strong) NSString* pickedSet;

@end

@implementation RHSCCourtFilterViewController

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

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d"];

    NSString *fmtStr = @"%@ courts for %@";
    if ([self.selectionSet isEqualToString:@"Doubles"]) {
        fmtStr = @"%@ court for %@";
    }
    [self.resetButton setTitle:[NSString stringWithFormat:fmtStr,self.selectionSet,[dateFormat stringFromDate:self.selectionDate],nil] forState:UIControlStateNormal];
    
    self.pickedDate = self.selectionDate;
    self.pickedSet = self.selectionSet;
    for (int i = 0; i < self.setSegCtl.numberOfSegments; i++)
    {
        if ([[self.setSegCtl titleForSegmentAtIndex:i] isEqualToString:self.selectionSet]) {
            self.setSegCtl.selectedSegmentIndex = i;
        }
    }
    
    NSMutableArray *dateList = [[NSMutableArray alloc] init];
    NSDate *curDate = [NSDate date];
    for (int i = 0; i < 30; i++) {
        // add
        // [dateList addObject:[dateFormat stringFromDate:curDate]];
        [dateList addObject:curDate];
        
        //increment curDate
        curDate = [curDate dateByAddingTimeInterval:24*60*60];
    }
    self.datePickerArray = [[NSArray alloc] initWithArray:dateList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetSelection:(id)sender
{
    NSLog(@"reset button pushed");
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return self.datePickerArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d"];
    return [dateFormat stringFromDate:[self.datePickerArray objectAtIndex:row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pickedDate = [self.datePickerArray objectAtIndex:row];
}

@synthesize delegate;

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // Navigation button was pressed. Do some stuff
        // set the navigation controller's date and court selection values
        NSLog(@"popping ChangeSeletion");
        [delegate setSetSelection:self.pickedSet];
        [delegate setDateSelection:self.pickedDate];
        [self.navigationController popViewControllerAnimated:NO];
    }
    [super viewWillDisappear:animated];
}

-(IBAction) setChanged {
    NSLog(@"seChanged action");
    self.pickedSet = [self.setSegCtl titleForSegmentAtIndex:self.setSegCtl.selectedSegmentIndex];
}

-(IBAction) includeChanged
{
    if (self.includeSwitch.on) {
        self.switchState.text = @"YES";
    } else {
        self.switchState.text = @"NO";
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
