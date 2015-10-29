//
//  RHSCGuestDetailsViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-16.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iRHSCBook-Swift.h"
//#import "RHSCGuest.h"

@protocol setGuestProtocol <NSObject>

-(void)setGuest:(RHSCGuest *)guest number:(NSNumber *) guestNumber;

@end

@interface RHSCGuestDetailsViewController : UIViewController

@property (nonatomic, strong) NSNumber* guestNumber;

@property (nonatomic, strong) RHSCGuest *guest;

@property (nonatomic,weak) IBOutlet UITextField *guestNameField;
@property (nonatomic,weak) IBOutlet UITextField *guestEmailField;
@property (nonatomic,weak) IBOutlet UITextField *guestPhoneField;

@property (nonatomic,assign) id delegate;

@end
