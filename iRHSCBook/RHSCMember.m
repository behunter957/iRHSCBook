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
        _name  = [jsonDictionary objectForKey:@"id"];
        _firstName  = [jsonDictionary objectForKey:@"fname"];
        _lastName  = [jsonDictionary objectForKey:@"lname"];
        _email  = [jsonDictionary objectForKey:@"email"];
        _phone1  = [jsonDictionary objectForKey:@"primary_phone"];
        _phone2  = [jsonDictionary objectForKey:@"home_phone"];
        _status  = [jsonDictionary objectForKey:@"status"];
        _type  = [jsonDictionary objectForKey:@"member_type"];
//  unused table columns
//        "work_phone"
//        "cell_phone"
//        "family_primary"
//        "want_email"
//        "want_calendar"
//        "rating"
//        "rating_date"
//        "Kfactor"
//        "prev_rating"
//        "prev_rdate"
//        "nscores"
//        "ntnmt"
//        "prev_Kfactor"
    }
    
    return self;
}



@end
