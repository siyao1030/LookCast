//
//  PhotoItem.h
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PhotoItem : NSObject

@property NSURL *url;
@property CLLocation *location;
@property NSDate *date;
@property NSString *high;
@property NSString *low;
@property NSInteger *rain;

-(id)initWithUrl:(NSURL *)url andLocation:(CLLocation *)location andDate:(NSDate *)date;
-(void)setHigh:(NSString *)high andLow:(NSString *)low andRain:(NSInteger *)rain;

@end
