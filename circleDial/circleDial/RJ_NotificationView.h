//
//  RJ_NotificationView.h
//  ReconJet
//
//  Created by Raymond Chen on 2/6/2014.
//  Copyright (c) 2014 Recon Instruments. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJ_NotificationView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSString *notificationText;
@property (nonatomic, strong) UIImage *notificationIconImage;


- (void)showNotificationWithAutoDismiss:(void (^)(BOOL finished))completionCallback;
@end