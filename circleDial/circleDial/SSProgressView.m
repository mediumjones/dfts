//
//  SSProgressView.m
//  circleTest
//
//  Created by raymond chen on 2013-06-27.
//  Copyright (c) 2013 test. All rights reserved.
//

#import "SSProgressView.h"
#import <QuartzCore/QuartzCore.h>

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)
#define   RADIANS_TO_DEGREES(radian)   radian * 180 / M_PI

typedef enum ProgressViewState {
	PROGRESSVIEW_MAX,
	PROGRESSVIEW_MIN,
	PROGRESSVIEW_NORMAL,
}ProgressViewState;

@interface SSProgressView()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *remainderColor;
@property (nonatomic, assign) float secondsTotal;
@property (nonatomic, assign) float secondsRemaining;
@property (nonatomic, strong) NSTimer *sTimer;
@property (nonatomic, strong) NSTimer *pTimer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) ProgressViewState state;

@end

/**
 default 1.5 (90mins) hours - Max 3 hours (180mins)
 */


@implementation SSProgressView
@synthesize lineWidth = _lineWidth;
@synthesize remainderColor = _remainderColor;
@synthesize sTimer = _sTimer;
@synthesize path = _path;
@synthesize pTimer = _pTimer;
@synthesize pathLayer = _pathLayer;
@synthesize timerLabel = _timerLabel;
@synthesize writtenTimerLabel = _writtenTimerLabel;
@synthesize bPath = _bPath;
@synthesize angle = _angle;
@synthesize state = _state;

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self){
		_lineWidth = 3.0;
		_remainderColor = [UIColor greenColor];
		self.backgroundColor = [UIColor clearColor];
		//self.progress = 0.0f;
		_state = PROGRESSVIEW_NORMAL;
	}
	return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		_lineWidth = 2.0;
		
    }
    return self;
}

- (void)setUpTimerWithCountDownTimer:(int)minutes withTimerLabel:(UILabel*)timerLabel withWrittenTimerLabel:(UILabel*)writtenTimerLabel{
	
	self.progress = 0.0f;
	self.secondsTotal = 180.0f;
	self.secondsRemaining = 0.0f;
	self.sTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateProgressCircle) userInfo:nil repeats:YES];
	self.timerLabel = timerLabel;
	self.writtenTimerLabel = writtenTimerLabel;

}

- (void)setUpInProgressTimer{
	self.pTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(showProgress) userInfo:nil repeats:YES];
}

- (void)startTimer{
	[self.sTimer fire];
	[self setUpInProgressTimer];
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
	NSLog(@"height is %f width is %f", self.bounds.size.height, self.bounds.size.width);
	if (self.bounds.size.width > self.bounds.size.height){
		radius = self.bounds.size.height/2 * 0.9;
	}else{
		radius = self.bounds.size.width/2 * 0.9;
	}
    //draw background circle
    UIBezierPath *backCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
                                                              radius:radius - self.lineWidth / 2
                                                          startAngle:(CGFloat) 3 * M_PI/2 - M_PI/9
                                                            endAngle:(CGFloat) 3 * M_PI/2 + M_PI/9
                                                           clockwise:NO];
    [[UIColor blueColor] setStroke];
    backCircle.lineWidth = self.lineWidth;
    [backCircle fill];
    
//	if (!self.bPath){
//		self.bPath = backCircle;
//	}
//		
//    if (self.progress != 0) {
//        //draw progress circle
//        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
//                                                                      radius:radius - self.lineWidth / 2
//                                                                  startAngle:(CGFloat) 3 * M_PI/2 + M_PI/9
//                                                                    endAngle:(CGFloat) 3 * M_PI/2 + M_PI/9 + (self.progress * (2 * M_PI - 2 * M_PI/9))
//                                                                   clockwise:YES];
//        [self.remainderColor setStroke];
//        progressCircle.lineWidth = self.lineWidth;
//        [progressCircle stroke];
//		UIBezierPath *path = [UIBezierPath bezierPath];
//		[[UIColor whiteColor] setFill];
//		[path addArcWithCenter:[progressCircle currentPoint]
//						radius:16.0
//					startAngle:0.0
//					  endAngle:2.0 * M_PI
//					 clockwise:NO];
//		[path fill];
//    }else{
//		//draw progress circle
//        UIBezierPath *progressCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2)
//                                                                      radius:radius - self.lineWidth / 2
//                                                                  startAngle:(CGFloat) 3 * M_PI/2 + M_PI/9
//                                                                    endAngle: DEGREES_TO_RADIANS(self.angle)
//                                                                   clockwise:YES];
//        [self.remainderColor setStroke];
//        progressCircle.lineWidth = self.lineWidth;
//        [progressCircle stroke];
//		
//		UIBezierPath *path = [UIBezierPath bezierPath];
//		[[UIColor whiteColor] setFill];
//		[path addArcWithCenter:[progressCircle currentPoint]
//						radius:16.0
//					startAngle:0.0
//					  endAngle:2.0 * M_PI
//					 clockwise:NO];
//		[path fill];
//	}
}

