//
//  startTimerTitleCell.m
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "startTimerTitleCell.h"
#import "NSString+SSGizmo.h"

@implementation startTimerTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	UIFont *iconfont = [UIFont fontWithName:@"SS Gizmo" size:32];
	UIFont *textfont = [UIFont systemFontOfSize:15];
	
	self.alarmIcon.font = iconfont;
	self.alarmIcon.text = [NSString convertUnicode:@"0x1F514"];
	self.alarmIcon.textAlignment = NSTextAlignmentCenter;
	
	self.alarmMsg.font = textfont;
	self.alarmMsg.text = @"Please remind me from";
	self.alarmMsg.textAlignment = NSTextAlignmentCenter;
}

@end
