//
//  TestWeatherViewController.m
//  LookCast
//
//  Created by Jason Yu on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "TestWeatherViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TestWeatherViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lat;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property CLLocationManager *locationManager;

@end

@implementation TestWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Weather *weather = [[Weather alloc] init];
//    self.lat.text = [NSString stringWithFormat:@"%1.4f", weather.latitude];

//    self.longitude.text = self.long.text + weather.longitude;
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager startUpdatingLocation];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateLocation:(id)sender {
}

//- (void)locationManager:(CLLocationManager *)manager          didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = locations[0];
//    float lat = location.coordinate.latitude;
//    self.lat.text = [NSString stringWithFormat:@"%1.4f", lat];
//}

@end
