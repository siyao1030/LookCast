//
//  PhotoParserViewController.m
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "PhotoParserViewController.h"
#import <CoreLocation/CoreLocation.h>

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
    NSArray *photoTypes = [photo valueForProperty:ALAssetPropertyRepresentations];
    if ([photoTypes containsObject:@"public.jpeg"]) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
