//
//  DialTimerViewController.h
//  circleDial
//
//  Created by raymond chen on 2013-09-01.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSProgressView.h"

@interface DialTimerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *writtenTimerLabel;
@property (weak, nonatomic) IBOutlet SSProgressView *progressTimer;
@property (weak, nonatomic) IBOutlet UILabel *setTimerLabel;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *timerPanRecognizer;

- (void)disableGesture;
- (void)enableGesture;

@end
