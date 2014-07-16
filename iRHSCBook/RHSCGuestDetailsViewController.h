//
//  RHSCGuestDetailsViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-16.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setGuestProtocol <NSObject>

-(void)setGuest:(NSString *)name email:(NSString *)email phone:(NSString *)phone number:(NSNumber *) guestNumber;

@end

@interface RHSCGuestDetailsViewController : UIViewController

@property (nonatomic, strong) NSNumber* guestNumber;

@property (nonatomic, strong) NSString *guestName;
@property (nonatomic, strong) NSString *guestEmail;
@property (nonatomic, strong) NSString *guestPhone;

@property (nonatomic,weak) IBOutlet UITextField *guestNameField;
@property (nonatomic,weak) IBOutlet UITextField *guestEmailField;
@property (nonatomic,weak) IBOutlet UITextField *guestPhoneField;

@property (nonatomic,assign) id delegate;

@end
