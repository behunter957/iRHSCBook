//
//  RHSCMemberList.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMemberList.h"
#import "RHSCMember.h"

@implementation RHSCMemberList

- (void)loadFromJSON:(RHSCServer *)server {
    // Create a NSURLRequest with the given URL
    NSURL *target = [[NSURL alloc] initWithString:@"Reserve/IOSMemberListJSON.php" relativeToURL:server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
	
    // Get the data
    NSURLResponse *response;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // Now create a NSDictionary from the JSON data
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *memList= [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"members"];
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        RHSCMember *member = [[RHSCMember alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [memList addObject:member];
    }
    _memberList = [[NSArray alloc] initWithArray:memList];
}


@end
