//
//  RHSCBookingDetailViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-09.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCUser.h"
#import "RHSCCourtTime.h"

@protocol cancelBookingProtocol <NSObject>

-(void)refreshTable;

@end

@interface RHSCBookingDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *courtAndTime;
@property (nonatomic, weak) IBOutlet UILabel *eventLabel;
@property (nonatomic, weak) IBOutlet UILabel *player1Label;
@property (nonatomic, weak) IBOutlet UILabel *player2Label;
@property (nonatomic, weak) IBOutlet UILabel *player3Label;
@property (nonatomic, weak) IBOutlet UILabel *player4Label;

@property (nonatomic,strong) RHSCUser *user;
@property (nonatomic,strong) RHSCCourtTime *booking;

@property (nonatomic,assign) id delegate;

@end
