//
//  RLCTimeCell.h
//  circleDial
//
//  Created by raymond chen on 2013-07-29.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWDatePicker.h"

@interface RLCStartTimeCell : UITableViewCell <MWPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downArrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *morningLabel;
@property (nonatomic, assign) BOOL editTimeOn;
@property (weak, nonatomic) IBOutlet MWDatePicker *flatDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *startTimeSubLabel;
@end
