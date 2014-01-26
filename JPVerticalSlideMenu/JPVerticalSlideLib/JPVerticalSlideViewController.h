//
//  JPVerticalSlideViewController.h
//  Cassette
//
//  Created by Juan Pedro Catalán on 23/01/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPVerticalSlideVCProtocols.h"

typedef NS_ENUM(NSInteger, JPVerticalSlide) {
    JPVerticalSlideTop,
    JPVerticalSlideBottom
};

typedef NS_ENUM(NSInteger, JPVerticalSlideState) {
    JPVerticalSlideClosed,
    JPVerticalSlideTopOpened,
    JPVerticalSlideBottomOpened
};

@interface JPVerticalSlideViewController : UIViewController <UIGestureRecognizerDelegate>

#pragma mark - Properties

@property (weak, nonatomic) id<JPVerticalSlideVCDelegate> slideVCDelegate;

@property (strong, nonatomic) UIViewController *topVC;
@property (strong, nonatomic) UIViewController *mainVC;
@property (strong, nonatomic) UIViewController *bottomVC;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (nonatomic) BOOL topPanDisabled;
@property (nonatomic) BOOL bottomPanDisabled;

@property (nonatomic) JPVerticalSlideState slideState;

#pragma mark - Init Methods

+ (instancetype) verticalSlideMenuWithMainVC:(UIViewController *) mainViewController
                                    andTopVC:(UIViewController *) topViewController
                                 andBottomVC:(UIViewController *) bottomViewController;

#pragma mark - Overridable Public Methods

/**
 * Override this method for setting visible height for top VC.
 * @return The top VC height (Default will return 250)
 */
- (CGFloat) topVCHeight;

/**
 * Override this method for setting visible height for bottom VC.
 * @return The bottom VC height (Default will return 250)
 */
- (CGFloat) bottomVCHeight;

/**
 * Override this method if you want that pan work only on edges of view
 * Default value is 100%
 * @return percentage of pan's working area in view.
 */
- (CGFloat) panGestureWorkingAreaPercent;

#pragma mark -- Actions

/**
 * Opens Top VC by animation
 */
- (void) openTopVC;

/**
 * Opens Top VC
 * @param animated indicates if menu should be openen
 * by animation
 */
- (void) openTopVCAnimated:(BOOL)animated;

/**
 * Opens Bottom VC by animation
 */
- (void) openBottomVC;

/**
 * Opens Bottom VC
 * @param animated indicates if menu should be openen
 * by animation
 */
- (void) openBottomVCAnimated:(BOOL)animated;

/**
 * Closes Top VC by animation
 */
- (void) closeTopVC;

/**
 * Closes Top VC
 * @param animated indicates if menu should be closed
 * by animation
 */
- (void) closeTopVCAnimated:(BOOL)animated;

/**
 * Closes Bottom VC by animation
 */
- (void) closeBottomVC;

/**
 * Closes Bottom VC
 * @param animated indicates if menu should be closed
 * by animation
 */
- (void) closeBottomVCAnimated:(BOOL)animated;

@end