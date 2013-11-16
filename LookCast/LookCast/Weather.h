//
//  Weather.h
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotoItem.h"
#import "PhotoParserViewController.h"

@interface Weather : NSObject <CLLocationManagerDelegate>
    @property float latitude;
    @property float longitude;

+ (NSMutableDictionary *)weatherForLocation:(CLLocation *)location date:(NSDate *)date;
+ (NSDictionary *)updateWeatherData;
+ (NSMutableArray *)addWeatherDataToPhotoItems;
@end
