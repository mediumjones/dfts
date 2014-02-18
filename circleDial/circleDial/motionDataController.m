//
//  motionDataController.m
//  circleDial
//
//  Created by raymond chen on 2014-02-13.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import "motionDataController.h"
#import <CoreMotion/CoreMotion.h>
#import "NSMutableArray+QueueAdditions.h"

@interface motionDataController()

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSMutableArray *currentAccelerationWindow;
@property (nonatomic, assign) CMAcceleration lastAcceleration;

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
		_motionManager.accelerometerUpdateInterval = 2;
		_motionManager.gyroUpdateInterval = 2;
		_lastAcceleration.x = 0.0f;
		_lastAcceleration.y = 0.0f;
		_lastAcceleration.z = 0.0f;
		_currentAccelerationWindow = [NSMutableArray new];
//		_currentAccelerationWindow = [[NSMutableArray alloc]initWithArray:@[[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																			[NSNumber numberWithBool:NO],
//																		   ]];
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
	if (self.lastAcceleration.x == 0.0f &&
		self.lastAcceleration.y == 0.0f &&
		self.lastAcceleration.z == 0.0f){
			self.lastAcceleration = acceleration;
	}
//	
//	NSLog(@"Getting acceleration data");
//	NSLog(@"x %f", acceleration.x);
//	NSLog(@"y %f", acceleration.y);
//	NSLog(@"z %f", acceleration.z);
//	
//	NSLog(@"x %f", self.lastAcceleration.x);
//	NSLog(@"y %f", self.lastAcceleration.y);
//	NSLog(@"z %f", self.lastAcceleration.z);
	
	if (fabs(self.lastAcceleration.x - acceleration.x) > 0.2 ||
		fabs(self.lastAcceleration.y - acceleration.y) > 0.2 ||
		fabs(self.lastAcceleration.z - acceleration.z) > 0.2){
		//NSLog(@"X/Y/Z moved");
		NSNumber *yesNum = [NSNumber numberWithBool:YES];
		if (self.currentAccelerationWindow.count == 30){
			[self.currentAccelerationWindow dequeue];
		}
		[self.currentAccelerationWindow enqueue:yesNum];
	}else{
		//NSLog(@"X/Y/Z not oved");
		NSNumber *noNum = [NSNumber numberWithBool:NO];
		if (self.currentAccelerationWindow.count == 30){
			[self.currentAccelerationWindow dequeue];
		}
		[self.currentAccelerationWindow enqueue:noNum];
	}
	
	self.lastAcceleration = acceleration;

	if ([self hasUserMoveInLastMin]){
		
		[[NSNotificationCenter defaultCenter]postNotificationName:@"userMoved" object:nil];
	}else{
		
	}
}

- (BOOL)hasUserMoveInLastMin{
	int numOfActiveStatus = 0;
	for (NSNumber *currentNumber in self.currentAccelerationWindow){
		if ([currentNumber boolValue]){
			numOfActiveStatus ++;
		}
		if (numOfActiveStatus > 10){
			return YES;
		}
	}
	return NO;
}

@end
