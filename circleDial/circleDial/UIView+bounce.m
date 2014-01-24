//
//  UIView+bounce.m
//  circleDial
//
//  Created by raymond chen on 2013-08-29.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "UIView+bounce.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (bounce)

- (void)bounceXPosition:(int)xOffSet withDuration:(float)durationTime withRepeatCount:(int)count
{
	 CGPoint origin = self.center;
	 CGPoint target = CGPointMake(self.center.x + xOffSet, self.center.y);
	 CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.x"];
	 bounce.duration = durationTime;
	 bounce.fromValue = [NSNumber numberWithInt:origin.x];
	 bounce.toValue = [NSNumber numberWithInt:target.x];
	 bounce.repeatCount = count;
	 bounce.autoreverses = YES;
	
	[self.layer addAnimation:bounce forKey:@"position"];
}

- (void)bounceYPosition:(int)yOffSet withDuration:(float)durationTime withRepeatCount:(int)count
{
	CGPoint origin = self.center;
	CGPoint target = CGPointMake(self.center.x, self.center.y + yOffSet);
	CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.y"];
	bounce.duration = durationTime;
	bounce.fromValue = [NSNumber numberWithInt:origin.y];
	bounce.toValue = [NSNumber numberWithInt:target.y];
	bounce.repeatCount = count;
	bounce.autoreverses = YES;
	
	[self.layer addAnimation:bounce forKey:@"position"];
}
@end
