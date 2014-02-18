//
//  countDownView.m
//  circleDial
//
//  Created by raymond chen on 2013-10-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "countDownView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@interface countDownView()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *remainderColor;
@property (nonatomic, assign) int secondsTotal;
@property (nonatomic, assign) int secondsRemaining;
@property (nonatomic, strong) NSTimer *sTimer;
@property (nonatomic, strong) NSTimer *pTimer;
@property (nonatomic, strong) NSTimer *aTimer;
@property (nonatomic, strong) NSTimer *bTimer;
@property (nonatomic, assign) int breakSecondsRemaining;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) CMMotionActivityManager *motionActivitiyManager;
@property (nonatomic, strong) NSMutableArray *activities;
@end

@implementation countDownView
@synthesize lineWidth = _lineWidth;
@synthesize remainderColor = _remainderColor;
@synthesize sTimer = _sTimer;
@synthesize path = _path;
@synthesize pTimer = _pTimer;
@synthesize pathLayer = _pathLayer;
@synthesize isCountDownRunning = _isCountDownRunning;
@synthesize progress = _progress;
@synthesize motionActivitiyManager = _motionActivitiyManager;
@synthesize activities = _activities;
@synthesize aTimer = _aTimer;
@synthesize breakSecondsRemaining = _breakSecondsRemaining;

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self){
		_lineWidth = 30.0;
		_remainderColor = [UIColor grayColor];
		self.backgroundColor = [UIColor clearColor];
		_isCountDownRunning = NO;
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_lineWidth = 5.0;
		
    }
    return self;
}

- (CMMotionActivityManager *)motionActivitiyManager
{
    if (_motionActivitiyManager == nil) {
        _motionActivitiyManager = [[CMMotionActivityManager alloc] init];
    }
    return _motionActivitiyManager;
}

- (NSMutableArray*)activities{
	if (_activities == nil){
		_activities = [[NSMutableArray alloc]init];
	}
	return _activities;
}

- (void)setUpTimerWithCountDownTimer:(int)minutes{
	if (!self.isCountDownRunning){
		self.progress = 0.0f;
		self.sTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateProgressCircle) userInfo:nil repeats:YES];
		self.secondsTotal = minutes * 60;
		self.secondsRemaining = minutes * 60;
	}
}
- (void)setUpInProgressTimer{
	
	self.pTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showProgress) userInfo:nil repeats:YES];
	NSLog(@"current timer is %f", self.sTimer.timeInterval);
}

- (void)startTimer{
	if (!self.isCountDownRunning){
		[self.sTimer fire];
		self.isCountDownRunning = YES;
	}
	
	if ([CMMotionActivityManager isActivityAvailable]) {
        __weak typeof(self) weakSelf = self;
        [self.activities removeAllObjects];
        [self.motionActivitiyManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
                                                     withHandler:^(CMMotionActivity *activity) {
                                                        NSLog(@"%s %@", __PRETTY_FUNCTION__, activity);
                                                         [weakSelf.activities addObject:activity];
														 if (!activity.stationary){

															 self.aTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(updateOnBreakTime) userInfo:nil repeats:NO];
														 }else{
															 if (self.aTimer){
																 [self.aTimer invalidate];
																 self.aTimer = nil;
															 }
														 }
                                                     }];
	}
}

