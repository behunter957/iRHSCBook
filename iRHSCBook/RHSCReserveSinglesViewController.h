//
//  RHSCReserveSinglesViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCCourtTime.h"

@interface RHSCReserveSinglesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView *typePicker;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, strong) RHSCCourtTime* courtTimeRecord;

@end
