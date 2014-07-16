//
//  RHSCGuestDetailsViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-16.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCGuestDetailsViewController.h"

@interface RHSCGuestDetailsViewController ()

@end

@implementation RHSCGuestDetailsViewController

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
    self.guestNameField.text = self.guestName;
    self.guestEmailField.text = self.guestEmail;
    self.guestPhoneField.text = self.guestPhone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize delegate;

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [delegate setGuest:self.guestNameField.text email:self.guestEmailField.text phone:self.guestPhoneField.text number:self.guestNumber];
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
