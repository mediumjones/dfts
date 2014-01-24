//
//  RepeatSettingViewController.h
//  circleDial
//
//  Created by raymond chen on 2013-10-07.
//  Copyright (c) 2013 EvidencePix Systems Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepeatSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *checkMarkIconLabel;
@property (strong, nonatomic) IBOutlet UITableView *repeatTableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *VTopSpaceCheckTable;
@end
