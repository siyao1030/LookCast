//
//  PhotoItem.m
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem

-(id)initWithUrl:(NSURL *)url andLocation:(CLLocation *)location andDate:(NSDate *)date {
    self = [super init];
    self.url = url;
    self.location = location;
    self.date = date;
    
    return self;
}

-(void)setHigh:(NSString *)high andLow:(NSString *)low andRain:(NSInteger *)rain {
    self.high = high;
    self.low = low;
    self.rain = rain;
}

@end
