//
//  RLCSliderMenu.m
//  PageSliderDemo
//
//  Created by raymond chen on 2012-12-10.
//  Copyright (c) 2012 raymond chen. All rights reserved.
//

#import "RLCSliderMenu.h"
#import "RLCStartTimeCell.h"
#import "RLCEndTimeCell.h"
#import "RLCStartTimeTitleCell.h"
#import "RLCEndTimeTitleCell.h"
#import "UIDevice+deviceInfo.h"
#import "UIWindow+RESideMenuExtensions.h"
#import "NSString+SSGizmo.h"
#import <math.h>
#import "RLCSliderMenu.h"
#import "UIView+bounce.h"

#define SWIPE_LEFT_THRESHOLD -1000.0f
#define SWIPE_RIGHT_THRESHOLD 1000.0f
#define FOURINCHSCREEN 1136
#define THREEFIVEINCHSCREEN 960

@interface RLCSliderMenu()

@property (nonatomic, strong) UIView *slidingCoverView;
@property (nonatomic, strong) UITapGestureRecognizer *sliderCoverViewGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *sliderCoverPanGesture;
@property (nonatomic, assign) CGRect sliderFrame;
@property (nonatomic, assign) int rowCount;
@property (nonatomic, assign) int sectionCount;
@property (nonatomic, assign) int state;
@property (nonatomic, strong) UIButton *repeatOnceButton;
@property (nonatomic, strong) UIButton *repeatLoopButton;
@property (nonatomic, strong) UILabel *onceLabel;
@property (nonatomic, strong) UILabel *repeatLabel;
@property (nonatomic, strong) UIFont *gizmoFont;
@property (nonatomic, strong) UIFont *klinicSlabMedFont;
@property (nonatomic, strong) UILabel *selectedLabel;
@property (nonatomic, strong) NSIndexPath *selectedRow;
@property (nonatomic, strong) NSLayoutConstraint *horizontalSpacing;
@end

