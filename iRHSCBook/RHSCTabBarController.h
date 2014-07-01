//
//  RHSCTabBarController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHSCMemberList.h"
#import "RHSCUser.h"
#import "RHSCServer.h"

@interface RHSCTabBarController : UITabBarController

@property (nonatomic, weak) IBOutlet RHSCMemberList *memberList;
@property (nonatomic, weak) IBOutlet RHSCUser *currentUser;
@property (nonatomic, weak) IBOutlet RHSCServer *server;

@end