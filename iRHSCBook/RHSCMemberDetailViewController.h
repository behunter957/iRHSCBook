//
//  RHSCMemberDetailViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-08.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCMember.h"

@interface RHSCMemberDetailViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *emailLabel;
@property (nonatomic,weak) IBOutlet UILabel *phone1Label;
@property (nonatomic,weak) IBOutlet UILabel *phone2Label;
@property (nonatomic,weak) IBOutlet UIButton *emailBtn;
@property (nonatomic,weak) IBOutlet UIButton *ph1SMSBtn;
@property (nonatomic,weak) IBOutlet UIButton *ph1CallBtn;
@property (nonatomic,weak) IBOutlet UIButton *ph2SMSBtn;
@property (nonatomic,weak) IBOutlet UIButton *ph2CallBtn;
@property (nonatomic,weak) IBOutlet UITextView *memberMessage;

@property (nonatomic, strong) RHSCMember* member;

@end
