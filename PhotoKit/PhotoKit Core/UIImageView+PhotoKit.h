//
//  UIImageView+PhotoKit.h
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 8/4/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PKPhotoStore.h"

#import "FLAnimatedImageView.h"

@interface UIImageView (PhotoKit)

- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate;
- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate withProgressBlock:(PKFetchProgressUpdate)update;
- (void)setPhotoForURL:(NSURL *)url shouldAnimateIfNotInCacheWithProgressBlock:(PKFetchProgressUpdate)update shouldSetPhotoOnCompletion:(BOOL)shouldSet onCompletion:(PKFetchCompletion)completion;
- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate withProgressBlock:(PKFetchProgressUpdate)update shouldSetPhotoOnCompletion:(BOOL)shouldSet onCompletion:(PKFetchCompletion)completion;

- (void)setPostCompletionImage:(NSObject *)image isGIF:(BOOL)isGIF shouldAnimate:(BOOL)shouldAnimate;

- (BOOL)hasImage;

@end
