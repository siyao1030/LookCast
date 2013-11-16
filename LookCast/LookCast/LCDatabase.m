//
//  LCDatabase.m
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "LCDatabase.h"
#import <sqlite3.h>

@implementation LCDatabase
static sqlite3 *db;

static sqlite3_stmt *createLCItems;
static sqlite3_stmt *fetchLCItems;
static sqlite3_stmt *insertLCItem;
static sqlite3_stmt *deleteLCItem;
static NSString *databaseName = @"LCdatabase.sql";

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // look for an existing Items database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:databaseName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty Items database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    // create the statement strings
    const char *createLCItemsString = "CREATE TABLE IF NOT EXISTS lcitems (rowid INTEGER PRIMARY KEY AUTOINCREMENT, url BLOB, location BLOB, date BLOB, high TEXT, low TEXT, rain INT)";
    const char *fetchLCItemsString = "SELECT * FROM lcitems";
    const char *insertLCItemString = "INSERT INTO lcitems (url, location, date, high, low, rain) VALUES (?, ?, ?, ?, ?, ?)";
    const char *deleteLCItemString = "DELETE FROM lcitems WHERE rowid=?";
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:databaseName];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createLCItemsString, -1, &createLCItems, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare lcitems create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createLCItems);
    sqlite3_reset(createLCItems);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create lcitems table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchLCItemsString, -1, &fetchLCItems, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare lcitem fetching statement");
    }
    
    //init insertion statement
    int insertResult = sqlite3_prepare_v2(db, insertLCItemString, -1, &insertLCItem, NULL);
    if (insertResult != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare lcitem inserting statement because error code %d : %s", insertResult, sqlite3_errmsg(db));
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteLCItemString, -1, &deleteLCItem, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare lcitem deleting statement");
    }
}

+ (NSMutableArray *)fetchAllLCItems
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    
    
    while (sqlite3_step(fetchLCItems) == SQLITE_ROW) {
        
        // query columns from fetch statement
        const void *urlPtr = sqlite3_column_blob(fetchLCItems, 1);
        int urlSize = sqlite3_column_bytes(fetchLCItems, 1);
        NSData *tempUrl = [[NSData alloc] initWithBytes:urlPtr length:urlSize];

        const void *locationPtr = sqlite3_column_blob(fetchLCItems, 2);
        int locationSize = sqlite3_column_bytes(fetchLCItems, 2);
        NSData *tempLocation = [[NSData alloc] initWithBytes:locationPtr length:locationSize];
  
        const void *datePtr = sqlite3_column_blob(fetchLCItems, 3);
        int dateSize = sqlite3_column_bytes(fetchLCItems, 3);
        NSData *tempDate = [[NSData alloc] initWithBytes:datePtr length:dateSize];

        char *highChars = (char *) sqlite3_column_text(fetchLCItems, 4);
        NSString *tempHigh = [NSString stringWithUTF8String:highChars];
        
        char *lowChars = (char *) sqlite3_column_text(fetchLCItems, 5);
        NSString *tempLow = [NSString stringWithUTF8String:lowChars];
        
        int rainInt = (int) sqlite3_column_int(fetchLCItems, 6);
        NSNumber *tempRain = [NSNumber numberWithInt:rainInt];
        
        //create datadictionary object, notice the query for the row id
        NSDictionary *tempDictionary = @{ @"url" : tempUrl , @"location" : tempLocation, @"date" : tempDate, @"high" : tempHigh, @"low" : tempLow, @"rain" : tempRain, @"id" : [NSNumber numberWithInt:(sqlite3_column_int(fetchLCItems, 0))]};

   //     LCItem *temp = [[LCItem alloc] initWithImage:tempImage andTitle:tempTitle andOwner:tempOwner andId:sqlite3_column_int(fetchLCItems, 0)];
        [ret addObject:tempDictionary];
        
    }
    
    sqlite3_reset(fetchLCItems);
    return ret;
}

+ (void)saveLCItemWithData:(NSDictionary *)dataDictionary
{
 
    NSData *urlData = [dataDictionary objectForKey:@"url"];
    NSData *locationData = [dataDictionary objectForKey:@"location"];
    NSData *dateData = [dataDictionary objectForKey:@"date"];
    NSString *high = [dataDictionary objectForKey:@"high"];
    NSString *low = [dataDictionary objectForKey:@"low"];
    NSNumber *rain = [dataDictionary objectForKey:@"rain"];
//    
//    NSLog(@"high %@ low %@ rain %@", high, low, rain);
//
//    NSLog(@"url  %@", urlData);
//    NSLog(@"location %@", locationData);
//    NSLog(@"date %@", dateData);
//
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:databaseName];

    sqlite3_open([path UTF8String], &db);
    // bind data to the statement
    sqlite3_bind_blob(insertLCItem, 1, [urlData bytes], [urlData length], SQLITE_TRANSIENT);
    sqlite3_bind_blob(insertLCItem, 2, [locationData bytes], [locationData length], SQLITE_TRANSIENT);
    sqlite3_bind_blob(insertLCItem, 3, [dateData bytes], [dateData length], SQLITE_TRANSIENT);

    sqlite3_bind_text(insertLCItem, 4, [high UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertLCItem, 5, [low UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(insertLCItem, 6, (int)[rain integerValue]);
    
    int success = sqlite3_step(insertLCItem);
    sqlite3_reset(insertLCItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert lcitem with error code %d : %s", success, sqlite3_errmsg(db));
    }
}

+ (void)deleteLCItem:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteLCItem, 1, rowid);
    int success = sqlite3_step(deleteLCItem);
    sqlite3_reset(deleteLCItem);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete lcitem");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchLCItems);
    sqlite3_finalize(insertLCItem);
    sqlite3_finalize(deleteLCItem);
    sqlite3_finalize(createLCItems);
    sqlite3_close(db);
}

@end
