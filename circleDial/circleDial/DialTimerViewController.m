//
//  DialTimerViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-09-01.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "DialTimerViewController.h"
#import "NSString+SSGizmo.h"

#define degreesToRadians(x) (M_PI * x / 180.0)

@interface DialTimerViewController ()

@property (nonatomic, assign) BOOL disablePanUpdate;

@end

@implementation DialTimerViewController
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
	// Do any additional setup after loading the view, typically from a nib.
	
	[self.progressTimer setUpTimerWithCountDownTimer:1 withTimerLabel:self.timerLabel withWrittenTimerLabel:self.writtenTimerLabel];
	
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:115];
	self.timerLabel.font = textFont;
	self.timerLabel.textAlignment = NSTextAlignmentCenter;
	
	UIFont* reminderTextFont = [UIFont fontWithName:@"KlinicSlab-Medium" size:16];	
	self.setTimerLabel.font = reminderTextFont;
	self.setTimerLabel.textAlignment = NSTextAlignmentCenter;
	
	UIFont* timerTextFont = [UIFont fontWithName:@"KS-Normal" size:16];
	self.writtenTimerLabel.font = timerTextFont;
	self.writtenTimerLabel.textAlignment = NSTextAlignmentCenter;
	
	[self.view addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
	
	[self setWantsFullScreenLayout:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onPanDetected:(UIPanGestureRecognizer*)sender {
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

-(void)willMoveToParentViewController:(UIViewController *)parent{
	NSLog(@"will move to parent");
}

-(void)didMoveToParentViewController:(UIViewController *)parent{
	self.view.frame = CGRectMake(0,0,320, 429);
	NSLog(@"did move to parent");
}

- (void)disableGesture{
	[self.progressTimer removeGestureRecognizer:self.timerPanRecognizer];
}

- (void)enableGesture{
	[self.progressTimer addGestureRecognizer:self.timerPanRecognizer];
}

@end
