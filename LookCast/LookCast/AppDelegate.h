//
//  AppDelegate.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoParserViewController.h" //

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
