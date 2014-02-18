//
//  testViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-07-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "testViewController.h"
#import "RLCSliderMenu.h"
#import "UIDevice+deviceInfo.h"
#import "NSString+SSGizmo.h"
#import <QuartzCore/QuartzCore.h>
#import "DialTimerViewController.h"
#import "UIView+bounce.h"
#import <CoreMotion/CoreMotion.h>
#import "MPFoldTransition.h"
#import "MPFlipTransition.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface testViewController ()

@property (nonatomic, strong) RLCSliderMenu *sliderMenu;
@property (nonatomic, strong) DialTimerViewController *dialTimerVC;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation testViewController
@synthesize sliderMenu = _sliderMenu;
@synthesize dialTimerVC = _dialTimerVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// Setup the text labels
	[self setupTextLabels];
	
	// Add the dail timer view controller
	self.dialTimerVC = [[DialTimerViewController alloc]init];
	
	// Alert the view controller
	[self addChildViewController:self.dialTimerVC];
	[self.dialTimerVC didMoveToParentViewController:self];
	
	// Add view controller and observer its center property
	[self.dialTimerViewer addSubview:self.dialTimerVC.view];
	
	[self.dialTimerViewer addObserver:self
							   forKeyPath:@"center"
								  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
								  context:NULL];
	
	// Setup the countdown timer
	[self.countDownTimer setProgress:1.0];
	self.countDownTimer.delegate = self;
	
	// bring the drag view to the front
	[self.dialTimerViewer bringSubviewToFront:self.dragView];
	
	// Updating the layer properties
	self.dragView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.dragView.layer.borderWidth = 1.f;
	self.dragView.layer.masksToBounds = YES;
	self.clipView.layer.masksToBounds = YES;
	self.dialTimerViewer.layer.masksToBounds = YES;
	
	[self.secondsTickBackgroundView shouldDisplaySeconds];
	[self.secondsTickView shouldDisplaySeconds];
	
	self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
	
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
											 withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
												 [self outputAccelertionData:accelerometerData.acceleration];
												 if(error){
													 
													 NSLog(@"%@", error);
												 }
											 }];

	
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
	NSLog(@"Getting acceleration data");
	NSLog(@"x %f", acceleration.x);
	NSLog(@"y %f", acceleration.y);
	NSLog(@"z %f", acceleration.z);
}

