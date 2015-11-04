//
//  JPTopSegue.m
//  JPVerticalSlideMenu
//
//  Created by Casey Morton on 11/3/15.
//  Copyright © 2015 Juanpe Catalán. All rights reserved.
//

#import "JPTopSegue.h"

@implementation JPTopSegue

-(void) perform {
    if ([[[self sourceViewController] class] isSubclassOfClass:[JPVerticalSlideViewController class]]) {
        JPVerticalSlideViewController *source = [self sourceViewController];
        [source setTopVC:[self destinationViewController]];
    }
}


@end
