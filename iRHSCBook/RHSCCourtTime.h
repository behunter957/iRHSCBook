//
//  RHSCCourtTime.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSCCourtTime : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (nonatomic, strong) NSString *bookingId;
@property (nonatomic, strong) NSString *court;
@property (nonatomic, strong) NSDate *courtTime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *event;
@property (nonatomic, strong) NSDictionary *players;
//eventDesc
//noshow
@end