@implementation RLCSliderMenu
@synthesize menuTableView = _menuTableView;
@synthesize delegate = _delegate;
@synthesize ImageArray = _ImageArray;
@synthesize slidingCoverView = _slidingCoverView;
@synthesize selectedCell = _selectedCell;
@synthesize orientation = _orientation;
@synthesize sliderCoverViewGesture = _sliderCoverViewGesture;
@synthesize sliderCoverPanGesture = _sliderCoverPanGesture;
@synthesize sliderFrame = _sliderFrame;
@synthesize sectionCount = _sectionCount;
@synthesize rowCount = _rowCount;
@synthesize menuState = _menuState;
@synthesize repeatOnceButton = _repeatOnceButton;
@synthesize repeatLoopButton = _repeatLoopButton;
@synthesize onceLabel = _onceLabel;
@synthesize repeatLabel = _repeatLabel;
@synthesize gizmoFont = _gizmoFont;
@synthesize klinicSlabMedFont = _klinicSlabMedFont;
@synthesize selectedLabel = _selectedLabel;
@synthesize selectedRow = _selectedRow;
@synthesize horizontalSpacing = _horizontalSpacing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Setup the menu table view
		self.menuTableView = [[UITableView alloc]init];
		self.menuTableView.dataSource = self;
		self.menuTableView.delegate = self;
		self.menuTableView.showsVerticalScrollIndicator = YES;
		self.menuTableView.scrollEnabled = NO;
		self.menuTableView.separatorColor = [UIColor clearColor];
		self.menuTableView.backgroundColor = [UIColor blueColor];
		//self.menuTableView.backgroundView = nil;
		self.menuTableView.bounces = YES;
		self.sectionCount = 1;
		self.rowCount = 0;
		
		// Add the menu table to the current view
		[self addSubview:self.menuTableView];
		
		
		UITableView *menuTableView = self.menuTableView;
		menuTableView.translatesAutoresizingMaskIntoConstraints = NO;
		NSDictionary *views = NSDictionaryOfVariableBindings(menuTableView);
		
		[self addConstraints:
		 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menuTableView]-0-|"
												 options:0
												 metrics:nil
												   views:views]];
		
		[self addConstraints:
		 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[menuTableView]-0-|"
												 options:0
												 metrics:nil
												   views:views]];
		
		
		
		[self setExclusiveTouch:YES];

		self.backgroundColor = [UIColor clearColor];
		self.state = 0;
		
		// Setup the loop buttons
		self.repeatLoopButton = [UIButton buttonWithType:UIButtonTypeCustom];
		self.repeatOnceButton = [UIButton buttonWithType:UIButtonTypeCustom];
	
		if ([UIDevice isDeviceAniPhone5]){
			self.repeatLoopButton.frame =
				CGRectMake(0.28 * self.frame.size.width,
						   568 * 0.48 - self.frame.size.height*0.20,
						   0.72 * self.frame.size.width,
						   self.frame.size.height*0.20);
			self.repeatOnceButton.frame =
				CGRectMake(0.28 * self.frame.size.width,
					   568 * 0.52,
					   0.72 * self.frame.size.width,
					   self.frame.size.height*0.20);
		}else{
			self.repeatLoopButton.frame =
				CGRectMake(160 - 0.28 * self.frame.size.width,
						   480 * 0.48 - self.frame.size.height*0.20,
						   0.72 * self.frame.size.width,
						   self.frame.size.height*0.20);
			self.repeatOnceButton.frame =
				CGRectMake(160 - 0.28 * self.frame.size.width,
					   480 * 0.52,
					   0.72 * self.frame.size.width,
					   self.frame.size.height*0.20);
		}
		
		self.gizmoFont = [UIFont fontWithName:@"SS Gizmo" size:30];
		self.klinicSlabMedFont = [UIFont fontWithName:@"KlinicSlab-Medium" size:40];
		
		self.repeatLoopButton.titleLabel.font = self.gizmoFont;
		self.repeatLoopButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		self.repeatLoopButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
		[self.repeatLoopButton setTitle:[NSString convertUnicode:@"0x1F501"]
							   forState:UIControlStateNormal];
		[self.repeatLoopButton addTarget:self
				   action:@selector(onRepeatButtonPressed:)
		 forControlEvents:UIControlEventTouchDown];
	
		self.repeatLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 80)];
		self.repeatLabel.font = self.klinicSlabMedFont;
		self.repeatLabel.text = @"repeat";
		self.repeatLabel.textColor = [UIColor grayColor];
		self.repeatLabel.center = self.repeatLoopButton.center;
		self.repeatLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.repeatLabel];
		
		self.onceLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 80)];
		self.onceLabel.font = self.klinicSlabMedFont;
		self.onceLabel.text = @"once";
		self.onceLabel.textColor = [UIColor grayColor];
		self.onceLabel.center = self.repeatOnceButton.center;
		self.onceLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.onceLabel];
		
		self.selectedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 80)];
		self.selectedLabel.font = self.gizmoFont;
		self.selectedLabel.text = [NSString convertUnicode:@"0x2713"];
		self.selectedLabel.textColor = [UIColor blackColor];
		self.selectedLabel.center = CGPointMake(self.repeatLabel.center.x + 120, self.repeatLabel.center.y);
		self.selectedLabel.backgroundColor = [UIColor clearColor];
		[self addSubview:self.selectedLabel];
		
		
		[self.repeatLoopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		self.repeatOnceButton.titleLabel.font = self.gizmoFont;
		self.repeatOnceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		self.repeatOnceButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
		[self.repeatOnceButton setTitle:[NSString convertUnicode:@"0x21BA"]
							   forState:UIControlStateNormal];
		[self.repeatOnceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.repeatOnceButton addTarget:self
								  action:@selector(onOnceButtonPressed:)
						forControlEvents:UIControlEventTouchDown];
		
		[self addSubview:self.repeatLoopButton];
		[self addSubview:self.repeatOnceButton];
    }
    return self;
}

