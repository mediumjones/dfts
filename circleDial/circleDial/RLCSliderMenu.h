//
//  RLCSliderMenu.h
//  PageSliderDemo
//
//  Created by raymond chen on 2012-12-10.
//  Copyright (c) 2012 raymond chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RLCSliderMenu;

@protocol RLCSliderMenuDelegate
@optional

-(void)sliderMenu:(RLCSliderMenu*)sliderMenu didSelectCell:(UITableViewCell*)selectedCell;

@end

@interface RLCSliderMenu : UIView <UITableViewDataSource, UITableViewDelegate>

typedef enum SliderMenuState {
	SLIDERMENUSTATE_TIMERMENUON,
	SLIDERMENUSTATE_REPEATMENUON,
	SLIDERMENUSTATE_OFF,
}SliderMenuState;

typedef enum SliderMenuType {
	SLIDERMENUTYPE_PHOTO,
	SLIDERMENUTYPE_VIDEO,
	SLIDERMENUTYPE_AUDIO,
	SLIDERMENUTYPE_DOCUMENT,
	SLIDERMENUTYPE_FORM,
	SLIDERMENUTYPE_SESSION_ON,
	SLIDERMENUTYPE_SESSION_OFF,
	SLIDERMENUTYPE_FINISH,
	SLIDERMENUTYPE_CANCEL,
	SLIDERMENUTYPE_MEDIA,
	SLIDERMENUTYPE_SETTING,
	SLIDERMENUTYPE_LOCATION,
}SliderMenuType;

@property (nonatomic, weak) id<RLCSliderMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *ImageArray;
@property (nonatomic, assign) SliderMenuState menuState;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSIndexPath *selectedCell;
@property (nonatomic, assign) UIDeviceOrientation orientation;
@property (nonatomic, assign) BOOL isformSessionInProgress;
@property (nonatomic, assign) BOOL isSessionInProgress;

+ (RLCSliderMenu *)sharedSliderMenu; //Singleton method
- (void)addMenuViewToMainView:(UIView*)mainView withSlidingView:(UIView*)slideView;
- (void)setUpPanGestureForViews:(NSArray*)arrayViews;
- (void)setupHLeadingSpace:(NSLayoutConstraint*)horizontalSpacing;

// Handle the sliding action for this sliderMenu
- (void)slideIn;
- (void)slideOutTimerMenu;
- (void)slideOutRepeatMenu;
//- (void)startDrag;

@end
