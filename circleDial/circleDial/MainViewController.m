//
//  MainViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-09-12.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+bounce.h"
#import "NSString+SSGizmo.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

#define kTopMarginDragView (IS_IPHONE_5  ? 0 : 0)
#define kBottomMarginDragView (IS_IPHONE_5  ? 518 : 430)
#define kTopMarginDialSetupView (IS_IPHONE_5  ? 249.5 : 205.5)
#define kBottomMarginDialSetupView (IS_IPHONE_5  ? 483 : 395)
#define SWIPE_UP_THRESHOLD -1000.0f
#define SWIPE_DOWN_THRESHOLD 1000.0f

#define kMaxHorizontalTimerBtnCenter 404.f
#define kMinHorizontalTimerBtnCenter 160.f
#define kMinHorizontalRepeatBtnCenter -90.00
#define kMaxHorizontalRepeatBtnCenter 160

#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f

typedef enum MenuState {
	MENU_OFF,
	MENU_TIMERMENUON,
	MENU_REPEATMENUON,
}MenuState;

@interface MainViewController ()

@property (nonatomic, strong) RLCSliderMenu *sliderMenu;
@property (nonatomic, assign) MenuState currentMenuState;
@property (nonatomic, assign) BOOL isTimerButtonBeingDragged;
@property (nonatomic, assign) BOOL isRepeatButtonBeingDragged;
@property (nonatomic, assign) BOOL disablePanUpdate;

@end

@implementation MainViewController
@synthesize isTimerButtonBeingDragged = _isTimerButtonBeingDragged;
@synthesize disablePanUpdate = _disablePanUpdate;


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
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	// Setup menu button
	UIFont* font = [UIFont fontWithName:@"SS Gizmo" size:30];
	self.timerBtn.titleLabel.font = font;
	self.timerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
	[self.timerBtn setTitle:[NSString convertUnicode:@"0x1F514"]
					 forState:UIControlStateNormal];
	[self.timerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	// Setup setting button
	self.repeatBtn.titleLabel.font = font;
	self.repeatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.repeatBtn setTitle:[NSString convertUnicode:@"0x1F501"]
						forState:UIControlStateNormal];
	
	[self.repeatBtn setTitleColor:[UIColor whiteColor]
							 forState:UIControlStateNormal];
	
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:115];
	self.timerLabel.font = textFont;
	self.timerLabel.textAlignment = NSTextAlignmentCenter;
	
	
	UIFont* reminderTextFont = [UIFont fontWithName:@"KlinicSlab-Medium" size:16];
	self.setTimerLabel.font = reminderTextFont;
	self.setTimerLabel.textAlignment = NSTextAlignmentCenter;
	
	UIFont* timerTextFont = [UIFont fontWithName:@"KS-Normal" size:16];
	self.writtenTimerLabel.font = timerTextFont;
	self.writtenTimerLabel.textAlignment = NSTextAlignmentCenter;

	
	// Setup listener for setupDialView
	[self.setupTimerView addObserver:self
						  forKeyPath:@"center"
							 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
							 context:NULL];
	
	[self.clipView addObserver:self
					forKeyPath:@"center"
					   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
						context:NULL];
	
	[self addObserver:self
		   forKeyPath:@"currentMenuState"
			  options:(NSKeyValueObservingOptionNew |
					   NSKeyValueObservingOptionOld)
			  context:NULL];
	
	[self.progressTimer setUpTimerWithCountDownTimer:1 withTimerLabel:self.timerLabel withWrittenTimerLabel:self.writtenTimerLabel];
	self.currentMenuState = MENU_OFF;
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	// Setup timer progress view and text
}

- (IBAction)onTimerButtonPressed:(id)sender {
	[self toggleTimerBtn];
}

- (void)toggleTimerBtn{
	[UIView animateWithDuration:0.25 animations:^{
		self.clipView.transform = (self.currentMenuState == MENU_TIMERMENUON) ?
		CGAffineTransformIdentity : CGAffineTransformMakeScale(0.9, 0.9);
		self.VTopSpaceClipView.constant = (self.currentMenuState == MENU_TIMERMENUON) ?
		0 : self.view.bounds.size.height*0.05;
		self.VBottomSpaceClipView.constant = (self.currentMenuState == MENU_TIMERMENUON) ?
		0 : self.view.bounds.size.height*0.05;
		self.HLeadingSpaceClipView.constant = (self.currentMenuState == MENU_TIMERMENUON) ?
		0 : 260;
		[self.view layoutIfNeeded];
	} completion:^(BOOL finished) {
		if (finished){
			[self performSelector:@selector(switchTimer)
					   withObject:nil
					   afterDelay:0.0];
		}
	}];
}

