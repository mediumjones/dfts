//
//  MapPoint.h
//  GooglePlaces
//
//  Created by van Lint Jason on 6/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation>
{
    
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
	CLLocationCoordinate2D _userCoordinate;
    
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D userCoordinate;
@property (nonatomic, assign) float *distance;


- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate userCoordinate:(CLLocationCoordinate2D)userCoordinate;
- (CLLocationDistance)returnDistanceFromMapPoint;
@end
