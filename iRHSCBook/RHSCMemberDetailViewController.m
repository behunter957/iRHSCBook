//
//  RHSCMemberDetailViewController.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-08.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMemberDetailViewController.h"

@interface RHSCMemberDetailViewController ()

@end

@implementation RHSCMemberDetailViewController

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
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",_member.firstName,_member.lastName];
    self.emailLabel.text = @"";
    self.emailBtn.hidden = YES;
    if (_member.email != (NSString *)[NSNull null]) {
        if (![_member.email isEqualToString:@"NULL"]) {
            self.emailLabel.text = _member.email;
            self.emailBtn.hidden = NO;
        }
    }
    self.phone1Label.text = @"";
    self.ph1SMSBtn.hidden = YES;
    self.ph1CallBtn.hidden = YES;
    if (_member.phone1 != (NSString *)[NSNull null]) {
        if (![_member.phone1 isEqualToString:@"NULL"]) {
            self.phone1Label.text = _member.phone1;
            self.ph1SMSBtn.hidden = NO;
            self.ph1CallBtn.hidden = NO;
        }
    }
    self.phone2Label.text = @"";
    self.ph2SMSBtn.hidden = YES;
    self.ph2CallBtn.hidden = YES;
    if (_member.phone2 != (NSString *)[NSNull null]) {
        if (![_member.phone2 isEqualToString:@"NULL"]) {
            self.phone2Label.text = _member.phone2;
            self.ph2SMSBtn.hidden = NO;
            self.ph2CallBtn.hidden = NO;
        }
    }
    self.memberMessage.layer.borderWidth = 5.0f;
    self.memberMessage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.memberMessage.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
