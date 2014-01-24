//
//  NSString+SSGizmo.m
//  circleDial
//
//  Created by raymond chen on 2013-08-09.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "NSString+SSGizmo.h"

@implementation NSString (SSGizmo)

+ (NSString*) convertUnicode:(NSString*)unicode{
	unsigned intVal;
	NSScanner *scanner = [NSScanner scannerWithString:unicode];
	[scanner scanHexInt:&intVal];
	
	NSString *str = nil;
	if (intVal > 0xFFFF) {
		unsigned remainder = intVal - 0x10000;
		unsigned topTenBits = (remainder >> 10) & 0x3FF;
		unsigned botTenBits = (remainder >>  0) & 0x3FF;
		
		unichar hi = topTenBits + 0xD800;
		unichar lo = botTenBits + 0xDC00;
		unichar unicodeChars[2] = {hi, lo};
		str = [NSString stringWithCharacters:unicodeChars length:2];
	} else {
		unichar lo = (unichar)(intVal & 0xFFFF);
		str = [NSString stringWithCharacters:&lo length:1];
	}

	return str;
}
@end