- (void)setupTextLabels{
	// Setup the count down timer label
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:60];
	self.countDownLabel.font = textFont;
	self.countDownLabel.textAlignment = NSTextAlignmentCenter;
	[self.countDownLabel bounceYPosition:5 withDuration:0.5 withRepeatCount:50];
	
	// Setup menu button
	UIFont* font = [UIFont fontWithName:@"SS Gizmo" size:30];
	self.menuButton.titleLabel.font = font;
	self.menuButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.menuButton setTitle:[NSString convertUnicode:@"0x1F514"]
					 forState:UIControlStateNormal];
	[self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// Setup setting button
	self.settingButton.titleLabel.font = font;
	self.settingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.settingButton setTitle:[NSString convertUnicode:@"0x1F501"]
						forState:UIControlStateNormal];
	
	[self.settingButton setTitleColor:[UIColor whiteColor]
							 forState:UIControlStateNormal];
	
	// Setup fonts for pull down and start timer text
	UIFont* timerTextFont =
	[UIFont fontWithName:@"KS-Normal"
					size:16];
	
	self.pullDownLabel.font = timerTextFont;
	self.startTimerLabel.font = timerTextFont;
	
	// Setup icon for dropdown label
	UIFont* downfont =
	[UIFont fontWithName:@"SS Gizmo"
					size:20];
	
	self.downArrowIconLabel.font = downfont;
	self.downArrowIconLabel.text = [NSString convertUnicode:@"0x23EA"];
	self.downArrowIconLabel.transform =
	CGAffineTransformMakeRotation(degreesToRadians(-90));
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	// Generate the slider menu for this view controller
	if (!self.sliderMenu){
		self.sliderMenu = [RLCSliderMenu sharedSliderMenu];
		self.sliderMenu.delegate = self;
		[self.sliderMenu addMenuViewToMainView:self.view
							   withSlidingView:self.baseView];
		
		[self.sliderMenu setUpPanGestureForViews:
							[NSArray arrayWithObjects:self.menuButton,
													  self.settingButton,
													  nil]];
		if ([UIDevice isDeviceAniPhone5]){
			self.view.backgroundColor =
				[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-568h"]];
		}else{
			self.view.backgroundColor =
				[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
		}

		self.sliderMenu.exclusiveTouch = YES;
		self.sliderMenu.menuState = SLIDERMENUSTATE_OFF;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onButtonClicked:(id)sender {
	[self slideMenu];
}
- (IBAction)onRepeatButtonClicked:(id)sender {
	[self slideRepeatMenu];
}

- (void)slideMenu
{
	// Check on current menu state and call the corresponding action for sliding in/out
	if (self.sliderMenu.menuState != SLIDERMENUSTATE_TIMERMENUON){
		[self.sliderMenu slideOutTimerMenu];
		[self.dialTimerVC disableGesture];
	}else
	{
		[self.sliderMenu slideIn];
		[self.dialTimerVC enableGesture];
	}
}

- (void)slideRepeatMenu
{
	// Check on current menu state and call the corresponding action for sliding in/out
	if (self.sliderMenu.menuState != SLIDERMENUSTATE_REPEATMENUON){
		[self.sliderMenu slideOutRepeatMenu];
		[self.dialTimerVC disableGesture];
	}else
	{
		[self.sliderMenu slideIn];
		[self.dialTimerVC enableGesture];
	}
}

- (IBAction)onDialTimerPanned:(UIPanGestureRecognizer *)recognizer{
	// Get the translation in the view
	CGPoint t = [recognizer translationInView:recognizer.view];

	[recognizer setTranslation:CGPointZero inView:recognizer.view];

	if (t.y + self.dialTimerViewer.center.y > 215){
		self.dialTimerViewer.center =
			CGPointMake(self.dialTimerViewer.center.x,
						self.dialTimerViewer.center.y + t.y);
	}

	// But also, detect the swipe gesture
	if (recognizer.state == UIGestureRecognizerStateEnded)
	{
		if (self.dialTimerViewer.center.y > 590){
			
			[UIView animateWithDuration:0.5
							 animations:^{
								 self.dialTimerViewer.center =
									CGPointMake(self.dialTimerViewer.center.x,
												610);
								
				self.downArrowIconLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(20, 0),  CGAffineTransformMakeRotation(degreesToRadians(90)));
				self.pullDownLabel.alpha = 0.0;
				self.startTimerLabel.alpha = 0.0;
								 
			} completion:^(BOOL finished) {
				
				if (finished){
					[UIView animateWithDuration:0.5
									 animations:^{
										 [self.countDownLabel.layer removeAllAnimations];
										 self.countDownLabel.text = @"0:00";
										 UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:75];
										 self.countDownLabel.font = textFont;
										 self.countDownLabel.textColor = [UIColor grayColor];
										 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
										 int countDownDuration = [defaults integerForKey:@"timerDuration"];
										 NSLog(@"Setting duration for %d", countDownDuration);
										 
										 [self.countDownTimer setUpTimerWithCountDownTimer:countDownDuration];
										 [self.countDownTimer startTimer];
									 }];
				}
			}];
			
		}else{
			[UIView animateWithDuration:0.2 animations:^{
				
				self.dialTimerViewer.center =
					CGPointMake(self.dialTimerViewer.center.x,
								215);

				self.downArrowIconLabel.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
				self.pullDownLabel.alpha = 1.0;
				self.startTimerLabel.alpha = 1.0;
				
			}];
		}
		self.dialTimerViewer.alpha = 1.0;
		self.dialTimerViewer.layer.shadowOffset = CGSizeMake(0, 0);
	}else if (recognizer.state == UIGestureRecognizerStateBegan){
		
	}

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"center"]) {
		id newPoint = [change objectForKey:@"new"];
		CGPoint centerValue = [newPoint CGPointValue];

		// Calculating new Y point for dragview
		CGFloat newDragY = 50 - ((30.f / 395.f)*(centerValue.y - 215.f));
		self.dragView.center =
			CGPointMake(self.dragView.center.x,
						newDragY);
		
		// Calculating new Y point for count down view
		CGFloat newCountDownY = 14 + ((220.f / 395.f)*(centerValue.y - 215.f));
		self.countDownView.center =
			CGPointMake(self.countDownView.center.x,
						newCountDownY);
		
		if (!self.countDownTimer.isCountDownRunning){
			// Calculating new progress for progress view
			CGFloat newProgress = 0 + ((1.0f / 395.f) * (centerValue.y - 215.f));
			[self.countDownTimer setProgress:newProgress];
			
			// Animate the headerView and slidingHeaderView frame
			if (centerValue.y >= 500){
				if ([self.countDownLabel.text isEqualToString:@"READY"]){
					[UIView animateWithDuration:1.0 animations:^{
						self.countDownLabel.alpha = 0.0;
					} completion:^(BOOL finished) {
						if (finished){
							[UIView animateWithDuration:0.2 animations:^{
								self.countDownLabel.text = @"START";
								self.countDownLabel.textColor = [UIColor greenColor];
								self.countDownLabel.alpha = 1.0;
							}];
						}
					}];
				}
			}else{
				self.countDownLabel.text = @"READY";
				self.countDownLabel.textColor = [UIColor orangeColor];
			}
		}
	}
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
								 // NSLog(@"Hello");
							  }
	 ];
	NSString *formattedTime;

	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:75];
	self.countDownLabel.font = textFont;
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

	self.countDownLabel.text = formattedTime;
	UIFont* timerTextFont = [UIFont fontWithName:@"KS-Normal" size:16];
	self.countDownTextLabel.font = timerTextFont;
	self.countDownTextLabel.text = [[returnString stringByReplacingOccurrencesOfString:@"zero hour :" withString:@""] stringByReplacingOccurrencesOfString:@"zero minute :" withString:@""];;
	self.countDownTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	self.countDownTextLabel.numberOfLines = 1;
}

- (NSString *)getWrittenTimeFromMinutes:(int)currentMinutes
{
	
    int minutes = currentMinutes % 60;
    int hours = currentMinutes / 60;
	
	NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterSpellOutStyle];
	
	NSString *hoursString = [f stringFromNumber:[NSNumber numberWithInt:hours]];
	NSString *minsString = [f stringFromNumber:[NSNumber numberWithInt:minutes]];
	
	NSString *returnString;
	
	if (hours <= 1 && minutes <= 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minute",hoursString, minsString];
	}else if (hours <= 1 && minutes > 1){
		returnString = [NSString stringWithFormat:@"%@ hour : %@ minutes",hoursString, minsString];
	}else if (hours > 1 && minutes <= 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minute",hoursString, minsString];
	}else if (hours > 1 && minutes > 1){
		returnString = [NSString stringWithFormat:@"%@ hours : %@ minutes",hoursString, minsString];
	}
	
	return [[returnString stringByReplacingOccurrencesOfString:@"zero hour :" withString:@""] stringByReplacingOccurrencesOfString:@": zero minute" withString:@""];
}

@end
