//
//  Weather.h
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Weather : NSObject
+ (void) currentWeather;
+ (void) weatherAtLatitude:(float)latitude longitude:(float)longitude;
@end
