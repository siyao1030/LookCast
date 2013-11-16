//
//  PhotoParserViewController.h
//  LookCast
//
//  Created by Sumaiya Hashmi on 11/15/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoItem.h"

@interface PhotoParserViewController : UIViewController

@property ALAssetsLibrary *library;
@property NSMutableArray *photoItems;
-(void) getPhotos;
@end
