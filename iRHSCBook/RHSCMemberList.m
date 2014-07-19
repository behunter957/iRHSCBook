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

bool isLoaded = false;

- (void)loadFromJSON:(RHSCServer *)server {
    // Create a NSURLRequest with the given URL
    NSString *logonURL = [NSString stringWithFormat:@"Reserve/IOSMemberListJSON.php"];
    NSURL *target = [[NSURL alloc] initWithString:logonURL relativeToURL:server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
    // Get the data
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error == nil) {
        [self loadFromData:data];
    }
}

- (void)loadFromData:(NSData *)data {
    // Now create a NSDictionary from the JSON data
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *memList= [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"members"];
    self.TBD = nil;
    self.GUEST = nil;
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        RHSCMember *member = [[RHSCMember alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        if ([member.name isEqualToString:@"TBD"]) {
            self.TBD = member;
            continue;
        }
        if ([member.name isEqualToString:@"Guest"]) {
            self.GUEST = member;
            continue;
        }
        [memList addObject:member];
    }
    _memberList = [[NSArray alloc] initWithArray:memList];
    isLoaded = (self.memberList.count != 0);
    if (self.TBD == nil) {
        self.TBD = [[RHSCMember alloc] initWithName:@"TBD" type:@"TBD"];
    }
    if (self.GUEST == nil) {
        self.GUEST = [[RHSCMember alloc] initWithName:@"Guest" type:@"Guest"];
    }
}

-(RHSCMember *)find:(NSString *)name
{
    for (RHSCMember *tst in self.memberList) {
        if ([name isEqualToString:[tst name]]) {
            return tst;
        }
    }
    return nil;
}

-(BOOL)loadedSuccessfully
{
    return isLoaded;
}


@end