- (void)onOnceButtonPressed:(UIButton*)button{
	[UIView animateWithDuration:0.5
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.selectedLabel.center = CGPointMake(self.onceLabel.center.x + 120, self.onceLabel.center.y);
	} completion:^(BOOL finished) {
		
	}];
}

- (void)onRepeatButtonPressed:(UIButton*)button{
	[UIView animateWithDuration:0.5
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.selectedLabel.center = CGPointMake(self.repeatLabel.center.x + 120, self.repeatLabel.center.y);
					 } completion:^(BOOL finished) {
						 
					 }];
}

#
# pragma UITableViewDataSource
#

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.rowCount;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.row == 1 || indexPath.row == 3){
		self.selectedRow =
		[self.selectedRow isEqual:indexPath] ? nil:indexPath;
		
		[tableView beginUpdates];
		[tableView endUpdates];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat returnHeightValue;
	if ([UIDevice isDeviceAniPhone5]){
		if (indexPath.row !=1 && indexPath.row != 3){
			returnHeightValue = 568 * 0.80 * 0.15;
		}else{
			returnHeightValue = 568 * 0.80 * 0.30;
		}
	}else{
		if (indexPath.row == 0 ){
			returnHeightValue = 480 * 0.80 * 0.20;
		}else if (indexPath.row == 2){
			returnHeightValue = 480 * 0.80 * 0.15;
		}else{
			if (!self.selectedRow){
				returnHeightValue = 480 * 0.80 * 0.30;
			}else if ([self.selectedRow isEqual:indexPath]){
				returnHeightValue = 480 * 0.80 * 0.40;
			}else{
				returnHeightValue = 480 * 0.80 * 0.30;
			}
		}
			
	}
	return returnHeightValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *returnedCell;
	switch (indexPath.row) {
		case 0:
		{
			RLCStartTimeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartTimeTitleCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"RLCStartTimeTitleCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (RLCStartTimeTitleCell*)view;
					}
				}
			}
			UIFont *iconfont = [UIFont fontWithName:@"SS Gizmo" size:32];
			UIFont *textfont = [UIFont systemFontOfSize:15];
			cell.alarmLabel.font = iconfont;
			cell.alarmLabel.textAlignment = NSTextAlignmentCenter;
			cell.reminderLabel.textAlignment = NSTextAlignmentCenter;
			cell.alarmLabel.text = [NSString convertUnicode:@"0x1F514"];
			cell.reminderLabel.font = textfont;
			cell.reminderLabel.text = @"Please remind me from";
			
			returnedCell = cell;
			break;
		}
			
		case 1:
		{
			RLCStartTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartTimeCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"RLCStartTimeCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (RLCStartTimeCell*)view;
					}
				}
			}
			UIFont *iconfont = [UIFont fontWithName:@"SS Gizmo" size:20];
			UIFont *textfont = [UIFont systemFontOfSize:56];
			cell.downArrowLabel.font = iconfont;
			cell.downArrowLabel.textAlignment = NSTextAlignmentCenter;
			cell.startTimeLabel.textAlignment = NSTextAlignmentCenter;
			cell.downArrowLabel.text = [NSString convertUnicode:@"0xF501"];
			cell.startTimeLabel.font = textfont;
			
			
			[cell.flatDatePicker setDelegate:cell];
			[cell.flatDatePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
			[cell.flatDatePicker setFontColor:[UIColor whiteColor]];
			[cell.flatDatePicker update];
			
			NSCalendar *cal = [NSCalendar currentCalendar];
			[cal setTimeZone:[NSTimeZone localTimeZone]];
			[cal setLocale:[NSLocale currentLocale]];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setMinute:0];
			[comps setHour:9];
			
			[cell.flatDatePicker setDate:[cal dateFromComponents:comps] animated:YES];

			returnedCell = cell;
			break;
		}
			
		case 2:
		{
			RLCEndTimeTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndTimeTitleCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"RLCEndTimeTitleCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (RLCEndTimeTitleCell*)view;
					}
				}
			}
			UIFont *textfont = [UIFont systemFontOfSize:15];
			cell.toLabel.font = textfont;
			cell.toLabel.textAlignment = NSTextAlignmentCenter;
			cell.toLabel.text = @"to";
			returnedCell = cell;
			
			break;
		}
			
		case 3:
		{
			RLCEndTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EndTimeCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"RLCEndTimeCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (RLCEndTimeCell*)view;
					}
				}
			}
			UIFont *iconfont = [UIFont fontWithName:@"SS Gizmo" size:20];
			UIFont *textfont = [UIFont systemFontOfSize:56];
			cell.upArrowLabel.font = iconfont;
			cell.upArrowLabel.textAlignment = NSTextAlignmentCenter;
			cell.endTimeLabel.textAlignment = NSTextAlignmentCenter;
			cell.upArrowLabel.text = [NSString convertUnicode:@"0xF500"];
			cell.endTimeLabel.font = textfont;
			
			[cell.flatDatePicker setDelegate:cell];
			[cell.flatDatePicker setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
			[cell.flatDatePicker setFontColor:[UIColor whiteColor]];
			[cell.flatDatePicker update];
			
			NSCalendar *cal = [NSCalendar currentCalendar];
			[cal setTimeZone:[NSTimeZone localTimeZone]];
			[cal setLocale:[NSLocale currentLocale]];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setMinute:0];
			[comps setHour:21];
			
			[cell.flatDatePicker setDate:[cal dateFromComponents:comps] animated:YES];
			
			returnedCell = cell;
			break;
		}
			
		default:
			break;
	}
	
	returnedCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnedCell;
}

