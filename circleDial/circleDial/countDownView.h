//
//  countDownView.h
//  circleDial
//
//  Created by raymond chen on 2013-10-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol countDownViewDelegate

- (void)updateTextLabelForCurrentTimer:(int)elapsedTime;
- (void)updateTextLabelForRemainingTimer:(int)remainingTime;
- (void)updateOnTimerIsUp;
- (void)updateOnBreakTime;

@end

@interface countDownView : UIView

@property (nonatomic, weak) id <countDownViewDelegate> delegate;
@property (nonatomic, assign) BOOL isCountDownRunning;
@property (nonatomic, assign) float progress;

- (void)setUpTimerWithCountDownTimer:(int)minutes;
- (void)startTimer;
- (void)stopTimer;
@end
