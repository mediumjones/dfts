//
//  setTimerCell.h
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWDatePicker.h"

@interface setTimerCell : UITableViewCell <MWPickerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeOfDayLabel;
@property (strong, nonatomic) IBOutlet UILabel *arrowLabel;
@property (strong, nonatomic) IBOutlet MWDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VTopSpaceDatePicker;

- (void)setupTimer;
@end
