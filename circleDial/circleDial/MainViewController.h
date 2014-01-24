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


@interface MainViewController : UIViewController <RLCSliderMenuDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timerBtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomMenuView;
@property (weak, nonatomic) IBOutlet UIView *dragView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VDragViewSpacing;
@property (weak, nonatomic) IBOutlet UIView *setupTimerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VSetupTimerViewSpacing;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *HLeadingSpaceClipView;
@property (strong, nonatomic) IBOutlet UIView *clipView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VTopSpaceClipView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VBottomSpaceClipView;

@property (strong, nonatomic) IBOutlet UILabel *setTimerLabel;
@property (strong, nonatomic) IBOutlet testview *progressTimer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VBottomSpaceSetupTimerView;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *writtenTimerLabel;
@end
