//
//  RHSCReserveDoublesViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCCourtTime.h"

@protocol reserveDoublesProtocol <NSObject>

-(void)refreshTable;

@end

@interface RHSCReserveDoublesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView *typePicker;
@property (nonatomic, weak) IBOutlet UISegmentedControl *player2Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *player3Control;
@property (nonatomic, weak) IBOutlet UISegmentedControl *player4Control;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *bookButton;
@property (nonatomic, weak) IBOutlet UILabel *courtDate;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, strong) RHSCCourtTime* courtTimeRecord;

@property (nonatomic,assign) id delegate;

@end