- (void)addMenuViewToMainView:(UIView*)mainView withSlidingView:(UIView *)slideView
{
	// Updating the slideView object to the class
	self.slidingCoverView = slideView;
	self.slidingCoverView.layer.masksToBounds = NO;
	self.slidingCoverView.layer.shadowOffset = CGSizeMake(-5, 10);
	self.slidingCoverView.layer.shadowRadius = 5;
	self.slidingCoverView.layer.shadowOpacity = 0.5;
	
	[mainView addSubview:self];
	[mainView sendSubviewToBack:self];
	
	NSLog(@"Array of views in main View %@", [mainView subviews]);
	
	[self setTranslatesAutoresizingMaskIntoConstraints:NO];
	UIView *menuView = self;
	
	NSDictionary *views = NSDictionaryOfVariableBindings(menuView);
	
	
	
	[mainView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[menuView(320)]-0-|"
											 options:0
											 metrics:nil
											   views:views]];
	
	[mainView addConstraints:
	 [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[menuView]-0-|"
											 options:0
											 metrics:nil
											   views:views]];
	

	self.repeatOnceButton.hidden = YES;
	self.repeatLoopButton.hidden = YES;
	self.repeatLabel.hidden = YES;
	self.onceLabel.hidden = YES;
	
	if (![self.slidingCoverView.gestureRecognizers containsObject:self.sliderCoverViewGesture]){
		// Setup tap recognizer
		self.sliderCoverViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderViewTapped:)];
		[self.slidingCoverView addGestureRecognizer:self.sliderCoverViewGesture];
	}
	
	[self.slidingCoverView addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:NULL];
}

- (void)setUpPanGestureForViews:(NSArray*)arrayViews{
	for (UIView *view in arrayViews){
		
		if (![view.gestureRecognizers containsObject:self.sliderCoverPanGesture]){
			// Setup pam recognizer
			self.sliderCoverPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(sliderViewPammed:)];
			[view addGestureRecognizer:self.sliderCoverPanGesture];
			
		}
	}
}

