//
//  SSCountDownTimerView.m
//  circleDial
//
//  Created by raymond chen on 2013-09-05.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "SSCountDownTimerView.h"
#import <QuartzCore/QuartzCore.h>

#define   DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@interface SSCountDownTimerView()

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *remainderColor;
@property (nonatomic, assign) int secondsTotal;
@property (nonatomic, assign) int secondsRemaining;
@property (nonatomic, strong) NSTimer *sTimer;
@property (nonatomic, strong) NSTimer *pTimer;
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CAShapeLayer *pathLayer;

@end

@implementation SSCountDownTimerView
@synthesize lineWidth = _lineWidth;
@synthesize remainderColor = _remainderColor;
@synthesize sTimer = _sTimer;
@synthesize path = _path;
@synthesize pTimer = _pTimer;
@synthesize pathLayer = _pathLayer;
@synthesize isCountDownRunning = _isCountDownRunning;

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
	//[self setUpInProgressTimer];
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
		radius = (self.bounds.size.height/2) * 0.95;
	}else{
		radius = (self.bounds.size.width/2) * 0.95;
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
		self.path.lineWidth = progressCircle.lineWidth * 2;
		
		CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
		CGContextMoveToPoint(context, progressCircle.currentPoint.x - 1.5, progressCircle.currentPoint.y - rect.size.height*0.1);
		CGContextAddLineToPoint(context, progressCircle.currentPoint.x - 1.5, progressCircle.currentPoint.y + rect.size.height*0.1);
		
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
	
    if (progressValue < 0)
    {
        NSLog(@"timer's up");
		[self.sTimer invalidate];
		[self.delegate updateOnTimerIsUp];
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


@end