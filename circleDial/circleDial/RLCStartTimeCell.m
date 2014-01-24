//
//  RLCTimeCell.m
//  circleDial
//
//  Created by raymond chen on 2013-07-29.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "RLCStartTimeCell.h"
#import "UIView+bounce.h"

@implementation RLCStartTimeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
           }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if (self){


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
													 name:@"settingEndTime"
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
		self.morningLabel.transform = CGAffineTransformIdentity;
		NSLog(@"Setting time on");
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.startTimeLabel.transform =
							 CGAffineTransformTranslate(self.startTimeLabel.transform, 0, -190);
							 self.flatDatePicker.transform =
							 CGAffineTransformTranslate(self.flatDatePicker.transform, 0, -250);
							 self.morningLabel.transform =
							 CGAffineTransformTranslate(self.morningLabel.transform, 0, -190);
							self.startTimeSubLabel.transform = CGAffineTransformIdentity;
							 self.downArrowLabel.transform = CGAffineTransformConcat(CGAffineTransformTranslate(self.downArrowLabel.transform, 18, 0), CGAffineTransformRotate(self.downArrowLabel.transform, -M_PI_2));
						 } completion:^(BOOL finished) {
							 [self.flatDatePicker bounceYPosition:2 withDuration:0.1 withRepeatCount:2];
							 self.editTimeOn = YES;
						 }];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"settingStartTime" object:[NSNumber numberWithBool:YES]];
	}else{
		NSLog(@"Setting time off");
		[UIView animateWithDuration:0.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 self.startTimeLabel.transform = CGAffineTransformIdentity;
		
							 self.flatDatePicker.transform = CGAffineTransformIdentity;
	
							 self.morningLabel.transform = CGAffineTransformIdentity;

							 self.downArrowLabel.transform = CGAffineTransformIdentity;
						 } completion:^(BOOL finished) {
							 self.editTimeOn = NO;
							 [[self.flatDatePicker.selector layer] removeAllAnimations];
						 }];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"settingStartTime" object:[NSNumber numberWithBool:NO]];
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
	self.morningLabel.text = [self.flatDatePicker getPeriodOfDay];
	self.startTimeLabel.text = [self.flatDatePicker getTimeFromDate];
	[UIView animateWithDuration:0.25 animations:^{
		self.flatDatePicker.selector.backgroundColor = [UIColor blackColor];
		self.flatDatePicker.selector.transform = CGAffineTransformMakeScale(15.0,1.0);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			self.flatDatePicker.selector.backgroundColor = [UIColor grayColor];
			self.flatDatePicker.selector.transform = CGAffineTransformIdentity;
			
			UITableView *tableView = (UITableView*)self.superview;
			[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]
								   animated:YES
							 scrollPosition:0];
			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		}];

	}];
}

@end
