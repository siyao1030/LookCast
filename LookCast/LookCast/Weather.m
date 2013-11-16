//
//  Weather.m
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Weather.h"

@implementation Weather

// Current Weather in current location
+ (void) currentWeather
{
    //NSString *zipCode = @"91711";
    NSString *requestURL = @"http://api.wunderground.com/api/b02d00370341149d/conditions/q/CA/San_Francisco.json";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    
    NSString *temp_f = result[@"current_observation"][@"temp_f"];
    NSString *relative_humidity = result[@"current_observation"][@"relative_humidity"];
    //Precipitation in inches
    NSString *precipitation = result[@"current_observation"][@"precip_today_in"];
    //Icon name, somethinglike partlycloudy
    NSString *icon = result[@"current_observation"][@"icon"];
    
    return;
}

+ (void) weatherAtLatitude:(float)latitude longitude:(float)longitude
{

    
    //
    NSString *requestURLString = @"http://api.wunderground.com/api/b02d00370341149d/conditions/q/34.1223,-117.7143.json";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    NSError *error;
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *current_observation = result[@"current_observation"];
    NSString *city = current_observation[@"display_location"][@"city"];
    NSString *state = current_observation[@"display_location"][@"state"];
    NSString *temp_f = current_observation[@"temp_f"];
    NSString *precip_today_in = current_observation[@"precip_today_in"];
    
    //
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    
//    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
//    {
//        if ([data length] > 0 && error == nil)
//            [delegate receivedData:data];
//        else if ([data length] == 0 && error == nil)
//            [delegate emptyReply];
//        else if (error != nil && error.code == ERROR_CODE_TIMEOUT)
//            [delegate timedOut];
//        else if (error != nil)
//            [delegate downloadError:error];
//    }];
}

@end
