//
//  Weather_Tests.m
//  Weather Tests
//
//  Created by Jason Yu on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Weather.h"

@interface Weather_Tests : XCTestCase

@end

@implementation Weather_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    [Weather updateWeatherData];
}

@end
