//
//  PKViewController.h
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 8/10/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PhotoKit.h"

#define CacheTest 1

#define GIFtest 0

@interface PKViewController : UIViewController

@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView1;
@property (strong, nonatomic) IBOutlet FLAnimatedImageView *imageView2;

@end