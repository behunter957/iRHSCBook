//
//  RHSCReserveDoublesViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCReserveDoublesViewController.h"

@interface RHSCReserveDoublesViewController ()

@end

@implementation RHSCReserveDoublesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.typeList = [[NSArray alloc] initWithObjects:@"Friendly",@"Lesson",@"Ladder", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) cancel
{
    NSLog(@"exiting ReserveDoubles");
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) book
{
    NSLog(@"booking doubles court and exiting ReserveDoubles");
    [self.navigationController popViewControllerAnimated:YES];
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
