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

@property (nonatomic, strong) IBOutlet RHSCMemberList *memberList;
@property (nonatomic, strong) IBOutlet RHSCUser *currentUser;
@property (nonatomic, strong) IBOutlet RHSCServer *server;

@end