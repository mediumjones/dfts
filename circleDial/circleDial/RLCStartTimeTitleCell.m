//
//  RLCStartTimeTitleCell.m
//  circleDial
//
//  Created by raymond chen on 2013-08-22.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "RLCStartTimeTitleCell.h"
#import "NSString+SSGizmo.h"

@implementation RLCStartTimeTitleCell
- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self){
		NSLog(@"Hello init");
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self){

	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
