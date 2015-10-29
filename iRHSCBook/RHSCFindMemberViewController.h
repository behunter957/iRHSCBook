//
//  RHSCFindMemberViewController.h
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-06-30.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iRHSCBook-Swift.h"
//#import "RHSCMember.h"

@protocol setPlayerProtocol <NSObject>

-(void)setPlayer:(RHSCMember *)player number:(NSNumber *) playerNumber;

@end

@interface RHSCFindMemberViewController : UITableViewController

@property (nonatomic, strong) NSNumber* playerNumber;

@property (nonatomic,assign) id delegate;

@end
