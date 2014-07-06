//
//  RHSCMemberList.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHSCServer.h"

@interface RHSCMemberList : NSObject

@property (nonatomic, strong) NSArray *memberList;

- (void)loadFromJSON:(RHSCServer *)server;

@end