- (void)toggleRepeatBtn{
	
	[UIView animateWithDuration:0.25 animations:^{
		self.HLeadingSpaceClipView.constant = (self.currentMenuState == MENU_REPEATMENUON) ?
		0 : -234;
		self.clipView.transform = (self.currentMenuState == MENU_REPEATMENUON) ?
		CGAffineTransformIdentity : CGAffineTransformMakeScale(0.9, 0.9);
		self.VTopSpaceClipView.constant = (self.currentMenuState == MENU_REPEATMENUON) ?
		0 : self.view.bounds.size.height*0.05;
		self.VBottomSpaceClipView.constant = (self.currentMenuState == MENU_REPEATMENUON) ?
		0 : self.view.bounds.size.height*0.05;
		[self.view layoutIfNeeded];
		[self performSelector:@selector(switchRepeat)
				   withObject:nil
				   afterDelay:0.10];

	} completion:^(BOOL finished) {

	}];

}

- (void)switchTimer{
	self.currentMenuState = (self.currentMenuState == MENU_TIMERMENUON) ? MENU_OFF : MENU_TIMERMENUON;
}

- (void)switchRepeat{
	self.currentMenuState = (self.currentMenuState == MENU_REPEATMENUON) ? MENU_OFF : MENU_REPEATMENUON;
}

