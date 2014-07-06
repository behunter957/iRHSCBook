//
//  RHSCUser.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHSCMember.h"

@interface RHSCUser : NSObject

@property (nonatomic, strong, readonly) RHSCMember *data;

-(id)initFromServer:(RHSCServer *)srvr userid:(NSString *)uid password:(NSString *)pwd;

@end
