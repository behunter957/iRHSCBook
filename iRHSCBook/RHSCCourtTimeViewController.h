//
//  RHSCCourtTimeViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCReserveSinglesViewController.h"
#import "RHSCReserveDoublesViewController.h"
//#import "RHSCBookingDetailViewController.h"

@interface RHSCCourtTimeViewController : UITableViewController <reserveSinglesProtocol, reserveDoublesProtocol, cancelBookingProtocol>

@property (nonatomic, weak) IBOutlet UISegmentedControl* selectedSetCtrl;

@property (nonatomic, weak) IBOutlet UITextField *courtSet;
@property (nonatomic, weak) IBOutlet UITextField *selectionDay;
@property (nonatomic, weak) IBOutlet UISwitch *incBookings;

@end
