//
//  MainCollectionViewController.m
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "MainCollectionViewController.h"

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 10; i++) {
            [images addObject:[UIImage imageNamed:@"1.jpg"]];
            [images addObject:[UIImage imageNamed:@"2.jpg"]];
        }
        self.images = [images copy];
        
    }
    return self;
}

-(void)loadImage(NSMutableArray *)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    for (UIView *subView in [cell subviews]) {
        [subView removeFromSuperview];
    }
    
    // Configure the cell...
    UIImage *image =[self.images objectAtIndex:indexPath.row];
    CGSize newSize = CGSizeMake(100.0f, 100.0f);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *view = [[UIImageView alloc] initWithImage:newImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    //UIImageView *temp = [self.imageViews objectAtIndex:indexPath.row];
    //[cell setFrame:CGRectMake(0, 0, 95, 95)];
    [cell addSubview:view];
    
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

/*
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *tempurl = [NSURL URLWithString:[self.urls objectAtIndex:indexPath.row]];
    NSData *tempdata = [NSData dataWithContentsOfURL:tempurl];
    UIImage *tempimage = [UIImage imageWithData:tempdata];
    
    [self.navigationController pushViewController:self.filterView animated:YES];
    [self.filterView setup:tempimage andCreateView:self.createView];
    //self.filterView.createView = self.createView;
}
*/

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 140, 320, 470) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    
    [self.view addSubview:self.collectionView];
    
    
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    NSDictionary * dict;
    [self.weatherView setUpWithWeatherInfo:dict];
    self.weatherView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.0];
    
    [self.view addSubview:self.weatherView];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end