- (void)setupHLeadingSpace:(NSLayoutConstraint*)horizontalSpacing{
	self.horizontalSpacing = horizontalSpacing;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"center"]) {
		id newPoint = [change objectForKey:@"new"];
		CGPoint centerValue = [newPoint CGPointValue];
		NSLog(@"center value is %f", centerValue.x);
		if (centerValue.x <= 160){
			if (self.menuState == SLIDERMENUSTATE_REPEATMENUON ||
				self.menuState == SLIDERMENUSTATE_OFF){
				
				self.menuTableView.hidden = YES;
				self.repeatOnceButton.hidden = NO;
				self.repeatLoopButton.hidden = NO;
				self.repeatLabel.hidden = NO;
				self.onceLabel.hidden = NO;
				self.selectedLabel.hidden = NO;
			}
		}else{
			if (self.menuState == SLIDERMENUSTATE_TIMERMENUON ||
				self.menuState == SLIDERMENUSTATE_OFF){
				
				self.menuTableView.hidden = NO;
				self.repeatOnceButton.hidden = YES;
				self.repeatLoopButton.hidden = YES;
				self.repeatLabel.hidden = YES;
				self.onceLabel.hidden = YES;
				self.selectedLabel.hidden = YES;
			}
		}
	}
}


- (void)sliderViewTapped:(UIGestureRecognizer*)gestureRecognizer{
	[self slideIn];
}


- (void)slideIn{
	// Slide in the sliding view and update the menu states to OFF
	[UIView animateWithDuration:0.2
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
		[self.horizontalSpacing setConstant:
						  0];
		self.slidingCoverView.center = CGPointMake(160, self.slidingCoverView.center.y);
						 self.slidingCoverView.transform = CGAffineTransformIdentity;
		[self.slidingCoverView layoutIfNeeded];
	} completion:^(BOOL finished) {
		 self.menuState = SLIDERMENUSTATE_OFF;
	}];	
}

- (void)slideOutTimerMenu{
	self.menuTableView.hidden = NO;
	//self.slidingCoverView.alpha = 0.0;
	[UIView animateWithDuration:0.3
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
		//self.slidingCoverView.center = CGPointMake(self.slidingCoverView.frame.size.width * 1.28, self.slidingCoverView.center.y);
						 [self.horizontalSpacing setConstant:
						 200];
		[self.slidingCoverView layoutIfNeeded];
		//self.slidingCoverView.transform = CGAffineTransformMakeScale(0.92, 0.92);
						 
	} completion:^(BOOL finished) {
		self.menuState = SLIDERMENUSTATE_TIMERMENUON;
		if (self.rowCount == 0){
			[self performSelector:@selector(insertRowInTableWithLeftAnimation:)
					   withObject:[NSNumber numberWithInt:0]
					   afterDelay:0];
			[self performSelector:@selector(insertRowInTableWithLeftAnimation:)
					   withObject:[NSNumber numberWithInt:1]
					   afterDelay:0.10];
			[self performSelector:@selector(insertRowInTableWithLeftAnimation:)
					   withObject:[NSNumber numberWithInt:2]
					   afterDelay:0.15];
			[self performSelector:@selector(insertRowInTableWithLeftAnimation:)
					   withObject:[NSNumber numberWithInt:3]
					   afterDelay:0.20];
		}

	}];

	if (![self.slidingCoverView.gestureRecognizers containsObject:self.sliderCoverViewGesture]){
		// Setup tap recognizer
		self.sliderCoverViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderViewTapped:)];
		[self.slidingCoverView addGestureRecognizer:self.sliderCoverViewGesture];
	}
		
}

