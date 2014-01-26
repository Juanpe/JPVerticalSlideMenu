//
//  JPVerticalSlideViewController.m
//  Cassette
//
//  Created by Juan Pedro Catalán on 23/01/14.
//  Copyright (c) 2014 Juanpe Catalán. All rights reserved.
//

#import "JPVerticalSlideViewController.h"

static const CGFloat kPanMinTranslationY            = 15.0f;

static const CGFloat kSlideOpenAnimationDuration    = 0.3f;
static const CGFloat kSlideCloseAnimationDuration   = 0.3f;

typedef NS_ENUM(NSInteger, JPVerticalSlidePanningState) {
    JPVerticalSlidePanningStateStopped,
    JPVerticalSlidePanningStateDown,
    JPVerticalSlidePanningStateUp
};

@interface JPVerticalSlideViewController ()
{
    
    JPVerticalSlidePanningState panningState;
    BOOL panStarted;
}

@property (strong, nonatomic) UIView *overlayView;

- (void) _addGestures;
- (void) _disableGestures;
- (void) _enableGestures;
- (void) _setup;

@end

@implementation JPVerticalSlideViewController

#pragma mark - Init -

+ (instancetype) verticalSlideMenuWithMainVC:(UIViewController *) mainViewController
                                    andTopVC:(UIViewController *) topViewController
                                 andBottomVC:(UIViewController *) bottomViewController{

    JPVerticalSlideViewController* verticalSlideVC  = [[JPVerticalSlideViewController alloc] init];
    
    if (verticalSlideVC) {
        
        verticalSlideVC.mainVC                          = mainViewController;
        verticalSlideVC.topVC                           = topViewController;
        verticalSlideVC.bottomVC                        = bottomViewController;
    }
    
    return verticalSlideVC;
}

#pragma mark - Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self _setup];
}

#pragma mark - Datasource -

- (CGFloat) topVCHeight
{
    return 400.0f;
}

- (CGFloat) bottomVCHeight
{
    return 400.0f;
}

- (CGFloat) panGestureWorkingAreaPercent
{
    return 100.0f;
}

#pragma mark - Private Methods -

- (void) _addGestures
{
    if (self.overlayView)
    {
        [self.overlayView removeFromSuperview];
    }
    else
    {
        self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    
    CGRect frame            = self.overlayView.frame;
    frame.size              = self.view.bounds.size;
    self.overlayView.frame  = frame;
    
    self.overlayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.overlayView];
    
    [self.overlayView addGestureRecognizer:self.tapGesture];
    [self.overlayView addGestureRecognizer:self.panGesture];
}

- (void) _disableGestures
{
    self.tapGesture.enabled = NO;
}

- (void) _enableGestures
{
    self.tapGesture.enabled = YES;
}

- (void) _setup
{
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handleTapGesture:)];
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(handlePanGesture:)];
    
    self.panGesture.delegate = self;
    
    self.tapGesture.cancelsTouchesInView = YES;
    
    [self.view addGestureRecognizer:self.panGesture];
    
    if (self.topVC) {
        
        CGRect currentTopFrame  = self.topVC.view.frame;
        currentTopFrame.origin  = CGPointMake(0.0f, -1 * self.topVC.view.frame.size.height);
        self.topVC.view.frame   = currentTopFrame;
        
        [self.view addSubview:self.topVC.view];
    }
    
    if (self.mainVC) {
        
        self.mainVC.view.frame   = self.view.frame;
        [self.view addSubview:self.mainVC.view];
    }
    
    if (self.bottomVC) {
        
        CGRect currentBottomFrame  = self.bottomVC.view.frame;
        currentBottomFrame.origin  = CGPointMake(0.0f, self.view.frame.size.height);
        self.bottomVC.view.frame   = currentBottomFrame;
        
        [self.view addSubview:self.bottomVC.view];
    }
}

#pragma mark - Gesture Recognizers -

- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    [self _closeSlide];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    
    static CGPoint panStartPosition = (CGPoint){0,0};
    
    if (self.topPanDisabled && self.bottomPanDisabled)
    {
        return;
    }
    
    UIView* panningView = gesture.view;
    
    if (self.slideState != JPVerticalSlideClosed)
    {
        panningView = panningView.superview;
    }
    
    CGPoint translation = [gesture translationInView:panningView];
    
    if ([gesture state] == UIGestureRecognizerStateBegan)
    {
        panStartPosition    = [gesture locationInView:panningView];
        panStarted          = YES;
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled)
    {
        if (_slideState != JPVerticalSlideClosed)
        {
            if (panningState == JPVerticalSlidePanningStateDown)
            {
                if (self.view.frame.size.height - (panningView.frame.origin.y + panningView.frame.size.height) < (2.0f * ([self bottomVCHeight] / 3.0f)))
                {
                    [self closeBottomVC];
                }
                else
                {
                    [self openBottomVC];
                }
            }
            else if (panningState == JPVerticalSlidePanningStateUp)
            {
                if (panningView.frame.origin.y < (2.0f * ([self topVCHeight] / 3.0f)))
                {
                    [self closeTopVC];
                }
                else
                {
                    [self openTopVC];
                }
            }
        }
        else
        {
            if (panningState == JPVerticalSlidePanningStateUp)
            {
                
                if (self.view.frame.size.height - (panningView.frame.origin.y + panningView.frame.size.height) < ([self bottomVCHeight] / 3.0f))
                {
                    [self closeBottomVC];
                }
                else
                {
                    [self openBottomVC];
                }
            }
            if (panningState == JPVerticalSlidePanningStateDown)
            {
                if (panningView.frame.origin.y < ([self topVCHeight] / 3.0f))
                {
                    [self closeTopVC];
                }
                else
                {
                    [self openTopVC];
                }
            }
        }
        
        panningState = JPVerticalSlidePanningStateStopped;
    }
    else
    {
        if (!CGPointEqualToPoint(panStartPosition, (CGPoint){0,0}))
        {
            CGFloat actualHeight = panningView.frame.size.height * ([self panGestureWorkingAreaPercent] / 100.0f);
            if (panStartPosition.y > actualHeight && panStartPosition.y < panningView.frame.size.height - actualHeight && self.slideState == JPVerticalSlideClosed)
            {
                return;
            }
        }
        
        //--- Calculate pan position
        if(panStarted)
        {
            panStarted = NO;
            
            if (panningView.frame.origin.y + translation.y < 0)
            {
                if (self.slideState == JPVerticalSlideClosed) {
                    
                    panningState    = JPVerticalSlidePanningStateUp;
                    
                }else{
                    
                    panningState    = JPVerticalSlidePanningStateDown;
                }
                
                if (self.slideState == JPVerticalSlideClosed)
                {
                    self.topVC.view.hidden      = YES;
                    self.bottomVC.view.hidden   = NO;
                }
            }
            else if(panningView.frame.origin.y + translation.y > 0)
            {
                if (self.slideState == JPVerticalSlideClosed) {
                    
                    panningState    = JPVerticalSlidePanningStateDown;
                    
                }else{
                    
                    panningState    = JPVerticalSlidePanningStateUp;
                }
                
                if (self.slideState == JPVerticalSlideClosed)
                {
                    self.topVC.view.hidden      = NO;
                    self.bottomVC.view.hidden   = YES;
                }
            }
        }
        //----
        
        //----
        if (panningState == JPVerticalSlidePanningStateUp && self.topPanDisabled)
        {
            panningState = JPVerticalSlidePanningStateStopped;
            return;
        }
        else if (panningState == JPVerticalSlidePanningStateDown && self.bottomPanDisabled)
        {
            panningState = JPVerticalSlidePanningStateStopped;
            return;
        }
        //----
        
        if (self.slideState == JPVerticalSlideTopOpened)
        {
            if ((panningView.frame.origin.y + translation.y) < [self topVCHeight] && (panningView.frame.origin.y + translation.y) >= 0)
            {
                [panningView setCenter:CGPointMake([panningView center].x, [panningView center].y + translation.y)];
            }
        }
        else if (self.slideState == JPVerticalSlideBottomOpened)
        {
            if (self.view.frame.size.height - (panningView.frame.origin.y + panningView.frame.size.height + translation.y) < [self bottomVCHeight] &&
                panningView.frame.origin.y <= 0)
            {
                [panningView setCenter:CGPointMake([panningView center].x, [panningView center].y + translation.y)];
            }
        }
        else if (self.slideState == JPVerticalSlideClosed)
        {
            if (panningState == JPVerticalSlidePanningStateDown && self.topVC)
            {
                if ((panningView.frame.origin.y + translation.y) < [self topVCHeight] && (panningView.frame.origin.y + translation.y) > 0)
                {
                    [panningView setCenter:CGPointMake([panningView center].x, [panningView center].y + translation.y)];
                }
            }
            else if (panningState == JPVerticalSlidePanningStateUp  && self.bottomVC)
            {
                if (self.view.frame.size.height - (panningView.frame.origin.y + panningView.frame.size.height + translation.y) <= [self bottomVCHeight])
                {
                    if (panningView.frame.origin.y + translation.y <= 0)
                    {
                        [panningView setCenter:CGPointMake([panningView center].x, [panningView center].y + translation.y)];
                    }
                }
            }
        }
    }
    
    [gesture setTranslation:CGPointZero inView:panningView];
}

