//
//  SSProgressView.h
//  circleTest
//
//  Created by raymond chen on 2013-06-27.
//  Copyright (c) 2013 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSProgressView : UIProgressView

@property (strong) UILabel *timerLabel;
@property (strong) UILabel *writtenTimerLabel;
@property (strong) UIBezierPath *bPath;

- (void)setUpTimerWithCountDownTimer:(int)minutes withTimerLabel:(UILabel*)timerLabel withWrittenTimerLabel:(UILabel*)writtenTimerLabel;
- (void)startTimer;
- (BOOL)updateAngle:(CGFloat)angle isDirectionLeft:(BOOL)isLeft;
@end
