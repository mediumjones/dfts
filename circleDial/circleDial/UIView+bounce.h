//
//  UIView+bounce.h
//  circleDial
//
//  Created by raymond chen on 2013-08-29.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (bounce)

- (void)bounceXPosition:(int)xOffSet
		   withDuration:(float)durationTime
		withRepeatCount:(int)count;

- (void)bounceYPosition:(int)yOffSet
		   withDuration:(float)durationTime
		withRepeatCount:(int)count;

@end
