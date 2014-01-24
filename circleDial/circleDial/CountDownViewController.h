//
//  CountDownViewController.h
//  circleDial
//
//  Created by raymond chen on 2013-09-12.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "countDownView.h"
#import "secondsTickView.h"

@interface CountDownViewController : UIViewController <countDownViewDelegate>

@property (strong, nonatomic) IBOutlet countDownView *countDownTimer;
@property (strong, nonatomic) IBOutlet secondsTickView *secondsTickBackgroundView;
@property (strong, nonatomic) IBOutlet secondsTickView *secondsTickView;
@property (strong, nonatomic) IBOutlet UILabel *countDownTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *countDownText;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VBottomSpaceCountDownView;
@end
