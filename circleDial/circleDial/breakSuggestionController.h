//
//  breakSuggestionController.h
//  circleDial
//
//  Created by raymond chen on 2014-02-26.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPoint.h"

@protocol breakSuggestionControllerDelegate

- (void)updateSuggestionToMapPoint:(MapPoint*)suggestedMapPoint;

@end

@interface breakSuggestionController : NSObject

@property (nonatomic, weak) id <breakSuggestionControllerDelegate> delegate;

+ (breakSuggestionController*)sharedInstance;
- (void)queryGooglePlaces:(NSString *)googleType;
@end
