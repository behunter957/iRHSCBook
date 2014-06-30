//
//  RHSCCourtTime.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSCCourtTime : NSObject

@property (nonatomic, strong, readonly) NSString *bookingId;
@property (nonatomic, strong, readonly) NSString *court;
@property (nonatomic, strong, readonly) NSDate *courtTime;
@property (nonatomic, strong, readwrite) NSString *status;
@property (nonatomic, strong, readwrite) NSMutableArray *playerIdArray;

@end