#pragma mark - Public Actions -


- (void) openTopVC
{
    [self openTopVCAnimated:YES];
}

- (void) openTopVCAnimated:(BOOL)animated
{
    
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topVCWillOpen)])
        [self.slideVCDelegate topVCWillOpen];
    
    
    self.topVC.view.hidden      = NO;
    self.bottomVC.view.hidden   = YES;
    
    CGRect frame                = self.view.frame;
    frame.origin.y              = [self topVCHeight];
    
    [UIView animateWithDuration:(animated) ? kSlideOpenAnimationDuration : 0
                     animations:^{
                         self.view.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self _addGestures];
                         [self _enableGestures];
                         
                         self.slideState = JPVerticalSlideTopOpened;
                         
                         
                         if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topVCDidOpen)])
                             [self.slideVCDelegate topVCDidOpen];
                         
                     }];
}

- (void) openBottomVC
{
    [self openBottomVCAnimated:YES];
}

- (void) openBottomVCAnimated:(BOOL)animated{
    
    
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(bottomVCWillOpen)])
        [self.slideVCDelegate bottomVCWillOpen];
    
    
    self.topVC.view.hidden      = YES;
    self.bottomVC.view.hidden   = NO;
    
    CGRect frame                = self.view.frame;
    frame.origin.y              = -1 * [self bottomVCHeight];
    
    [UIView animateWithDuration:animated ? kSlideOpenAnimationDuration : 0
                     animations:^{
                         
                         self.view.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self _addGestures];
                         [self _enableGestures];
                         
                         self.slideState = JPVerticalSlideBottomOpened;
                         
                         
                         if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(bottomVCDidOpen)])
                             [self.slideVCDelegate bottomVCDidOpen];
                         
                     }];
}

- (void) closeTopVC
{
    [self closeTopVCAnimated:YES];
}

- (void) closeTopVCAnimated:(BOOL)animated
{
    
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topVCWillClose)])
        [self.slideVCDelegate topVCWillClose];
    
    
    CGRect frame    = self.view.frame;
    frame.origin.y  = 0;
    
    [UIView animateWithDuration:animated ? kSlideCloseAnimationDuration : 0
                     animations:^{
                         
                         self.view.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self.overlayView removeFromSuperview];
                         [self _disableGestures];
                         
                         self.slideState = JPVerticalSlideClosed;
                         
                         [self.view addGestureRecognizer:self.panGesture];
                         
                         
                         if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(topVCDidClose)])
                             [self.slideVCDelegate topVCDidClose];
                         
                     }];
}

- (void) closeBottomVC
{
    [self closeBottomVCAnimated:YES];
}

- (void) closeBottomVCAnimated:(BOOL)animated
{
    
    if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(bottomVCWillClose)])
        [self.slideVCDelegate bottomVCWillClose];
    
    
    CGRect frame    = self.view.frame;
    frame.origin.y  = 0;
    
    [UIView animateWithDuration:animated ? kSlideCloseAnimationDuration : 0
                     animations:^{
                         
                         self.view.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self.overlayView removeFromSuperview];
                         [self _disableGestures];
                         
                         self.slideState = JPVerticalSlideClosed;
                         
                         [self.view addGestureRecognizer:self.panGesture];
                         
                         
                         if (self.slideVCDelegate && [self.slideVCDelegate respondsToSelector:@selector(bottomVCDidClose)])
                             [self.slideVCDelegate bottomVCDidClose];
                         
                     }];
}

- (void) _closeSlide
{
    if (self.slideState == JPVerticalSlideBottomOpened)
    {
        [self closeBottomVC];
    }
    else if (self.slideState == JPVerticalSlideTopOpened)
    {
        [self closeTopVC];
    }
}

#pragma mark - UIGestureRecognizer Delegate Methods -

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    
    return fabs(translation.y) > fabs(translation.x);
}


@end