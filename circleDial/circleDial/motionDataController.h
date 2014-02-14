//
//  motionDataController.h
//  circleDial
//
//  Created by raymond chen on 2014-02-13.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface motionDataController : NSObject

+ (motionDataController*)sharedInstance;
- (void)startMotionSensing;

@end
