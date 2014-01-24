//
//  RLCEndTimeTitleCell.m
//  circleDial
//
//  Created by raymond chen on 2013-08-22.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "RLCEndTimeTitleCell.h"

@implementation RLCEndTimeTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self){
		// Initialization code
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateUI:)
													 name:@"settingStartTime"
												   object:nil];
	}
	return self;
}



- (void)updateUI:(NSNotification *)notification{
	BOOL isStartTimeEditOn = [[notification object]boolValue];

//	[UIView animateWithDuration:0.5 animations:^{
//		self.toLabel.transform = isStartTimeEditOn? CGAffineTransformMakeTranslation(-50, 0):CGAffineTransformIdentity;
//		self.endTimeLabel.transform = isStartTimeEditOn?
//			CGAffineTransformMakeTranslation(0, -60):
//			CGAffineTransformIdentity;
//	}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
