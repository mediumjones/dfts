//
//  SSCountDownTimerView.h
//  circleDial
//
//  Created by raymond chen on 2013-09-05.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSCountDownTimerViewDelegate

- (void)updateTextLabelForCurrentTimer:(int)elapsedTime;
- (void)updateOnTimerIsUp;

@end

@interface SSCountDownTimerView : UIProgressView

@property (nonatomic, weak) id <SSCountDownTimerViewDelegate> delegate;
@property (nonatomic, assign) BOOL isCountDownRunning;

- (void)setUpTimerWithCountDownTimer:(int)minutes;
- (void)startTimer;

@end
