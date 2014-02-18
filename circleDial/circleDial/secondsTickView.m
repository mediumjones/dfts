//
//  secondsTickView.m
//  circleDial
//
//  Created by raymond chen on 2013-09-08.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import "secondsTickView.h"
#import <CoreText/CoreText.h>

@interface secondsTickView()

@property (nonatomic, assign) CTFontRef numberFontRef;

@end

@implementation secondsTickView
@synthesize numberFontRef = _numberFontRef;
@synthesize backColor = _backColor;
@synthesize textColor = _textColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		//NSLog(@"Hello");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self){
		// Setup the color
		_backColor = [UIColor blackColor];
		_textColor = [UIColor blackColor];
		
		NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
		paragraphstyle.alignment = NSTextAlignmentCenter;
		
		CTFontRef fontFace = CTFontCreateWithName(CFSTR("KlinicSlab-Light"), 26.0, NULL);
		
		CTFontDescriptorRef prefontFace = CTFontCopyFontDescriptor(fontFace);
		CTFontDescriptorRef modFace = CTFontDescriptorCreateCopyWithFeature(prefontFace,
																			(__bridge CFNumberRef)[NSNumber numberWithInt:21], // Number Case
																			(__bridge CFNumberRef)[NSNumber numberWithInt:1]); // Lining Figures
		_numberFontRef = CTFontCreateWithFontDescriptor(modFace, 26.0, NULL);
		
		NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:
									   [NSString stringWithFormat:@"%02d", self.currentSeconds]
																	  attributes:@{NSFontAttributeName : (__bridge id)_numberFontRef,
												 NSForegroundColorAttributeName : [UIColor blackColor],
												  NSParagraphStyleAttributeName : paragraphstyle}];
		_secondsLabel = [[TTTAttributedLabel alloc]initWithCoder:aDecoder];
		_secondsLabel.text = attrStr;
		_secondsLabel.hidden = YES;
		[self addSubview:_secondsLabel];
	}
	return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetLineWidth(context, 1.0);
	
	CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);

	CGMutablePathRef pathRef = CGPathCreateMutable();
	CGPathMoveToPoint(pathRef, NULL, self.frame.size.width/2, 0);
	CGPathAddLineToPoint(pathRef, NULL,  self.frame.size.width, rect.size.height/2);
	CGPathAddLineToPoint(pathRef, NULL,  self.frame.size.width/2, rect.size.height);
	CGPathAddLineToPoint(pathRef, NULL, 0,  self.frame.size.height/2);
	CGPathCloseSubpath(pathRef);
	
	CGContextSetFillColorWithColor(context, self.backColor.CGColor);
	CGContextAddPath(context, pathRef);
	CGContextFillPath(context);
	
	CGContextAddPath(context, pathRef);
	CGContextStrokePath(context);
		
	CGPathRelease(pathRef);
	
}

- (CGRect)getRectForText{
	UIFont* textFont = [UIFont fontWithName:@"KlinicSlab-Light" size:26];
	CGFloat fontHeight = textFont.pointSize;
    CGFloat yOffset = (self.frame.size.height - fontHeight) / 2.0;
	
    CGRect textRect = CGRectMake(0, yOffset, self.frame.size.width, fontHeight);
	return textRect;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.secondsLabel.frame = [self getRectForText];
}

- (id)updateCurrentSeconds:(int)seconds{
	self.currentSeconds = seconds;
	NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
	paragraphstyle.alignment = NSTextAlignmentCenter;
	NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:[self getSecondsInText] attributes:@{NSFontAttributeName : (__bridge id)_numberFontRef,
											 NSForegroundColorAttributeName : [UIColor blackColor],
											  NSParagraphStyleAttributeName : paragraphstyle}];
	_secondsLabel.text = attrStr;
	[self setNeedsLayout];
	return self;
}

- (NSString*)getSecondsInText{
	NSString *formattedTime;
	formattedTime = [NSString stringWithFormat:@"%02u",self.currentSeconds];

	return formattedTime;
}

- (void)shouldDisplaySeconds{
	self.textColor = [UIColor blackColor];
	self.backColor = [UIColor whiteColor];
	self.secondsLabel.hidden = NO;
}

@end