- (void)slideOutRepeatMenu{
	self.menuTableView.hidden = YES;
	self.repeatOnceButton.hidden = NO;
	self.repeatLoopButton.hidden = NO;
	[UIView animateWithDuration:0.3
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseInOut
					 animations:^{
						 self.slidingCoverView.center = CGPointMake(-(self.slidingCoverView.frame.size.width * 0.28), self.slidingCoverView.center.y);
						 NSLog(@"Center is %@", NSStringFromCGPoint(self.slidingCoverView.center));
						 self.slidingCoverView.transform = CGAffineTransformMakeScale(0.92, 0.92);
						 
					 } completion:^(BOOL finished) {
						 self.menuState = SLIDERMENUSTATE_REPEATMENUON;
					}];
	
	if (![self.slidingCoverView.gestureRecognizers containsObject:self.sliderCoverViewGesture]){
		// Setup tap recognizer
		self.sliderCoverViewGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderViewTapped:)];
		[self.slidingCoverView addGestureRecognizer:self.sliderCoverViewGesture];
	}
	
}

- (void)insertRowInTableWithLeftAnimation:(NSNumber*)rowNumber{
	self.rowCount++;
	self.sectionCount = 1;
	[self.menuTableView beginUpdates];
	[self.menuTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowNumber.intValue inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
	[self.menuTableView endUpdates];
}

- (void)insertRowInTableWithFadeAnimation:(NSNumber*)rowNumber{
	self.rowCount++;
	[self.menuTableView beginUpdates];
	[self.menuTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rowNumber.intValue inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
	[self.menuTableView endUpdates];
}

- (void)sliderViewPammed:(UIPanGestureRecognizer *)recognizer
{
	// Get the translation in the view
    CGPoint t = [recognizer translationInView:recognizer.view];
	
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
	if (self.slidingCoverView.center.x + t.x < 460 && self.slidingCoverView.center.x + t.x > -160){
		self.slidingCoverView.center = CGPointMake(self.slidingCoverView.center.x + t.x, self.slidingCoverView.center.y);
	}
	    // But also, detect the swipe gesture
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint vel = [recognizer velocityInView:recognizer.view];
		
        if (vel.x < SWIPE_LEFT_THRESHOLD)
        {
            // Detected a swipe to the left
			(self.menuState == SLIDERMENUSTATE_OFF)?[self slideOutRepeatMenu]:[self slideIn];
			[self.slidingCoverView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }
        else if (vel.x > SWIPE_RIGHT_THRESHOLD)
        {
            // Detected a swipe to the right
			
			(self.menuState == SLIDERMENUSTATE_OFF)?[self slideOutTimerMenu]:[self slideIn];
			[self.slidingCoverView bounceXPosition:5 withDuration:0.1 withRepeatCount:2];
        }
        else
        {
			if (self.slidingCoverView.frame.origin.x > 70){
				NSLog(@"Greater than 70");
				if (self.menuState != SLIDERMENUSTATE_TIMERMENUON){
					[self slideOutTimerMenu];
				}else{
					[self slideIn];
				}
				
			}else if (abs(self.slidingCoverView.frame.origin.x) < 70){
				NSLog(@"in than 70");
				[self slideIn];
				
			}else{
				NSLog(@"in than 70 more");
				[self slideIn];
				//[self slideOutRepeatMenu];
			}
			
        }
    }
}


- (UIImage*)getScreenShot{
	// Capture Screenshot
	CGSize imageSize = [[UIScreen mainScreen] bounds].size;
	UIGraphicsBeginImageContext(imageSize);
	[self.slidingCoverView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return screenshotImage;
}

#pragma mark - Singleton implementation in ARC
+ (RLCSliderMenu *)sharedSliderMenu
{
	static RLCSliderMenu *sharedLocationControllerInstance = nil;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		//NSLog(@"Creating the location manager singleton");
		CGRect frame = [[UIScreen mainScreen] applicationFrame];
		frame.origin.y = 0;
		sharedLocationControllerInstance = [[self alloc] initWithFrame:frame];
	});
	return sharedLocationControllerInstance;
}

@end
