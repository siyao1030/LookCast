//
//  Weather.m
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Weather.h"

@implementation Weather {
    CLLocationManager *locationManager;
}

- (id) init
{
    return self;
}

+ (NSMutableDictionary *)weatherForLocation:(CLLocation *)location date:(NSDate *)date
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    NSString *urlString = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/history_20060405/q/%3.4f,%3.4f.json", latitude, longitude];
    
    DLog(@"%@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSError *error;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableDictionary *weather = [NSMutableDictionary dictionary];
    NSMutableDictionary *summary = result[@"history"][@"dailysummary"][0];
    weather[@"mintempi"] = summary[@"mintempi"];
    weather[@"maxtempi"] = summary[@"maxtempi"];
    weather[@"rain"] = [NSNumber numberWithInt: [summary[@"rain"] integerValue]];
    return weather;
}

// Current Weather in current location
+ (NSMutableDictionary *)weatherForLocation:(CLLocation *)location
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    NSString *requestURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/conditions/q/%3.4f,%3.4f.json", latitude, longitude];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    
    NSString *temp_f = result[@"current_observation"][@"temp_f"];
    //Precipitation in inches
    NSString *precipitation = result[@"current_observation"][@"precip_today_in"];
    //Icon name, somethinglike partlycloudy
    NSString *icon = result[@"current_observation"][@"icon"];
    
    NSMutableDictionary *weather = [NSMutableDictionary dictionary];
    weather[@"temp_f"] = temp_f;
    if (precipitation > 0) {
        weather[@"precipitation"] = [NSNumber numberWithInt: 1];
    } else {
        weather[@"precipitation"] = [NSNumber numberWithInt: 0];
    }
    weather[@"icon"] = icon;
    
    NSString *requestForecastURL = [NSString stringWithFormat:@"http://api.wunderground.com/api/b02d00370341149d/forecast/q/%3.4f,%3.4f.json", latitude, longitude];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestForecastURL]];
    response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
    result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSString *high = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"high"][@"fahrenheit"];
    NSString *low = result[@"forecast"][@"simpleforecast"][@"forecastday"][0][@"low"][@"fahrenheit"];
    weather[@"high"] = high;
    weather[@"low"] = low;
    
    return weather;
}

+ (NSDictionary *)updateWeatherData
{
    //Claremont
    float temp_lat = 34.1223;
    float temp_long = -117.7143;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:temp_lat longitude:temp_long];
    NSDictionary *weather = [self weatherForLocation:location];
    
    return weather;
}

+ (NSMutableArray *)addWeatherDataToPhotoItems
{
    PhotoParserViewController *vc = [[PhotoParserViewController alloc] init];
    NSMutableArray *photos = [vc getPhotos];
    return photos;
}
@end
