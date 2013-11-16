//
//  MainCollectionViewController.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/16/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"

@interface MainCollectionViewController : UIViewController

@property NSMutableArray *images;
@property UICollectionView *collectionView;

@property WeatherView *weatherView;
@end
