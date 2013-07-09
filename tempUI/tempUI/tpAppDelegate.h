//
//  tpAppDelegate.h
//  tempUI
//
//  Created by raymond chen on 2013-07-08.
//  Copyright (c) 2013 temp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tpAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
