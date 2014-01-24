//
//  SettingsViewController.m
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "setTimerCell.h"
#import "setEndTimerCell.h"
#import "startTimerTitleCell.h"
#import "endTimerTitleCell.h"
#import "RepeatSettingViewController.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
	self.settingsTableView.backgroundView = nil;
	self.settingsTableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(showRepeatMenu:)
												 name:@"presentRepeatMenu"
											   object:nil];
}

- (void)showRepeatMenu:(NSNotification *)notification{
	[self presentRepeatSettings];
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
    switch (indexPath.row) {
		case 0:
			return IS_IPHONE_5 ? 80 :90;
			break;
		case 1:
			return IS_IPHONE_5 ? 130 : 140;
			break;
		case 2:
			return IS_IPHONE_5 ? 20 : 30;
			break;
		case 3:
			return IS_IPHONE_5 ? 130 :140;
			break;
		default:
			break;
	}
	return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
			startTimerTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"startTimerTitleCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"startTimerTitleCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (startTimerTitleCell*)view;
					}
				}
			}
			returnCell = cell;
		}
			break;
		case 1:
		{
			setTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setStartTimerCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"setTimerCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (setTimerCell*)view;
					}
				}
			}
			[((setTimerCell*)cell) setupTimer];
			returnCell = cell;
		}
			break;
		case 2:
		{
			endTimerTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"endTimerTitleCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"endTimerTitleCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (endTimerTitleCell*)view;
					}
				}
			}
			returnCell = cell;
		}
			break;
		case 3:
		{
			setEndTimerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setEndTimerCell"];
			if (cell == nil) {
				NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"setEndTimerCell" owner:nil options:nil];
				
				for (UIView *view in views) {
					if([view isKindOfClass:[UITableViewCell class]])
					{
						cell = (setEndTimerCell*)view;
					}
				}
			}
			[((setEndTimerCell*)cell) setupTimer];
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
	
}

- (void)presentRepeatSettings{
	UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"iPhone"
												  bundle:nil];
	UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"RepeatSettingViewController"];
	[self.navigationController pushViewController:vc animated:NO];
}

@end
