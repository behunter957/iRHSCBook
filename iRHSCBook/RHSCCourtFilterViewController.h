//
//  RHSCCourtFilterViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-29.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHSCCourtFilterViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UIPickerView *datePicker;
@property (nonatomic, strong) NSArray *datePickerArray;
@property (nonatomic, strong) NSDate* selectionDate;
@property (nonatomic, strong) NSString* selectionSet;


@end
