//
//  MainViewController.h
//  LookCast
//
//  Created by Siyao Clara Xie on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"

@interface MainViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout>

@property WeatherView * weatherView;


@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *itemSizes;

-(void)setup;

@end
