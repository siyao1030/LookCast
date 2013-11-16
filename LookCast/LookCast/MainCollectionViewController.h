//
//  MainCollectionViewController.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"
#import "Weather.h"

@interface MainCollectionViewController : UIViewController

@property NSMutableArray *images;
@property NSMutableArray *imageURLs;
@property UICollectionView *collectionView;

@property WeatherView *weatherView;
@property Weather *weather;

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@end

