//
//  MainViewController.h
//  circleDial
//
//  Created by raymond chen on 2013-09-12.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLCSliderMenu.h"
#import "testview.h"
#import "breakSuggestionController.h"


@interface MainViewController : UIViewController <RLCSliderMenuDelegate, breakSuggestionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timerBtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet UIView *setupTimerView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIView *clipView;


@property (strong, nonatomic) IBOutlet UILabel *setTimerLabel;
@property (strong, nonatomic) IBOutlet testview *progressTimer;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *writtenTimerLabel;

@property (weak, nonatomic) IBOutlet UILabel *downArrowIconLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomLine;
@property (strong, nonatomic) IBOutlet UILabel *remindMeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIView *breakNotificationView;
@property (strong, nonatomic) IBOutlet UIView *topDivider;
@property (strong, nonatomic) IBOutlet UILabel *suggestionLabel;
@property (strong, nonatomic) IBOutlet UILabel *suggestionLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *arrowLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
