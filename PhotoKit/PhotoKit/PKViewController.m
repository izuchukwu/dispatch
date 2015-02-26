//
//  PKViewController.m
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 8/10/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import "PKViewController.h"

#define __weakSelf __weak typeof(self)

@implementation PKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // Cache Test
    //
    
    NSURL *url1;
    NSURL *url2;
    
#if CacheTest
    
    NSURL *url3;
    
    url1 = [NSURL URLWithString:@"http://i.imgur.com/Y8w5vzN.gif"]; // 4.5 MB
    url2 = [NSURL URLWithString:@"http://i.imgur.com/ULjOtjz.gif"]; // 1.8 MB, 6.3 MB in Cache
    url3 = [NSURL URLWithString:@"http://i.imgur.com/SgJL6s1.gif"]; // 7.6 MB, 13.9 MB in Cache to trigger clean
    
    [PKPhotoStore setStoreSizeCapacityInBytes:10000000]; // 10 MB max
    [PKPhotoStore setStoreLoggingLevel:PKStoreLoggingLevelAllYouGot];
    
    [PKPhotoStore getPhotoForURL:url1 withPriority:PKFetchPrioritySnappy completion:^(NSObject *image, BOOL isGIF) {
        NSLog(@"done 1");
        if (isGIF) {
            [_imageView1 setAnimatedImage:(FLAnimatedImage *)image];
        } else {
            [_imageView1 setImage:(UIImage *)image];
        }
        
        [PKPhotoStore getPhotoForURL:url2 withPriority:PKFetchPrioritySnappy completion:^(NSObject *image, BOOL isGIF) {
            NSLog(@"done 2");
            if (isGIF) {
                [_imageView2 setAnimatedImage:(FLAnimatedImage *)image];
            } else {
                [_imageView2 setImage:(UIImage *)image];
            }
            
            [PKPhotoStore getPhotoForURL:url3 withPriority:PKFetchPrioritySnappy completion:^(NSObject *image, BOOL isGIF) {
                NSLog(@"done 3");
                if (isGIF) {
                    [_imageView1 setAnimatedImage:(FLAnimatedImage *)image];
                } else {
                    [_imageView1 setImage:(UIImage *)image];
                }
            } progressUpdate:^(double progress) {
                [_imageView1 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0-progress]];
            }];
        } progressUpdate:^(double progress) {
            [_imageView2 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0-progress]];
        }];
        
    } progressUpdate:^(double progress) {
        [_imageView1 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0-progress]];
    }];
    
    return;
    
#endif
    
    //
    // ImageView, Progress, Quality, Completion, & Priority Test
    //
    
#if GIFtest
    url1 = [NSURL URLWithString:@"http://i.imgur.com/SgJL6s1.gif"];
    url2 = [NSURL URLWithString:@"http://i.imgur.com/efLzzql.jpg"];
#else
    url1 = [NSURL URLWithString:@"http://i.imgur.com/o9YljxY.jpg"];
    url2 = [NSURL URLWithString:@"http://i.imgur.com/ftd1YIk.png"];
#endif
    
    [_imageView1 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
    [_imageView2 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0]];
	
    // 1: PKPhotoStore
    
    [PKPhotoStore getPhotoForURL:url1 withPriority:PKFetchPrioritySnappy completion:^(NSObject *image, BOOL isGIF) {
        NSLog(@"done store");
        if (isGIF) {
            [_imageView1 setAnimatedImage:(FLAnimatedImage *)image];
        } else {
            [_imageView1 setImage:(UIImage *)image];
        }
    } progressUpdate:^(double progress) {
        [_imageView1 setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0-progress]];
    }];
    
    // 2: FLAnimatedImageView+PhotoKit
    
    __weakSelf weakSelf;
    
    [_imageView2 setPhotoForURL:url2 shouldAnimate:YES withProgressBlock:^(double progress) {
        [[weakSelf imageView2] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:1.0-progress]];
    }];
    //[_imageView2 unprioritizeForURL:url2];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end