//
//  RHSCCourtTime.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSCCourtTime : NSObject

@property (nonatomic, strong) NSString *bookingId;
@property (nonatomic, strong) NSString *court;
@property (nonatomic, strong) NSDate *courtTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSMutableArray *playerIdArray;

@end
