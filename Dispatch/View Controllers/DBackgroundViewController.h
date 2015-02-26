//
//  DBackgroundViewController.h
//  Dispatch
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <UIKit/UIKit.h>

enum DBackgroundPhotoAnimationImmediate {
    DBackgroundPhotoChangeAnimationImmediateNone = 0,
    DBackgroundPhotoChangeAnimationImmediateFade = 1
}; typedef enum DBackgroundPhotoAnimationImmediate DBackgroundPhotoAnimationImmediate;

enum DBackgroundPhotoAnimationTransitional {
    DBackgroundPhotoChangeAnimationTransitionalNone = 0,
    DBackgroundPhotoChangeAnimationTransitionalLeft = 2,
    DBackgroundPhotoChangeAnimationTransitionalRight = 3,
    DBackgroundPhotoChangeAnimationTransitionalUp = 4,
    DBackgroundPhotoChangeAnimationTransitionalDown = 5
}; typedef enum DBackgroundPhotoAnimationTransitional DBackgroundPhotoAnimationTransitional;

@interface DBackgroundViewController : UIViewController

@property (nonatomic) BOOL motionParallaxEnabled;

- (void)setBackgroundColor:(UIColor *)color;
- (void)setBackgroundGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

- (void)setImmediateBackgroundPhoto:(UIImage *)photo withAnimation:(DBackgroundPhotoAnimationImmediate)animation;

- (void)setTransitionalBackgroundPhoto:(UIImage *)photo withAnimation:(DBackgroundPhotoAnimationTransitional)animation;
- (void)setTransitionalBackgroundPhotoTransitionProgress:(float)progress;
- (void)didFinishTransitionalBackgroundPhotoTransition;

@end