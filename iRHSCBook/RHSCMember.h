//
//  RHSCMember.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSCMember : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property (readonly) NSString *name;
@property (readonly) NSString *email;
@property (readonly) NSString *phone1;
@property (readonly) NSString *phone2;
@property (readonly) NSString *type;
@property (readonly) NSString *status;
@property (readonly) NSString *firstName;
@property (readonly) NSString *lastName;

@end
