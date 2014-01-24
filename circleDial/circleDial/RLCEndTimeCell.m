//
//  RLCEndTimeCell.m
//  circleDial
//
//  Created by raymond chen on 2013-07-30.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "RLCEndTimeCell.h"
#import "UIView+bounce.h"

@implementation RLCEndTimeCell

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
		// Initialization code
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateUI:)
													 name:@"settingStartTime"
												   object:nil];
	}
	return self;
}

- (void)updateUI:(NSNotification *)notification{
	if (self.editTimeOn){
		[self toggleDatePicker];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
	if (selected){
		[self toggleDatePicker];
	}
}

- (void)toggleDatePicker{
	// Configure the view for the selected state
	if (!self.editTimeOn){
		NSLog(@"Setting time on");
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.endTimeLabel.transform =
							 CGAffineTransformTranslate(self.endTimeLabel.transform, 0, -190);
							 self.flatDatePicker.transform =
							 CGAffineTransformTranslate(self.flatDatePicker.transform, 0, -255);
							 self.nightLabel.transform =
							 CGAffineTransformTranslate(self.nightLabel.transform, 0, 90);
							 self.upArrowLabel.transform = CGAffineTransformConcat(CGAffineTransformTranslate(self.upArrowLabel.transform, 38, 0), CGAffineTransformRotate(self.upArrowLabel.transform, M_PI_2));
						 } completion:^(BOOL finished) {
							 [self.flatDatePicker bounceYPosition:2 withDuration:0.1 withRepeatCount:2];
							 self.editTimeOn = YES;
						 }];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"settingEndTime" object:[NSNumber numberWithBool:YES]];
	}else{
		NSLog(@"Setting time off");
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.endTimeLabel.transform = CGAffineTransformIdentity;
							 self.flatDatePicker.transform = CGAffineTransformIdentity;
							 self.nightLabel.transform = CGAffineTransformIdentity;
							 self.upArrowLabel.transform = CGAffineTransformIdentity;
						 } completion:^(BOOL finished) {
							 self.editTimeOn = NO;
							 [[self.flatDatePicker.selector layer] removeAllAnimations];
						 }];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"settingEndTime" object:[NSNumber numberWithBool:NO]];
	}
}

#pragma mark - MWPickerDelegate

- (UIColor *) backgroundColorForDatePicker:(MWDatePicker *)picker
{
    return [UIColor clearColor];
}


- (UIColor *) datePicker:(MWDatePicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [UIColor clearColor];
        case 1:
            return [UIColor clearColor];
        case 2:
            return [UIColor blackColor];
        default:
            return 0; // never
    }
}


- (UIColor *) viewColorForDatePickerSelector:(MWDatePicker *)picker
{
    return [UIColor grayColor];
}

-(void)datePicker:(MWDatePicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@",[picker getDate]);
	
}

- (void)datePicker:(MWDatePicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component{
	
	self.nightLabel.text = [self.flatDatePicker getPeriodOfDay];
	self.endTimeLabel.text = [self.flatDatePicker getTimeFromDate];
	[UIView animateWithDuration:0.25 animations:^{
		self.flatDatePicker.selector.backgroundColor = [UIColor blackColor];
		self.flatDatePicker.selector.transform = CGAffineTransformMakeScale(20.0,1.0);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			self.flatDatePicker.selector.backgroundColor = [UIColor grayColor];
			self.flatDatePicker.selector.transform = CGAffineTransformIdentity;
			
			UITableView *tableView = (UITableView*)self.superview;
			[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
								   animated:YES
							 scrollPosition:0];
			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
		}];
		
	}];	
}

@end
