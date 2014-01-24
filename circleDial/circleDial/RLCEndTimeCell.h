//
//  RLCEndTimeCell.h
//  circleDial
//
//  Created by raymond chen on 2013-07-30.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWDatePicker.h"

@interface RLCEndTimeCell : UITableViewCell <MWPickerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *upArrowLabel;
@property (nonatomic, assign) BOOL editTimeOn;
@property (weak, nonatomic) IBOutlet UILabel *nightLabel;
@property (weak, nonatomic) IBOutlet MWDatePicker *flatDatePicker;
@end
