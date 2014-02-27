//
//  testAppDelegate.m
//  circleDial
//
//  Created by raymond chen on 2013-07-11.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "testAppDelegate.h"
#import <Parse/Parse.h>

@implementation testAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	//	Setup for parse
	[Parse setApplicationId:@"hGzlolkoJuxH63VB3yG6lWB6V3NWIDit44GknpPM"
				  clientKey:@"BATHQmHF1NFpU5NSckBVxCagjTrSJ4SoPOZ45kLK"];
	
    // Override point for customization after application launch.
	[application registerForRemoteNotificationTypes:
	 UIRemoteNotificationTypeBadge |
	 UIRemoteNotificationTypeAlert |
	 UIRemoteNotificationTypeSound];
	
	
	
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
	self.tokenDevice = [[[newDeviceToken description]
						 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
						stringByReplacingOccurrencesOfString:@" "
						withString:@""];
	
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:newDeviceToken];
	[currentInstallation addUniqueObject:self.tokenDevice forKey:@"channels"];
    [currentInstallation saveInBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	
	[self.locationManager stopUpdatingLocation];
	
	UIApplication*    app = [UIApplication sharedApplication];
	
	self.bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
		[app endBackgroundTask:self.bgTask];
		self.bgTask = UIBackgroundTaskInvalid;
	}];
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:20
												  target:self.locationManager
												selector:@selector(startUpdatingLocation)
												userInfo:nil
												 repeats:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
	self.locationManager.distanceFilter=kCLDistanceFilterNone;
	self.locationManager.delegate = self;

	[self.locationManager startUpdatingLocation];
	[self.locationManager startUpdatingHeading];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"NEW LOCATION");
	self.currentLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	self.currentHeading = newHeading;
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
