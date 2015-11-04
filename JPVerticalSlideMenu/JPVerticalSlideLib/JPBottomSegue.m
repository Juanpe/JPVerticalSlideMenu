//
//  JPBottomSegue.m
//  JPVerticalSlideMenu
//
//  Created by Casey Morton on 11/3/15.
//  Copyright © 2015 Juanpe Catalán. All rights reserved.
//

#import "JPBottomSegue.h"

@implementation JPBottomSegue

-(void) perform {
    if ([[[self sourceViewController] class] isSubclassOfClass:[JPVerticalSlideViewController class]]) {
        JPVerticalSlideViewController *source = [self sourceViewController];
        [source setBottomVC:[self destinationViewController]];
    }
}

@end
