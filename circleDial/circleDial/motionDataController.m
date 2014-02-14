//
//  motionDataController.m
//  circleDial
//
//  Created by raymond chen on 2014-02-13.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import "motionDataController.h"
#import <CoreMotion/CoreMotion.h>

@interface motionDataController()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation motionDataController

+ (motionDataController*)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (motionDataController*)init{
	if (self = [super init]){
		_motionManager = [[CMMotionManager alloc] init];
		_motionManager.accelerometerUpdateInterval = .2;
		_motionManager.gyroUpdateInterval = .2;
	}
	
	return self;
}

- (void)startMotionSensing{
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

@end
