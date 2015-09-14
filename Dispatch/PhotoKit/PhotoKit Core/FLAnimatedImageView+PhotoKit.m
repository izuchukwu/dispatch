//
//  UIImageView+PhotoKit.m
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 7/17/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import "FLAnimatedImageView+PhotoKit.h"
#import "SDImageCache.h"

#define __weakSelf __weak typeof(self)

@implementation FLAnimatedImageView (PhotoKit)

- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate {
    [self setPhotoForURL:url shouldAnimate:shouldAnimate withProgressBlock:nil];
}

- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate withProgressBlock:(PKFetchProgressUpdate)update {
    [self setPhotoForURL:url shouldAnimate:shouldAnimate withProgressBlock:update shouldSetPhotoOnCompletion:YES onCompletion:nil];
}

- (void)setPhotoForURL:(NSURL *)url shouldAnimateIfNotInCacheWithProgressBlock:(PKFetchProgressUpdate)update shouldSetPhotoOnCompletion:(BOOL)shouldSet onCompletion:(PKFetchCompletion)completion {
    [self setPhotoForURL:url shouldAnimate:![PKPhotoStore isPhotoCachedForURL:url] withProgressBlock:update shouldSetPhotoOnCompletion:(BOOL)shouldSet onCompletion:completion];
}

- (void)setPhotoForURL:(NSURL *)url shouldAnimate:(BOOL)shouldAnimate withProgressBlock:(PKFetchProgressUpdate)update shouldSetPhotoOnCompletion:(BOOL)shouldSet onCompletion:(PKFetchCompletion)completion {
    __weakSelf me = self;
    
    [PKPhotoStore getPhotoForURL:url withPriority:PKFetchPrioritySnappy completion:^(NSObject *image, BOOL isGIF) {
        if (image && shouldSet) {
            if (shouldAnimate) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.4f;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                
                [me.layer addAnimation:transition forKey:nil];
            } else {
                [me.layer removeAnimationForKey:nil];
            }
            
            @autoreleasepool {
                [me setImage:nil];
                [me setAnimatedImage:nil];
            }
            
            if (isGIF) {
                [me setAnimatedImage:(FLAnimatedImage *)image];
            } else {
                [me setImage:(UIImage *)image];
            }
        }
        
        if (completion) {
            completion(image, isGIF);
        }
    } progressUpdate:^(double progress) {
        if (update) {
            update(progress);
        }
    }];
}

- (void)setPostCompletionImage:(NSObject *)image isGIF:(BOOL)isGIF shouldAnimate:(BOOL)shouldAnimate {
    if (shouldAnimate) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.layer addAnimation:transition forKey:nil];
    } else {
        [self.layer removeAnimationForKey:nil];
    }
    
    @autoreleasepool {
        [self setImage:nil];
        [self setAnimatedImage:nil];
    }
    
    if (isGIF) {
        [self setAnimatedImage:(FLAnimatedImage *)image];
    } else {
        [self setImage:(UIImage *)image];
    }
}

- (BOOL)hasImage {
    return ([self image] || [self animatedImage]);
}

@end
