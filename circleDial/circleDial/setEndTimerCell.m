//
//  setEndTimerCell.m
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "setEndTimerCell.h"
#import "NSString+SSGizmo.h"

@interface setEndTimerCell()

@property (nonatomic, assign) BOOL isDatePickerShown;

@end

@implementation setEndTimerCell

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
	
   	if (selected){
		[UIView animateWithDuration:0.5 animations:^{
			self.arrowLabel.transform = (self.isDatePickerShown) ?
			CGAffineTransformIdentity :
			CGAffineTransformConcat(CGAffineTransformTranslate(self.arrowLabel.transform, 25, 0),					CGAffineTransformRotate(self.arrowLabel.transform, M_PI_2));
			
			self.VTopSpaceDatePicker.constant = (self.isDatePickerShown) ? -140 : 0;
			[self layoutIfNeeded];
			self.isDatePickerShown = !self.isDatePickerShown;
		}];
	}
}


- (void)setupTimer{
	// Configure the view for the selected state
	UIFont *iconfont = [UIFont fontWithName:@"SS Gizmo" size:20];
	UIFont *textfont = [UIFont systemFontOfSize:56];
	
	self.arrowLabel.font = iconfont;
	self.arrowLabel.textAlignment = NSTextAlignmentCenter;
	self.arrowLabel.text = [NSString convertUnicode:@"0xF500"];
	
	self.timeLabel.font = textfont;
	self.timeLabel.text = @"9:00";
	self.timeOfDayLabel.text = @"At night";
	
	[self.datePicker setDelegate:self];
	[self.datePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
	[self.datePicker setFontColor:[UIColor whiteColor]];
	//[self.datePicker setTintColor:[UIColor clearColor]];
	[self.datePicker update];
	
	NSCalendar *cal = [NSCalendar currentCalendar];
	[cal setTimeZone:[NSTimeZone localTimeZone]];
	[cal setLocale:[NSLocale currentLocale]];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setMinute:0];
	[comps setHour:21];
	
	[self.datePicker setDate:[cal dateFromComponents:comps] animated:YES];
	
}

-(void)datePicker:(MWDatePicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%@",[picker getDate]);
	
}

- (void)datePicker:(MWDatePicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component{
	self.timeOfDayLabel.text = [self.datePicker getPeriodOfDay];
	self.timeLabel.text = [self.datePicker getTimeFromDate];
	[UIView animateWithDuration:0.30 animations:^{
		self.datePicker.selector.backgroundColor = [UIColor blackColor];
		self.datePicker.selector.transform = CGAffineTransformMakeScale(15.0,1.0);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.5 animations:^{
			self.datePicker.selector.backgroundColor = [UIColor grayColor];
			self.datePicker.selector.transform = CGAffineTransformIdentity;
			UITableView *tableView = (UITableView*)self.superview.superview;
			[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
								   animated:YES
							 scrollPosition:0];
			[tableView.delegate tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		}];
	}];
}

@end
