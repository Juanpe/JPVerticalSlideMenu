//
//  JPPanGestureRecognizer.m
//  JPVerticalSlideMenu
//
//  Created by Juan Pedro Catalán on 26/01/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPPanGestureRecognizer.h"

@implementation JPPanGestureRecognizer

- (JPPanDirection) direction
{
    CGPoint velocity = [self velocityInView:self.view.window];
    if (fabs(velocity.y) > fabs(velocity.x)) {
        if (velocity.y > 0) {
            return JPPanDirectionUp;
        }
        else {
            return JPPanDirectionDown;
        }
    }
    else {
        if (velocity.x > 0) {
            return JPPanDirectionRight;
        }
        else {
            return JPPanDirectionLeft;
        }
    }
}

- (JPPanWay) way
{
    CGPoint velocity = [self velocityInView:self.view.window];
    if (fabs(velocity.y) > fabs(velocity.x)) {
        return JPPanWayVertical;
    }
    else {
        return JPPanWayHorizontal;
    }
}

@end
