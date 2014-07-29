//
//  RHSCCourtTimeTableViewCell.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-28.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHSCCourtTimeTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *courtAndTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeAndPlayersLabel;

@end
