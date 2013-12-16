//
//  NLJAppDelegate.h
//  Auxiliares UAI
//
//  Created by Nicolas Lopez on 16-12-13.
//  Copyright (c) 2013 Nicolas Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
