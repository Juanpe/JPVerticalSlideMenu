//
//  JPVerticalSlideVCProtocols.h
//  JPVerticalSlideMenu
//
//  Created by Juan Pedro Catalán on 24/01/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

@protocol JPVerticalSlideVCDelegate <NSObject>

@optional

/**
 * Called when top VC is going to open
 */
- (void) topVCWillOpen;

/**
 * Called when top VC is already open
 */
- (void) topVCDidOpen;

/**
 * Called when bottom VC is going to open
 */
- (void) bottomVCWillOpen;

/**
 * Called when bottom VC is already open
 */
- (void) bottomVCDidOpen;


/**
 * Called when top VC is going to close
 */
- (void) topVCWillClose;

/**
 * Called when top VC is already closed
 */
- (void) topVCDidClose;

/**
 * Called when bottom VC is going to close
 */
- (void) bottomVCWillClose;

/**
 * Called when bottom VC is going to close
 */
- (void) bottomVCDidClose;

@end
