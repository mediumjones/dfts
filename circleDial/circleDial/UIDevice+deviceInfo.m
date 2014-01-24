//
//  UIDevice+deviceInfo.m
//  circleDial
//
//  Created by raymond chen on 2013-07-29.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "UIDevice+deviceInfo.h"

@implementation UIDevice (deviceInfo)

+ (BOOL) isDeviceAniPhone5
{
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
	{
		// Get the height of the screen
		CGSize result = [[UIScreen mainScreen] bounds].size;
		CGFloat scale = [UIScreen mainScreen].scale;
		result = CGSizeMake(result.width * scale, result.height * scale);
		
		if(result.height == 1136){
			return YES;
		}
	}
	return NO;
}
@end
