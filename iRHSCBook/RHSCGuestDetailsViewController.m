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
    self.guestNameField.text = self.guest.name;
    self.guestEmailField.text = self.guest.email;
    self.guestPhoneField.text = self.guest.phone;
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
    self.guest.name = self.guestNameField.text;
    self.guest.email = self.guestEmailField.text;
    self.guest.phone = self.guestPhoneField.text;
    [delegate setGuest:self.guest number:self.guestNumber];
}

-(IBAction)clear
{
    self.guestNameField.text = @"";
    self.guestEmailField.text = @"";
    self.guestPhoneField.text = @"";
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
