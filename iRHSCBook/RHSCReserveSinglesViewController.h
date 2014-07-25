//
//  RHSCReserveSinglesViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCCourtTime.h"

@protocol reserveSinglesProtocol <NSObject>

-(void)refreshTable;

@end

@interface RHSCReserveSinglesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIPickerView *typePicker;

@property (nonatomic, weak) IBOutlet UISegmentedControl *player2Control;

@property (nonatomic, weak) IBOutlet UITextField *eventType;

@property (nonatomic, weak) IBOutlet UIButton *cancelButton;
@property (nonatomic, weak) IBOutlet UIButton *bookButton;
@property (nonatomic, weak) IBOutlet UILabel *courtDate;
@property (nonatomic, weak) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) NSArray *typeList;
@property (nonatomic, strong) RHSCCourtTime* courtTimeRecord;

@property (nonatomic,assign) id delegate;

@end
