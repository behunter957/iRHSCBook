//
//  RHSCMyBookingsList.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-08.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHSCServer.h"
#import "RHSCUser.h"

@interface RHSCMyBookingsList : NSObject

@property (nonatomic, strong) NSArray *bookingList;

- (void)loadFromJSON:(RHSCServer *)server user:(RHSCUser *)curUser;
- (void)loadFromData:(NSData *) data forUser:(NSString *)userId;

@end
