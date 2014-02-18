//
//  CountDownViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-09-12.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "CountDownViewController.h"
#import "MPFlipTransition.h"
#import "motionDataController.h"
#import "RJ_NotificationView.h"
#import <Parse/Parse.h>
#import "testAppDelegate.h"

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define kTopMarginDragView (IS_IPHONE_5  ? 258 : 0)
#define kBottomMarginDragView (IS_IPHONE_5  ? 730 : 430)
@interface CountDownViewController ()

@property (nonatomic, assign) BOOL timerInProgress;
@property (nonatomic, weak) motionDataController *motionDC;

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
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:60];
	self.countDownText.font = textFont;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startTimer)
												 name:@"startTimer"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateTimer:)
												 name:@"DragViewPanned"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(startBreak:)
												 name:@"userMoved"
											   object:nil];

	[self.secondsTickBackgroundView shouldDisplaySeconds];
	[self.secondsTickView shouldDisplaySeconds];
	
	//	setup motion manager
	self.motionDC = [motionDataController sharedInstance];
	self.timerInProgress = NO;
}

- (void)updateTimer:(NSNotification*)notification{
	NSDictionary *dict = [notification userInfo];
	CGFloat timerViewCenterY = [[dict objectForKey:@"center"] floatValue];
	NSLog(@"space is %f", timerViewCenterY);
	if (!self.countDownTimer.isCountDownRunning){
		CGFloat newBottom = (self.view.frame.size.height/2.f) / (730.f - 258.f) * (timerViewCenterY - 258);
		NSLog(@"new bottom is %f", newBottom);
		self.countDownTimer.center = CGPointMake(self.countDownTimer.center.x, newBottom);
		
//		// Calculating new progress for progress view
//		CGFloat newProgress = 0 + ((1.0f / 452.0f) * (timerViewCenterY - 54.f));
//		NSLog(@"progress is %f",newProgress);
//		if (newProgress > 0){
//			self.countDownTimer.progress = newProgress;
//			[self.countDownTimer setNeedsDisplay];
//		}
		
		// Animate the headerView and slidingHeaderView frame
		if (timerViewCenterY >= 490){
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
	int countDownDuration = (int)[defaults integerForKey:@"timerDuration"];
	NSLog(@"Setting duration for %d", countDownDuration);
	
	[self.countDownTimer setUpTimerWithCountDownTimer:countDownDuration];
	[self.countDownTimer startTimer];
	[self.countDownText.textColor = [UIColor blackColor]CGColor];
	
	[self.motionDC startMotionSensing];
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
	
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:80];
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

- (void)startBreak:(NSNotification*)notification{
	self.countDownText.text = @"BREAK";
	self.countDownText.textColor = [UIColor greenColor];
}
@end