- (void)updateProgressCircle{
//    //update progress value
//	float progressValue = self.progress;
//	
//	self.secondsRemaining= self.secondsRemaining + 3.0f;
//	if (self.secondsRemaining >= self.secondsTotal - 90.f){
//		[self.sTimer invalidate];
//	}
//	
//	progressValue = (self.secondsRemaining / self.secondsTotal);
//
//	self.progress = progressValue;
//	self.timerLabel.text = [self timeFormatted:self.secondsRemaining];
//	self.writtenTimerLabel.text = [self getWrittenTimeFromMinutes:self.secondsRemaining];
//	NSLog(@"current seconds is %f",self.secondsRemaining);
//
//    //redraw back & progress circles
//    [self setNeedsDisplay];
	
}

- (NSString *)timeFormatted:(int)currentMinutes
{
	
    int minutes = currentMinutes % 60;
    int hours = currentMinutes / 60;
	
	return (hours > 9) ?[NSString stringWithFormat:@"%02d:%02d",hours, minutes] : [NSString stringWithFormat:@"%01d:%02d",hours, minutes];
}

- (NSString *)getWrittenTimeFromMinutes:(int)currentMinutes
{
	
    int minutes = currentMinutes % 60;
    int hours = currentMinutes / 60;
	
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterSpellOutStyle];
	
	NSString *hoursString = [f stringFromNumber:[NSNumber numberWithInt:hours]];
	NSString *minsString = [f stringFromNumber:[NSNumber numberWithInt:minutes]];
	
	NSString *returnString;
	
	if (hours <= 1 && minutes <= 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minute",hoursString, minsString];
	}else if (hours <= 1 && minutes > 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minutes",hoursString, minsString];
	}else if (hours > 1 && minutes <= 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minute",hoursString, minsString];
	}else if (hours > 1 && minutes > 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minutes",hoursString, minsString];
	}

	return [[returnString stringByReplacingOccurrencesOfString:@"zero hour :" withString:@""] stringByReplacingOccurrencesOfString:@": zero minute" withString:@""];
}

- (BOOL)updateAngle:(CGFloat)angle isDirectionLeft:(BOOL)isLeft{
//
//	if(angle == 290){
//		if (self.state == PROGRESSVIEW_MAX){
//			return NO;
//		}
//		self.state = PROGRESSVIEW_MIN;
//	}else if (angle == 250){
//		if (self.state == PROGRESSVIEW_MIN){
//			return NO;
//		}
//		self.state = PROGRESSVIEW_MAX;
//	}else{
//		if (self.state == PROGRESSVIEW_MAX && !isLeft){
//			return NO;
//		}else if (self.state == PROGRESSVIEW_MIN && isLeft){
//			return NO;
//		}
//		self.state = PROGRESSVIEW_NORMAL;
//	}
//	
//	self.progress = 0;
//	CGFloat newProgress;
//	if (!(DEGREES_TO_RADIANS(angle) > 3 * M_PI/2 - M_PI/9 &&
//		  DEGREES_TO_RADIANS(angle) < 3 * M_PI/2 + M_PI/9)){
//		//NSLog(@"Angle is %f", angle);
//		self.angle = angle;
//		if (angle > 290 || angle <= 0){
//			NSLog(@"Within the weird space");
//			// Get the progress value per angle 70 degress for
//			float progressPerDegree = (M_PI/2 - M_PI/9) / (2 * M_PI - 2 * M_PI/9) / 70;
//			newProgress = abs(290-angle) * progressPerDegree;
//		}else{
//			newProgress = (DEGREES_TO_RADIANS(angle) + M_PI/2 - M_PI/9) / (2 * M_PI - 2 * M_PI/9);
//		}
//
//		//NSLog(@"new progress is %f", newProgress);
//		if (newProgress <= 1 && newProgress >= 0.005 ){
//			self.timerLabel.text = [self timeFormatted:newProgress * self.secondsTotal];
//			self.writtenTimerLabel.text = [self getWrittenTimeFromMinutes:newProgress * self.secondsTotal];
//			
//			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//			[defaults setInteger:newProgress * self.secondsTotal forKey:@"timerDuration"];
//			[defaults synchronize];
//			
//					}
//		[self setNeedsDisplay];
//	}
//	return YES;
}

@end
