//
//  RHSCUser.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCUser.h"

@interface RHSCUser ()

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *password;


@end

@implementation RHSCUser

BOOL loggedOn = NO;

-(id)initFromServer:(RHSCServer *)srvr userid:(NSString *)uid password:(NSString *)pwd
{
    self = [super init];
    self.userid = uid;
    self.password = pwd;
    _data = [self userFromJSON:srvr userid:self.userid password:self.password];
    return self;
}

- (RHSCMember *)userFromJSON:(RHSCServer *)server userid:(NSString *)uid password:(NSString *)pwd
{
    // Create a NSURLRequest with the given URL
    NSString *logonURL = [NSString stringWithFormat:@"Reserve/IOSUserLogonJSON.php?uid=%@&pwd=%@",uid,pwd];
    NSURL *target = [[NSURL alloc] initWithString:logonURL relativeToURL:server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
	
    // Get the data
    NSError *error;
    NSURLResponse *response;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error == nil) {
        // Now create a NSDictionary from the JSON data
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // Get an array of dictionaries with the key "locations"
        NSArray *array = [jsonDictionary objectForKey:@"user"];
        // Iterate through the array of dictionaries
        for(NSDictionary *dict in array) {
            // Create a new Location object for each one and initialise it with information in the dictionary
            loggedOn = YES;
            return [[RHSCMember alloc] initWithJSONDictionary:dict];
        }
    }
    return nil;
}

-(BOOL)isLoggedOn
{
    return loggedOn;
}

@end
