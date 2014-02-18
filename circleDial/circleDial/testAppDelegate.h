//
//  testAppDelegate.h
//  circleDial
//
//  Created by raymond chen on 2013-07-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface testAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, copy) NSString *tokenDevice;
@end
