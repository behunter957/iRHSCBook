//
//  RHSCMember.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMember.h"

@implementation RHSCMember

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        //_title = [jsonDictionary objectForKey:@"title"];
    }
    
    return self;
}

@end
