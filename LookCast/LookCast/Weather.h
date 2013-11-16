//
//  Weather.h
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Weather : NSObject <CLLocationManagerDelegate>
    @property float latitude;
    @property float longitude;

- (NSMutableDictionary *) currentWeather;
- (NSMutableDictionary *) weatherAtLatitude:(float)latitude longitude:(float)longitude;
+ (void)updateWeatherData;

@end
