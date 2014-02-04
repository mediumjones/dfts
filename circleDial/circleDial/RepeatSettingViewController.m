//
//  RepeatSettingViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "RepeatSettingViewController.h"
#import "repeatMenuCell.h"
#import "NSString+SSGizmo.h"

@interface RepeatSettingViewController ()

@property (nonatomic, assign) BOOL repeatOnceOn;

@end

@implementation RepeatSettingViewController
@synthesize repeatOnceOn = _repeatOnceOn;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.repeatTableView.backgroundView = nil;
		self.repeatTableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	self.repeatTableView.backgroundView = nil;
	self.repeatTableView.backgroundColor = [UIColor clearColor];
	
	self.checkMarkIconLabel.font = [UIFont fontWithName:@"SS Gizmo" size:30];;
	self.checkMarkIconLabel.text = [NSString convertUnicode:@"0x2713"];
	self.checkMarkIconLabel.textColor = [UIColor blackColor];
	
	NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
	self.repeatOnceOn = [defaultManager boolForKey:@"REPEATON"];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(showTimerMenu:)
												 name:@"presentTimerMenu"
											   object:nil];
	
	if (self.repeatOnceOn){
		self.checkMarkIconLabel.transform = CGAffineTransformTranslate(self.checkMarkIconLabel.transform, 0, 80);
	}
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)showTimerMenu:(NSNotification*)notification{
	[self dismissToTimerMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *returnCell;
	
	switch (indexPath.row) {
		case 0:
		{
			repeatMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repeatMenuCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"repeatMenuCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (repeatMenuCell*)view;
					}
				}
			}
			UIFont *iconFont = [UIFont fontWithName:@"SS Gizmo" size:30];
			UIFont *textFont = [UIFont fontWithName:@"KlinicSlab-Medium" size:30];
			
			repeatMenuCell *rCell = (repeatMenuCell*)cell;
			rCell.repeatIconLabel.font = iconFont;
			rCell.repeatIconLabel.text = [NSString convertUnicode:@"0x1F501"];
			rCell.repeatTextLabel.font = textFont;
			rCell.repeatTextLabel.text = @"REPEAT";
			returnCell = cell;
		}
			break;
		case 1:
		{
			repeatMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"repeatMenuCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"repeatMenuCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (repeatMenuCell*)view;
					}
				}
			}
			UIFont *iconFont = [UIFont fontWithName:@"SS Gizmo" size:30];
			UIFont *textFont = [UIFont fontWithName:@"KlinicSlab-Medium" size:30];
			
			repeatMenuCell *rCell = (repeatMenuCell*)cell;
			rCell.repeatIconLabel.font = iconFont;
			rCell.repeatIconLabel.text = [NSString convertUnicode:@"0x21BA"];
			rCell.repeatTextLabel.font = textFont;
			rCell.repeatTextLabel.text = @"ONCE";
			returnCell = cell;
		}
			break;
		
		default:
			break;
	}
	
	returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return returnCell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUserDefaults *defaultManager = [NSUserDefaults standardUserDefaults];
	switch (indexPath.row) {
		case 0:
		{
			if (self.repeatOnceOn){
				[UIView animateWithDuration:0.5 animations:^{
					self.checkMarkIconLabel.transform = CGAffineTransformIdentity;
					self.repeatOnceOn = NO;
					[defaultManager setBool:NO forKey:@"REPEATON"];
					[defaultManager synchronize];
				}];
			}
			break;
		}
		case 1:
		{
			if (!self.repeatOnceOn){
				[UIView animateWithDuration:0.5 animations:^{
					self.checkMarkIconLabel.transform = CGAffineTransformTranslate(self.checkMarkIconLabel.transform, 0, 80);
					self.repeatOnceOn = YES;
					[defaultManager setBool:YES forKey:@"REPEATON"];
					[defaultManager synchronize];
				}];
			}
			break;
		}
		default:
			break;
	}
	
	
}

- (void)dismissToTimerMenu{
	NSLog(@"dismissing");
	[self.navigationController popToRootViewControllerAnimated:NO];
}

@end
