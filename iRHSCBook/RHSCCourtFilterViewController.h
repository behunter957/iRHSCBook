//
//  RHSCCourtFilterViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHSCCourtFilterViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *datePickerArray;

@end
