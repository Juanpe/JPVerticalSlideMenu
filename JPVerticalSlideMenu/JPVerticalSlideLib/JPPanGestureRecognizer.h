//
//  JPPanGestureRecognizer.h
//  JPVerticalSlideMenu
//
//  Created by Juan Pedro Catalán on 26/01/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

typedef NS_ENUM(NSInteger, JPPanDirection) {
    JPPanDirectionRight,
    JPPanDirectionLeft,
    JPPanDirectionUp,
    JPPanDirectionDown,
    JPPanDirectionUnknow
};

typedef NS_ENUM(NSInteger, JPPanWay) {
    JPPanWayNone,
    JPPanWayHorizontal,
    JPPanWayVertical
};

@interface JPPanGestureRecognizer : UIPanGestureRecognizer <UIGestureRecognizerDelegate>

@property (nonatomic, readonly) JPPanDirection    direction;
@property (nonatomic, readonly) JPPanWay          way;


@end
