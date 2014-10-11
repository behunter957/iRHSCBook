//
//  RHSCCourtTime.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCCourtTime.h"

@implementation RHSCCourtTime

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary forUser:(NSString *)userId {
    if(self = [self init]) {
        // Assign all properties with keyed values from the dictionary
        _bookingId = [jsonDictionary objectForKey:@"booking_id"];
        _court = [jsonDictionary objectForKey:@"court"];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _courtTime = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",[jsonDictionary objectForKey:@"courtdate"],[jsonDictionary objectForKey:@"courttime"]]];
        _status = [jsonDictionary objectForKey:@"courtStatus"];
        _event = [jsonDictionary objectForKey:@"courtEvent"];
        _players = [[NSMutableDictionary alloc] init];
        _bookedForUser = false;
        if ([jsonDictionary objectForKey:@"player1_id"]) {
            if ([[jsonDictionary objectForKey:@"player1_id"] isKindOfClass:[NSString class]] ) {
                if ([[jsonDictionary objectForKey:@"player1_id"] isEqualToString:userId]) {
                    _bookedForUser = true;
                }
            }
            if ([jsonDictionary  objectForKey:@"player1_lname"]) {
                [_players setValue:[jsonDictionary objectForKey:@"player1_id"] forKey:@"player1_id"];
                [_players setValue:[jsonDictionary objectForKey:@"player1_lname"] forKey:@"player1_lname"];
            } else {
                [_players setValue:@"" forKey:@"player1_id"];
                [_players setValue:@"" forKey:@"player1_lname"];
            }
        } else {
            [_players setValue:@"" forKey:@"player1_id"];
            [_players setValue:@"" forKey:@"player1_lname"];
        }
        if ([jsonDictionary objectForKey:@"player2_id"]) {
            if ([[jsonDictionary objectForKey:@"player2_id"] isKindOfClass:[NSString class]] ) {
                if ([[jsonDictionary objectForKey:@"player2_id"] isEqualToString:userId]) {
                    _bookedForUser = true;
                }
            }
            if ([jsonDictionary  objectForKey:@"player2_lname"]) {
                [_players setValue:[jsonDictionary objectForKey:@"player2_id"] forKey:@"player2_id"];
                [_players setValue:[jsonDictionary objectForKey:@"player2_lname"] forKey:@"player2_lname"];
            } else {
                [_players setValue:@"" forKey:@"player2_id"];
                [_players setValue:@"" forKey:@"player2_lname"];
            }
        } else {
            [_players setValue:@"" forKey:@"player2_id"];
            [_players setValue:@"" forKey:@"player2_lname"];
        }
        if ([jsonDictionary objectForKey:@"player3_id"]) {
            if ([[jsonDictionary objectForKey:@"player3_id"] isKindOfClass:[NSString class]] ) {
                if ([[jsonDictionary objectForKey:@"player3_id"] isEqualToString:userId]) {
                    _bookedForUser = true;
                }
            }
            if ([jsonDictionary  objectForKey:@"player3_lname"]) {
                [_players setValue:[jsonDictionary objectForKey:@"player3_id"] forKey:@"player3_id"];
                [_players setValue:[jsonDictionary objectForKey:@"player3_lname"] forKey:@"player3_lname"];
            } else {
                [_players setValue:@"" forKey:@"player3_id"];
                [_players setValue:@"" forKey:@"player3_lname"];
            }
        } else {
            [_players setValue:@"" forKey:@"player3_id"];
            [_players setValue:@"" forKey:@"player3_lname"];
        }
        if ([jsonDictionary objectForKey:@"player4_id"]) {
            if ([[jsonDictionary objectForKey:@"player4_id"] isKindOfClass:[NSString class]] ) {
                if ([[jsonDictionary objectForKey:@"player4_id"] isEqualToString:userId]) {
                    _bookedForUser = true;
                }
            }
            if ([jsonDictionary  objectForKey:@"player4_lname"]) {
                [_players setValue:[jsonDictionary objectForKey:@"player4_id"] forKey:@"player4_id"];
                [_players setValue:[jsonDictionary objectForKey:@"player4_lname"] forKey:@"player4_lname"];
            } else {
                [_players setValue:@"" forKey:@"player4_id"];
                [_players setValue:@"" forKey:@"player4_lname"];
            }
        } else {
            [_players setValue:@"" forKey:@"player4_id"];
            [_players setValue:@"" forKey:@"player4_lname"];
        }
    }
    return self;
}

@end
