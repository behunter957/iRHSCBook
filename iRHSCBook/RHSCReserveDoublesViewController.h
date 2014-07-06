//
//  RHSCReserveDoublesViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCCourtTime.h"

@interface RHSCReserveDoublesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView *typePicker;
@property (nonatomic, weak) IBOutlet UIButton *player2Button;
@property (nonatomic, weak) IBOutlet UIButton *player3Button;
@property (nonatomic, weak) IBOutlet UIButton *player4Button;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, strong) RHSCCourtTime* courtTimeRecord;

@end
