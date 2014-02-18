//
//  RJ_NotificationView.m
//  ReconJet
//
//  Created by Raymond Chen on 2/6/2014.
//  Copyright (c) 2014 Recon Instruments. All rights reserved.
//

#import "RJ_NotificationView.h"
#import "UIImage+ImageEffects.h"

@interface RJ_NotificationView()

@property (nonatomic, strong) UIView *notificationView;
@property (nonatomic, strong) UIImageView *blurredBackgroundView;
@property (nonatomic, strong) UIImageView *notificationIconView;
@property (nonatomic, strong) UITextView *notificationTextView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) NSTimer *dismissTimer;

@end

@implementation RJ_NotificationView
@synthesize blurredBackgroundView = _blurredBackgroundView;
@synthesize notificationView = _notificationView;
@synthesize notificationIconView = _notificationIconView;
@synthesize notificationTextView = _notificationTextView;
@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize dismissTimer = _dismissTimer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpViews];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.tapGestureRecognizer.delegate = self;
    
    
    self.blurredBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.notificationView = [[UIView alloc]initWithFrame:CGRectMake(0, -140, 320, 140)];
    self.notificationView.backgroundColor = [UIColor colorWithRed:0.780 green:0.797 blue:0.803 alpha:1.000];
    
    self.notificationIconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 25, 100, 100)];
    self.notificationIconView.image = [UIImage imageNamed:@"timerIcon"];
    self.notificationIconView.contentMode = UIViewContentModeScaleAspectFill;
    self.notificationIconView.clipsToBounds = YES;
    
    self.notificationTextView = [[UITextView alloc]initWithFrame:CGRectMake(115, 25, 200, 100)];
    self.notificationTextView.font = [UIFont fontWithName:@"SourceSansPro-Light" size:20];
    self.notificationTextView.textColor = [UIColor blackColor];
    self.notificationTextView.text = @"You have 90mins until your next break";
    self.notificationTextView.backgroundColor = [UIColor clearColor];
    self.notificationTextView.textAlignment = NSTextAlignmentLeft;
    
    
    [self.notificationView addSubview:self.notificationIconView];
    [self.notificationView addSubview:self.notificationTextView];
    [self.blurredBackgroundView addSubview:self.notificationView];
    [self.notificationTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
    [self addSubview:self.blurredBackgroundView];
	
    [self.superview sendSubviewToBack:self];
}


- (void)showNotificationWithAutoDismiss:(void (^)(BOOL finished))completionCallback{
    [self.superview bringSubviewToFront:self];
    
    self.blurredBackgroundView.image = [self TakeBlurScreenshot];
    self.notificationIconView.transform = CGAffineTransformScale(self.notificationIconView.transform, 0.1, 0.1);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.notificationView.transform = CGAffineTransformTranslate(self.notificationView.transform, 0, 140);
        self.blurredBackgroundView.alpha = 1.0;
        self.notificationIconView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished){
            [UIView animateWithDuration:0.3 animations:^{
                self.notificationIconView.transform = CGAffineTransformIdentity;
                self.notificationIconView.alpha = 1.0;
            } completion:^(BOOL finished) {
                completionCallback(YES);
            }];
        }
    }];
    
    if (self.dismissTimer){
        [self.dismissTimer invalidate];
        self.dismissTimer = nil;
    }
    self.dismissTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(dismissView) userInfo:nil repeats:NO];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dismissNotificationAfterDelay:(float)afterDelay{
    [UIView animateWithDuration:0.5 delay:afterDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.notificationView.transform = CGAffineTransformIdentity;
        self.blurredBackgroundView.alpha = 0.0;
        self.notificationView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.notificationView.alpha = 1.0;
        [self.superview sendSubviewToBack:self];
    }];
}

-(UIImage*)TakeBlurScreenshot{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [image applyBlurWithRadius:10 tintColor:[UIColor colorWithWhite:1.0 alpha:0.2] saturationDeltaFactor:1.8 maskImage:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *tv = object;
    CGFloat topCorrect = ([tv bounds].size.height - [tv contentSize].height * [tv zoomScale])/2.0;
    topCorrect = ( topCorrect < 0.0 ? 0.0 : topCorrect );
    tv.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};
}

- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if (CGRectContainsPoint(self.frame, [recognizer locationInView:self])){
        if (self.notificationView.frame.origin.y >= 0){
            [self dismissNotificationAfterDelay:0];
        }
    }
}

- (void)dismissView{
    if (self.notificationView.frame.origin.y >= 0){
        [self dismissNotificationAfterDelay:0];
    }
}

@end