//
//  testview.h
//  circleDial
//
//  Created by raymond chen on 2013-10-08.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface testview : UIView

@property (strong) UILabel *timerLabel;
@property (strong) UILabel *writtenTimerLabel;

- (void)setUpTimerWithCountDownTimer:(int)minutes withTimerLabel:(UILabel*)timerLabel withWrittenTimerLabel:(UILabel*)writtenTimerLabel;
- (BOOL)updateAngle:(CGFloat)angle isDirectionLeft:(BOOL)isLeft;
- (NSString*)returnWrittenTime;
@end
