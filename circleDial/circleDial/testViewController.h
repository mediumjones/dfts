//
//  testViewController.h
//  circleDial
//
//  Created by raymond chen on 2013-07-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SSProgressView.h"
#import "RLCSliderMenu.h"
#import "SSCountDownTimerView.h"
#import "secondsTickView.h"

@interface testViewController : UIViewController <RLCSliderMenuDelegate, SSCountDownTimerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *countDownTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuInnerView;
@property (weak, nonatomic) IBOutlet UIView *dialTimerViewer;
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UIView *clipView;
@property (weak, nonatomic) IBOutlet UILabel *downArrowIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *pullDownLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimerLabel;
@property (weak, nonatomic) IBOutlet SSCountDownTimerView *countDownTimer;
@property (weak, nonatomic) IBOutlet UIView *countDownView;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet secondsTickView *secondsTickView;
@property (weak, nonatomic) IBOutlet secondsTickView *secondsTickBackgroundView;

@end
