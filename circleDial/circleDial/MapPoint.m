//
//  MapPoint.m
//  GooglePlaces
//
//  Created by van Lint Jason on 6/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPoint.h"

@implementation MapPoint
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize userCoordinate = _userCoordinate;



- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate userCoordinate:(CLLocationCoordinate2D)userCoordinate
{
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _coordinate = coordinate;
		_userCoordinate = userCoordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationDistance)returnDistanceFromMapPoint{
	CLLocation *currentLocation = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude
															longitude:self.coordinate.longitude];
	CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:self.userCoordinate.latitude
														 longitude:self.userCoordinate.longitude];
	return [userLocation distanceFromLocation:currentLocation];
}

@end
