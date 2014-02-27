//
//  breakSuggestionController.m
//  circleDial
//
//  Created by raymond chen on 2014-02-26.
//  Copyright (c) 2014 EvidencePix Systems Inc. All rights reserved.
//

#import "breakSuggestionController.h"
#import "testAppDelegate.h"
#import "MapPoint.h"

typedef enum suggestBreakType
{	BREAK_CAFE,
	BREAK_PARK,
	BREAK_STRETCH
} suggestBreakType;

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface breakSuggestionController()

@property (nonatomic, assign) suggestBreakType *breakType;
@property (nonatomic, assign) CLLocationCoordinate2D queryCoordinate;

@end

@implementation breakSuggestionController

+ (breakSuggestionController*)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (breakSuggestionController*)init{
	if (self = [super init]){
		_breakType = BREAK_CAFE;
	}
	return self;
}

- (void) queryGooglePlaces: (NSString *) googleType
{
	NSString *searchType = @"cafe";
	
    //	Get location from test app delegate
	testAppDelegate *appDelegate = (testAppDelegate *)[UIApplication sharedApplication].delegate;
	
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", appDelegate.currentLocation.coordinate.latitude, appDelegate.currentLocation.coordinate.longitude, @"150", searchType, @"AIzaSyDHzGCS8e-F3wPv0QBs2YEi2oWFpElIn9U"];

	self.queryCoordinate = CLLocationCoordinate2DMake(appDelegate.currentLocation.coordinate.latitude,
													  appDelegate.currentLocation.coordinate.longitude);

	
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
	[self getClosestPlace:places];
	
}

- (void)getClosestPlace:(NSArray*)placesArray{
	
	NSDictionary *closestPlace = [placesArray firstObject];
	
	NSLog(@"closest place is %@", closestPlace);

	//	Name
	NSString *mapPointName = [closestPlace objectForKey:@"name"];
	
	//Get the lat and long for the location.
	NSDictionary *loc = [[closestPlace objectForKey:@"geometry"] objectForKey:@"location"];
	
	//Create a special variable to hold this coordinate info.
	CLLocationCoordinate2D placeCoord;
	
	//Set the lat and long.
	placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
	placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
	
	//	Address
	NSString *addressString = [closestPlace objectForKey:@"vicinity"];

	
	MapPoint *closestMapPoint = [[MapPoint alloc]initWithName:mapPointName
													  address:addressString
												   coordinate:placeCoord
											   userCoordinate:self.queryCoordinate];
	
	[self.delegate updateSuggestionToMapPoint:closestMapPoint];
}

@end
