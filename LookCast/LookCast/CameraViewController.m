//
//  CameraViewController.m
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "CameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoItem.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.camera = [[UIImagePickerController alloc] init];
    self.camera.delegate = self;
    
    [self.camera.tabBarItem setTitle:@"Camera"];
    
    UIButton *takePhoto = [UIButton buttonWithType:UIButtonTypeSystem];
    [takePhoto addTarget:self.camera action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [takePhoto setTitle:@"Take PHOTO" forState:UIControlStateNormal];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.camera  setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.camera setCameraDevice:UIImagePickerControllerCameraDeviceRear];
        [self.camera setShowsCameraControls:NO];
        [self.camera setCameraOverlayView:takePhoto];
    }
   
    [takePhoto setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.tabBarController.tabBar.frame.size.height - 60, 320, 60)];
    
   }



- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    //... some stuff ...
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:((UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]).CGImage
                                 metadata:[info objectForKey:UIImagePickerControllerMediaMetadata]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              NSLog(@"assetURL %@", assetURL);
                          }];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    CLLocation *location = [[CLLocation alloc] init];
    PhotoItem *temp = [[PhotoItem alloc] initWithUrl:assetURL andLocation:location andDate:date];
    
}

@end
