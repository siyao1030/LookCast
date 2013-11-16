//
//  LCDatabase.h
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface LCDatabase : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (NSMutableArray *)fetchAllLCItems;
+ (void)saveLCItemWithData:(NSDictionary *)dataDictionary;
+ (void)deleteLCItem:(int)rowid;
+ (void)cleanUpDatabaseForQuit;

@end