- (BOOL)isRestNeeded{
	int totalSeconds = 5;
	float totalActiveSeconds = 0;
	
	for (CMMotionActivity *currentActivity in [self.activities reverseObjectEnumerator])
	{
		if ([self.activities indexOfObject:currentActivity] > 1){
			// Get current activity time
			NSTimeInterval currentTime = [currentActivity.startDate timeIntervalSinceNow];
			
			// Get previous activity time
			CMMotionActivity *previousActivity = [self.activities objectAtIndex:[self.activities indexOfObject:currentActivity]-1];
			NSTimeInterval previousTime = [previousActivity.startDate timeIntervalSinceNow];
			
			// Get the difference between the two times
			NSTimeInterval timeDifference = currentTime - previousTime;
			//NSLog(@"time difference is %f", timeDifference);
			if ((totalSeconds = totalSeconds - timeDifference) > 0){
				if (!previousActivity.stationary && previousActivity.confidence > 0){
			//		NSLog(@"not stationary");
					totalActiveSeconds = totalActiveSeconds + timeDifference;
				}
			}else{
//				if (!previousActivity.stationary && previousActivity.confidence > 0){
//					totalActiveSeconds = totalSeconds;
//				}
			}
			
		}
	}
	
	//NSLog(@"total active lenght is %f", totalActiveSeconds);
	
	//NSLog(@"%f", totalActiveSeconds/5.f);
	
	return (totalActiveSeconds / 5.f > .48) ? YES: NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetShouldAntialias(context, true);
	CGContextSetAllowsAntialiasing(context, true);
	CGFloat radius;
	if (self.bounds.size.width > self.bounds.size.height){
		radius = (self.bounds.size.height/2);
	}else{
		radius = (self.bounds.size.width/2);
	}
	
    if (self.progress != 0) {
        //draw progress circle
        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
                                                                      radius:radius - self.lineWidth / 2
                                                                  startAngle:(CGFloat)(- M_PI_2 - self.progress * 2 * M_PI)
                                                                    endAngle:(CGFloat) - M_PI_2
                                                                   clockwise:YES];
		
		CGPathRef outerPath = CGPathCreateCopyByStrokingPath(progressCircle.CGPath, NULL, self.lineWidth, kCGLineCapButt, kCGLineJoinBevel, 0);
		
		[self DrawGradientToProgress:context withPath:outerPath];
		
		self.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
												   radius:radius
											   startAngle:(CGFloat)(- M_PI_2 - self.progress * 2 * M_PI)
												 endAngle:(CGFloat) - M_PI_2
												clockwise:YES];
		self.path.lineWidth = progressCircle.lineWidth * 4;
		
		CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
		CGContextMoveToPoint(context, progressCircle.currentPoint.x - 1.5, progressCircle.currentPoint.y - rect.size.height*0.05);
		CGContextAddLineToPoint(context, progressCircle.currentPoint.x - 1.5, progressCircle.currentPoint.y + rect.size.height*0.05);
		
		CGContextSetLineWidth(context, 3.0); // this is set from now on until you explicitly change it
		
		CGContextStrokePath(context);
    }
	
	
	CGContextSetAllowsAntialiasing(context, true);
	CGContextSetShouldAntialias(context, true);
	
}

- (void)updateProgressCircle{
    //update progress value
	float progressValue = self.progress;
	
	self.secondsRemaining--;
	
	progressValue = ((float)self.secondsRemaining / (float)self.secondsTotal);
	//NSLog(@"progress value is %f", ((float)self.secondsRemaining / (float)self.secondsTotal));
	float elapsedTime = self.secondsTotal - self.secondsRemaining;
	[self.delegate updateTextLabelForCurrentTimer:elapsedTime];
	
	NSLog(@"reset timer %hhd", [self isRestNeeded]);
	
    if (progressValue == 0)
    {
		NSLog(@"timer's up");
		[self.sTimer invalidate];
		[self.delegate updateOnTimerIsUp];
    }else if ([self isRestNeeded]){
		[self.sTimer invalidate];
		[self startBreakTimer];
	}
	
	self.progress = progressValue;
    if (self.progress < 0.40 && self.progress > 0.20){
		self.remainderColor = [UIColor brownColor];
	}else if(self.progress < 0.20){
		self.remainderColor = [UIColor redColor];
	}
	
    //redraw back & progress circles
    [self setNeedsDisplay];
	
}

- (void)layoutSubviews{
	[super layoutSubviews];
}

- (void)DrawGradientToProgress:(CGContextRef)context withPath:(CGPathRef)path{
	CGContextSaveGState(context);
	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	
	CGFloat comps[] = {1.0,1.0,0.0,1.0,0.0,1.0,1.0,1.0};
	CGFloat locs[] = {0,1};
	CGGradientRef g = CGGradientCreateWithColorComponents(space, comps, locs, 2);
	
	CGContextAddPath(context, path);
	CGContextClip(context);
	
	CGPoint myStartPoint, myEndPoint;
	myStartPoint.x = 0.0;
	myStartPoint.y = self.frame.size.height;
	myEndPoint.x = self.frame.size.width;
	myEndPoint.y = 0.0;
	CGContextDrawLinearGradient (context, g, myStartPoint, myEndPoint, 0);
	CGContextRestoreGState(context);
}

- (void)updateOnBreakTime{
	[self startBreakTimer];
}

- (void)startBreakTimer{
	[self.delegate updateOnBreakTime];
	if (self.bTimer){
		[self.bTimer invalidate];
		self.bTimer = nil;
	}
	self.breakSecondsRemaining = 300;
	self.bTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(checkBreakTimer) userInfo:nil repeats:YES];
}

- (void)checkBreakTimer{
	self.breakSecondsRemaining--;
	NSLog(@"Current interval %d", self.breakSecondsRemaining);
}

@end
