//
//  RHSCMyBookingsList.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-08.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCMyBookingsList.h"
#import "RHSCTabBarController.h"
#import "RHSCCourtTime.h"
#import "RHSCUser.h"

@implementation RHSCMyBookingsList

- (void)loadFromJSON:(RHSCServer *)server user:(RHSCUser *)curUser {
    // Create a NSURLRequest with the given URL
    NSString *fetchURL = [NSString stringWithFormat:@"Reserve20/IOSMyBookingsJSON.php?uid=%@",curUser.data.name];

//    NSLog(@"fetch URL = %@",fetchURL);
    
    NSURL *target = [[NSURL alloc] initWithString:fetchURL relativeToURL:server];
    NSURLRequest *request = [NSURLRequest requestWithURL:[target absoluteURL]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
	
    // Get the data
    NSURLResponse *response;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    // Now create a NSDictionary from the JSON data
    [self loadFromData:data forUser:curUser.data.name];
}

- (void)loadFromData:(NSData *) data forUser:(NSString *)userId {
    // Create a NSURLRequest with the given URL
    // Now create a NSDictionary from the JSON data
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *bookList = [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"bookings"];
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        RHSCCourtTime *booking = [[RHSCCourtTime alloc] initWithJSONDictionary:dict forUser:userId];
        // Add the Location object to the array
        [bookList addObject:booking];
    }
    _bookingList = [[NSArray alloc] initWithArray:bookList];
}

@end
