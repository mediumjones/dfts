//
//  CountDownViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-09-12.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "CountDownViewController.h"
#import "MPFlipTransition.h"

@interface CountDownViewController ()

@end

@implementation CountDownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.countDownTimer setProgress:1.0];
	self.countDownTimer.delegate = self;
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:50];
	self.countDownText.font = textFont;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startTimer)
												 name:@"startTimer"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimer:)
												 name:@"DragViewPanned"
											   object:nil];

}

- (void)updateTimer:(NSNotification*)notification{
	NSDictionary *dict = [notification userInfo];
	CGFloat setupViewSpace = [[dict objectForKey:@"DragViewSpace"] floatValue];
	NSLog(@"space is %f", setupViewSpace);
	if (!self.countDownTimer.isCountDownRunning){
		CGFloat newBottom = 300 - (150.f / 452.f) * (setupViewSpace - 54.f);
		self.VBottomSpaceCountDownView.constant = newBottom;
		
		// Calculating new progress for progress view
		CGFloat newProgress = 0 + ((1.0f / 452.0f) * (setupViewSpace - 54.f));
		NSLog(@"progress is %f",newProgress);
		if (newProgress > 0){
			self.countDownTimer.progress = newProgress;
			[self.countDownTimer setNeedsDisplay];
		}

		// Animate the headerView and slidingHeaderView frame
		if (setupViewSpace >= 490){
			if ([self.countDownText.text isEqualToString:@"READY"]){
				[UIView animateWithDuration:1.0 animations:^{
					self.countDownText.alpha = 0.0;
				} completion:^(BOOL finished) {
					if (finished){
						[UIView animateWithDuration:0.2 animations:^{
							self.countDownText.text = @"START";
							self.countDownText.textColor = [UIColor greenColor];
							self.countDownText.alpha = 1.0;
						}];
					}
				}];
			}
		}else{
			self.countDownText.text = @"READY";
			self.countDownText.textColor = [UIColor orangeColor];
		}
	}
}

- (void)startTimer{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int countDownDuration = [defaults integerForKey:@"timerDuration"];
	NSLog(@"Setting duration for %d", countDownDuration);
	
	[self.countDownTimer setUpTimerWithCountDownTimer:countDownDuration];
	[self.countDownTimer startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)updateTextLabelForCurrentTimer:(int)elapsedTime{
	NSUInteger h = elapsedTime / 3600;
	NSUInteger m = (elapsedTime / 60) % 60;
	NSUInteger s = elapsedTime % 60;
	
	[MPFlipTransition transitionFromView:[self.secondsTickBackgroundView updateCurrentSeconds:s-1]
								  toView:[self.secondsTickView updateCurrentSeconds:s]
								duration:[MPTransition defaultDuration]
								   style:MPFlipStyleFlipDirectionBit(6)
						transitionAction:MPTransitionActionNone
							  completion:^(BOOL finished) {
							  }
	 ];
	
	NSString *formattedTime;
	
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:75];
	self.countDownText.font = textFont;
	formattedTime = [NSString stringWithFormat:@"%01u:%02u", h, m];
	
	
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterSpellOutStyle];
	
	NSString *hoursString = [f stringFromNumber:[NSNumber numberWithInt:h]];
	NSString *minsString = [f stringFromNumber:[NSNumber numberWithInt:m]];
	NSString *secondsString = [f stringFromNumber:[NSNumber numberWithInt:s]];
	NSString *returnString;
	
	if (h <= 1 && m <= 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minute",hoursString, minsString];
	}else if (h <= 1 && m > 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minutes",hoursString, minsString];
	}else if (h > 1 && m <= 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minute",hoursString, minsString];
	}else if (h > 1 && m > 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minutes",hoursString, minsString];
	}
	
	if (s > 1 && m == 0 && h == 0){
		returnString = [NSString stringWithFormat:@"%@ seconds", secondsString];
	}else if (s == 1 && m == 0 && h ==0){
		returnString = [NSString stringWithFormat:@"%@ second", secondsString];
	}
	
	self.countDownText.text = formattedTime;
	UIFont* timerTextFont = [UIFont fontWithName:@"KS-Normal" size:16];
	self.countDownTextLabel.font = timerTextFont;
	self.countDownTextLabel.text = [[returnString stringByReplacingOccurrencesOfString:@"zero hour :" withString:@""] stringByReplacingOccurrencesOfString:@"zero minute :" withString:@""];;
	self.countDownTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.countDownTextLabel.numberOfLines = 1;

}

- (void)updateOnTimerIsUp{
	self.countDownText.text = @"0:00";
	self.countDownText.textColor = [UIColor redColor];
}

- (void)updateOnBreakTime{
	self.countDownText.text = @"BREAK";
	self.countDownText.textColor = [UIColor greenColor];
}
@end
