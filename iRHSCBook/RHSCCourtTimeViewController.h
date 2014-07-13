//
//  RHSCCourtTimeViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCCourtFilterViewController.h"
#import "RHSCReserveSinglesViewController.h"
#import "RHSCReserveDoublesViewController.h"
#import "RHSCBookingDetailViewController.h"

@interface RHSCCourtTimeViewController : UITableViewController <setSelectionProtocol,reserveSinglesProtocol, reserveDoublesProtocol, cancelBookingProtocol>

@property (nonatomic, weak) IBOutlet UISegmentedControl* selectedSetCtrl;

@end