- (IBAction)onRepeatButtonPressed:(id)sender {
	[self toggleRepeatBtn];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"center"]) {
		if ([object isEqual:self.clipView]){
			id newPoint = [change objectForKey:@"new"];
			CGPoint centerValue = [newPoint CGPointValue];
//			if (self.isTimerButtonBeingDragged){
//				id newPoint = [change objectForKey:@"new"];
//				CGPoint centerValue = [newPoint CGPointValue];
//				
//				// Calculating new Y point for dragview
//				CGFloat newDragY = 20.f - ((20.f / (kBottomMarginDialSetupView - kTopMarginDialSetupView)) * (centerValue.y - kTopMarginDialSetupView));
//				
//				[self.VDragViewSpacing setConstant:newDragY];
//			}else if (self.isRepeatButtonBeingDragged){
//				CGFloat newPercentage = ((0.1f / (kMaxHorizontalRepeatBtnCenter - kMinHorizontalRepeatBtnCenter)) * (centerValue.x - kMinHorizontalRepeatBtnCenter));
//				NSLog(@"newDrag is %f", newPercentage);
//			}
			
		}else{
			id newPoint = [change objectForKey:@"new"];
			CGPoint centerValue = [newPoint CGPointValue];
			
			// Calculating new Y point for dragview
			CGFloat newDragY = 20.f - ((20.f / (kBottomMarginDialSetupView - kTopMarginDialSetupView)) * (centerValue.y - kTopMarginDialSetupView));
			
			[self.VDragViewSpacing setConstant:newDragY];
		}
	}else if ([keyPath isEqual:@"currentMenuState"]){
		int newState = [[change objectForKey:@"new"] integerValue];
		switch (newState) {
			case 1:
				[[NSNotificationCenter defaultCenter]postNotificationName:@"presentTimerMenu"
																   object:nil];
				break;
			case 2:
				[[NSNotificationCenter defaultCenter]postNotificationName:@"presentRepeatMenu"
												object:nil];
				break;
			case 0:
				[[NSNotificationCenter defaultCenter]postNotificationName:@"presentRepeatMenu"
				 object:nil];
			default:
				break;
		}
		
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onDragViewPanned:(UIPanGestureRecognizer*)sender {

	CGPoint t = [sender translationInView:sender.view];
	
    [sender setTranslation:CGPointZero
					inView:sender.view];

	// Update the dragView location
	if (self.VSetupTimerViewSpacing.constant + t.y <= kBottomMarginDragView &&
		self.VSetupTimerViewSpacing.constant + t.y >= kTopMarginDragView){
		
		//NSLog(@"HEllo");
		NSLog(@"v spacing is %f",self.VSetupTimerViewSpacing.constant);
		[self.VSetupTimerViewSpacing  setConstant:
				self.VSetupTimerViewSpacing.constant + t.y];
		[self.VBottomSpaceSetupTimerView setConstant:self.VBottomSpaceSetupTimerView.constant - t.y];
		NSNumber *spacing = [NSNumber numberWithFloat:self.VSetupTimerViewSpacing.constant];
		[[NSNotificationCenter defaultCenter]postNotificationName:@"DragViewPanned" object:nil userInfo:[NSDictionary dictionaryWithObject:spacing forKey:@"DragViewSpace"]];
	}
	
	
	// But also, detect the swipe gesture
	if (sender.state == UIGestureRecognizerStateEnded)
	{		
		if (self.VSetupTimerViewSpacing.constant > kBottomMarginDragView - 45){
			
			[UIView animateWithDuration:0.5
							 animations:^{
								[self.VSetupTimerViewSpacing
								  setConstant: kBottomMarginDragView - 15];
								[self.view layoutIfNeeded];
							}completion:^(BOOL finished) {

								if (finished){
									[[NSNotificationCenter defaultCenter]postNotificationName:@"startTimer"
																					   object:nil];
								}
								
			}];
		}else{
			[UIView animateWithDuration:0.5
							 animations:^{
								[self.VSetupTimerViewSpacing
								  setConstant:0];
								 [self.VBottomSpaceSetupTimerView
								  setConstant:49];
								[self.view layoutIfNeeded];
							}completion:^(BOOL finished) {

								[self.setupTimerView bounceYPosition:5
														withDuration:0.1
													 withRepeatCount:2];
							
								 
							 }];
		}
	}else if (sender.state == UIGestureRecognizerStateBegan){

	}
	
}

- (IBAction)onTimerButtonDragged:(UIPanGestureRecognizer*)sender {
	self.isTimerButtonBeingDragged = YES;
	
	// Send notification for timer menu
	[[NSNotificationCenter defaultCenter]
					postNotificationName:@"presentTimerMenu"
								  object:nil];
	
	CGPoint t = [sender translationInView:sender.view];
	
    [sender setTranslation:CGPointZero
					inView:sender.view];
	
	// Update the dragView location
	if (self.clipView.center.x + t.x >= kMinHorizontalTimerBtnCenter &&
		self.clipView.center.x + t.x <= kMaxHorizontalTimerBtnCenter){
		
		[self.HLeadingSpaceClipView  setConstant:
		 self.HLeadingSpaceClipView.constant + t.x];
	}
	
	
	// But also, detect the swipe gesture
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		self.isTimerButtonBeingDragged = NO;
		CGPoint vel = [sender velocityInView:sender.view];
		
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            // Detected a swipe to the left
			[self toggleTimerBtn];
			[self.clipView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            // Detected a swipe to the right
			[self toggleTimerBtn];
			[self.clipView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }else{
			if (self.clipView.center.x > kMaxHorizontalTimerBtnCenter * 0.65){
				NSLog(@"Showing");
				[UIView animateWithDuration:0.5
								 animations:^{
									 self.clipView.transform = CGAffineTransformMakeScale(0.9, 0.9);
									 [self.VTopSpaceClipView setConstant:self.view.bounds.size.height*0.05];
									 [self.VBottomSpaceClipView setConstant:self.view.bounds.size.height*0.05];
									 self.HLeadingSpaceClipView.constant = 260;
									 [self.view layoutIfNeeded];
								 }];
				
			}else{
				NSLog(@"Hiding");
				[UIView animateWithDuration:0.5
								 animations:^{
									 self.clipView.transform = CGAffineTransformIdentity;
									 [self.VTopSpaceClipView setConstant:0];
									 [self.VBottomSpaceClipView setConstant:0];
									 self.HLeadingSpaceClipView.constant = 0;
									 [self.view layoutIfNeeded];
								 }];
				
			}
		}
	}
}

- (IBAction)onRepeatButtonDragged:(UIPanGestureRecognizer*)sender {
	self.isRepeatButtonBeingDragged = YES;
	
	// Send the notification
	[[NSNotificationCenter defaultCenter]
			postNotificationName:@"presentRepeatMenu"
							object:nil];
	
	CGPoint t = [sender translationInView:sender.view];
	
    [sender setTranslation:CGPointZero
					inView:sender.view];
	
	NSLog(@"center is %f", self.clipView.center.x);
	// Update the dragView location
	if (self.clipView.center.x + t.x <= kMaxHorizontalRepeatBtnCenter &&
		self.clipView.center.x + t.x >= kMinHorizontalRepeatBtnCenter){
		
		[self.HLeadingSpaceClipView setConstant:
		 self.HLeadingSpaceClipView.constant + t.x];
	}
	
	
	// But also, detect the swipe gesture
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		self.isRepeatButtonBeingDragged = NO;
		CGPoint vel = [sender velocityInView:sender.view];
		
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            // Detected a swipe to the left
			[self toggleRepeatBtn];
			[self.clipView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            // Detected a swipe to the right
			[self toggleRepeatBtn];
			[self.clipView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }else{
			if (self.clipView.center.x < kMaxHorizontalRepeatBtnCenter * 0.65){
				[UIView animateWithDuration:0.5
								 animations:^{
									 self.clipView.transform = CGAffineTransformMakeScale(0.9, 0.9);
									 [self.VTopSpaceClipView setConstant:self.view.bounds.size.height*0.05];
									 [self.VBottomSpaceClipView setConstant:self.view.bounds.size.height*0.05];
									 self.HLeadingSpaceClipView.constant = -234;
									 [self.view layoutIfNeeded];
								 }];

			}else{
				[UIView animateWithDuration:0.5
								 animations:^{
									 self.clipView.transform = CGAffineTransformIdentity;
									 [self.VTopSpaceClipView setConstant:0];
									 [self.VBottomSpaceClipView setConstant:0];
									 self.HLeadingSpaceClipView.constant = 0;
									 [self.view layoutIfNeeded];
								 }];
			}
		}
	}
	
}

- (IBAction)onDialViewPanDetected:(UIPanGestureRecognizer*)sender {
	CGFloat midX = (self.progressTimer.frame.size.width)/2;
	CGFloat midY = (self.progressTimer.frame.size.height) / 2;
	
	CGPoint touchPoint = [sender locationInView:self.progressTimer];
	
	CGFloat deltaX = touchPoint.x - midX;
	CGFloat deltaY = midY - touchPoint.y;
	float uneditedAngle = (atan2(deltaY, deltaX) * 180 / M_PI);
	
	CGPoint vel = [sender velocityInView:self.view];
	
	float newAngle = (uneditedAngle > 0) ? uneditedAngle : uneditedAngle + 360;
	
	switch (sender.state) {
		case UIGestureRecognizerStateEnded:
			self.disablePanUpdate = NO;
			self.writtenTimerLabel.text = [self.progressTimer returnWrittenTime];
			break;
		case UIGestureRecognizerStateBegan:
			self.disablePanUpdate = NO;
			break;
		case UIGestureRecognizerStateCancelled:
			self.disablePanUpdate = NO;
			break;
		case UIGestureRecognizerStateChanged:
			if (!self.disablePanUpdate){
				if (360 - newAngle > 250 && 360 - newAngle <=270){
					self.disablePanUpdate = ![self.progressTimer updateAngle:(250) isDirectionLeft:vel.x < 0];
				}else if (360 - newAngle > 278 && 360 - newAngle <= 288){
					self.disablePanUpdate = ![self.progressTimer updateAngle:(290) isDirectionLeft:vel.x < 0];
				}
				else{
					self.disablePanUpdate = ![self.progressTimer updateAngle:(360-newAngle) isDirectionLeft:vel.x < 0];
				}
			}
			break;
		default:
			break;
	}

	
}

- (IBAction)onDragViewTapped:(id)sender {
	if (self.VSetupTimerViewSpacing.constant ==kBottomMarginDragView - 15){
		NSLog(@"Tapped");
		[UIView animateWithDuration:0.5
						 animations:^{
							 [self.VSetupTimerViewSpacing
							  setConstant:0];
							 [self.VBottomSpaceSetupTimerView
							  setConstant:49];
							 [self.view layoutIfNeeded];
						 }completion:^(BOOL finished) {
							 
							 [self.setupTimerView bounceYPosition:5
													 withDuration:0.1
												  withRepeatCount:2];
							 
							 
						 }];
	}
}
@end
