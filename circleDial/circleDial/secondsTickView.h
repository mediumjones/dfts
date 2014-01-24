//
//  secondsTickView.h
//  circleDial
//
//  Created by raymond chen on 2013-09-08.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@interface secondsTickView : UIView

@property (nonatomic, assign) int currentSeconds;
@property (nonatomic, strong) TTTAttributedLabel *secondsLabel;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) UIColor *textColor;

- (id)updateCurrentSeconds:(int)seconds;
- (void)shouldDisplaySeconds;

@end
