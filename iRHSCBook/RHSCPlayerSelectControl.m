//
//  RHSCPlayerSelectControl.m
//  iRHSCBook
//
//  Created by Bruce Hunter on 2014-07-15.
//  Copyright (c) 2014 Richmond Hill Squash Club. All rights reserved.
//

#import "RHSCPlayerSelectControl.h"

@implementation RHSCPlayerSelectControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sendActionsForControlEvents:UIControlEventAllTouchEvents];
    [super touchesEnded:touches withEvent:event];
}

- (void)setSelectedSegmentIndex:(NSInteger)toValue {
    // Trigger UIControlEventValueChanged even when re-tapping the selected segment.
    if (toValue==self.selectedSegmentIndex) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    [super setSelectedSegmentIndex:toValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
