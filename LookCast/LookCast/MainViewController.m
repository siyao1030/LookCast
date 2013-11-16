//
//  MainViewController.m
//  LookCast
//
//  Created by Siyao Clara Xie on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "MainViewController.h"
#import "NHBalancedFlowLayout.h"
#import "ImageCell.h"
#import "UIImage+Decompression.h"
#import "NHLinearPartition.h"

@interface MainViewController () <NHBalancedFlowLayoutDelegate>


@end

@implementation MainViewController

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 24; i++) {
            [images addObject:[UIImage imageNamed:@"1.jpg"]];
            [images addObject:[UIImage imageNamed:@"2.jpg"]];
        }
        _images = [images copy];
  
    }
    return self;
}
*/

- (void)setup
{
    //self = [super initWithCoder:aDecoder];
    if (self) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 24; i++) {
            [images addObject:[UIImage imageNamed:@"1.jpg"]];
            [images addObject:[UIImage imageNamed:@"2.jpg"]];
        }
        _images = [images copy];
    }

}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.images objectAtIndex:indexPath.item] size];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    //ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    //cell.imageView.image = nil;
    
    //UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    static NSString *identifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    
    /**
     * Decompress image on background thread before displaying it to prevent lag
     */
    NSInteger rowIndex = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage decodedImageWithImage:[self.images objectAtIndex:indexPath.item]];
        //UIImage *image = [self.images objectAtIndex:indexPath.item];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            if (currentIndexPathForCell.row == rowIndex) {
                //UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
                //[imageView setImage:image];
                //[cell addSubview:imageView];
                [cell addSubview:[[UIImageView alloc]initWithImage:image]];
                //cell.imageView.image = image;
            }
        });
    });
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    NSDictionary * dict;
    [self.weatherView setUpWithWeatherInfo:dict];
    self.weatherView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    
    //UIImageView * test = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 450, 600)];
    //[test setImage:[UIImage imageNamed:@"test.jpg"]];
    
    //[self.view addSubview:test];
    [self.view addSubview:self.weatherView];
     */
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
