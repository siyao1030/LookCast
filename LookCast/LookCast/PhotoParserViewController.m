//
//  PhotoParserViewController.m
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "PhotoParserViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreImage/CoreImage.h>

@interface PhotoParserViewController ()

@end

@implementation PhotoParserViewController

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
    self.photosMetadata = [[NSDictionary alloc] init];
    [self getPhotos];
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(50,50,200,200)]; //
    [self.view addSubview:self.photoView]; //

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getPhotos {
    self.library = [[ALAssetsLibrary alloc] init];
    
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                        if (result)
                                        {
                                            if ([self isValidPhoto:result]) {
                                                CLLocation *photoLocation = [result valueForProperty:ALAssetPropertyLocation];
                                                NSDate *photoDate = [result valueForProperty:ALAssetPropertyDate];
                                                
                                                NSURL *photoURL = [result valueForProperty:ALAssetPropertyAssetURL];

                                                NSDictionary *photoMetadata = [NSDictionary dictionaryWithObjectsAndKeys:@"location", photoLocation, @"data", photoDate, nil];
                                                
                                                
                                                NSLog(@"taken at location %@", photoLocation);
                                                NSLog(@"taken on date %@", photoDate);
                                                NSLog(@"at url %@", photoURL);
                                            }
                                        }
                                    }
                                     ];
                                } failureBlock:^(NSError *error) {
                                    NSLog(@"Error: %@", error);
                                }
     ];
    
}

-(BOOL) isValidPhoto:(ALAsset *)photo {
    if ([self isJPEG:photo] && [self hasFaces:photo]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL) hasFaces:(ALAsset *)photo {
    ALAssetRepresentation *assetRepresentation = [photo defaultRepresentation];
    CGImageRef cgImageRef = [assetRepresentation fullResolutionImage];
    CIImage *ciImage = [CIImage imageWithCGImage:cgImageRef];
    
    int exifOrientation;
    ALAssetOrientation orientation = [[photo defaultRepresentation] orientation];
    
    switch (orientation) {
        case UIImageOrientationUp:
            exifOrientation = 1;
            break;
        case UIImageOrientationDown:
            exifOrientation = 3;
            break;
        case UIImageOrientationLeft:
            exifOrientation = 8;
            break;
        case UIImageOrientationRight:
            exifOrientation = 6;
            break;
        case UIImageOrientationUpMirrored:
            exifOrientation = 2;
            break;
        case UIImageOrientationDownMirrored:
            exifOrientation = 4;
            break;
        case UIImageOrientationLeftMirrored:
            exifOrientation = 5;
            break;
        case UIImageOrientationRightMirrored:
            exifOrientation = 7;
            break;
        default:
            break;
    }

    
    NSDictionary* detectorOptions = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };
  
    NSDictionary* featureOptions = @{ CIDetectorImageOrientation : [NSNumber numberWithInt:exifOrientation] };

    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    NSArray *features = [detector featuresInImage:ciImage options:featureOptions];
    
    NSString *photoName = [photo valueForProperty:ALAssetPropertyAssetURL];
    
   // NSLog(@"photo %@ has %lu features", photoName, (unsigned long)[features count]);
    
    if([features count] > 0){
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL) isJPEG:(ALAsset *)photo {
    NSArray *photoTypes = [photo valueForProperty:ALAssetPropertyRepresentations];
    if ([photoTypes containsObject:@"public.jpeg"]) {
        return YES;
    }
    else {
        return NO;
    }
}



@end
