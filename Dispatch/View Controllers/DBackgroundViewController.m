//
//  DBackgroundViewController.m
//  Dispatch
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "DBackgroundViewController.h"
#import "NGAParallaxMotion.h"

#define kDBackgroundViewControllerAnimationDuration 0.5

@interface DBackgroundViewController ()

@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIImageView *transitionalBackgroundImageView;

@property (nonatomic) CGFloat imageViewOffset;
@property (nonatomic) CAGradientLayer *gradientLayer;

@property (nonatomic) DBackgroundPhotoAnimationTransitional transitionalAnimation;
@property (nonatomic) CGPoint backgroundInTransitionCenterOrigin;
@property (nonatomic) CGPoint transitionalBackgroundInTransitionCenterOrigin;

@end

@implementation DBackgroundViewController

#pragma mark - View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CGRect frame = [self.view frame];
    _imageViewOffset = frame.size.width * 0.2;
    
    frame.origin.x -= _imageViewOffset;
    frame.origin.y -= _imageViewOffset;
    frame.size.width += (_imageViewOffset * 2);
    frame.size.height += (_imageViewOffset * 2);
    
    _backgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [_backgroundImageView setAlpha:0.07];
    [_backgroundImageView setParallaxDirectionConstraint:NGAParallaxDirectionConstraintAll];
    [self.view addSubview:_backgroundImageView];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:self.view.frame];
    [lbl setText:@"dbgvc"];
    [self.view addSubview:lbl];
}

#pragma mark - Background

#pragma mark Color

- (void)setBackgroundColor:(UIColor *)color {
    if (_gradientLayer) {
        [_gradientLayer removeFromSuperlayer];
        _gradientLayer = nil;
    }
    
    [self.view setBackgroundColor:color];
}

- (void)setBackgroundGradientFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    _gradientLayer = [CAGradientLayer layer];
    [_gradientLayer setFrame:self.view.frame ];
    [_gradientLayer setColors:@[[fromColor colorWithAlphaComponent:0.75], [toColor colorWithAlphaComponent:0.75]]];
    [self.view.layer insertSublayer:_gradientLayer atIndex:0];
}

#pragma mark Motion

- (void)setMotionParallaxEnabled:(BOOL)motionParallaxEnabled {
    [_backgroundImageView setParallaxIntensity:(motionParallaxEnabled ? -10.0 : 0.0)];
}

#pragma mark Photo Change, Immediate

- (void)setImmediateBackgroundPhoto:(UIImage *)photo withAnimation:(DBackgroundPhotoAnimationImmediate)animation {
    
    switch (animation) {
        case DBackgroundPhotoChangeAnimationImmediateNone:
            [_backgroundImageView setImage:photo];
            break;
            
        case DBackgroundPhotoChangeAnimationImmediateFade:
        default:
            [UIView animateWithDuration:kDBackgroundViewControllerAnimationDuration delay:0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [_backgroundImageView setImage:photo];
            } completion:nil];
            break;
    }
}

#pragma mark Photo Change, Transitional

- (void)setTransitionalBackgroundPhoto:(UIImage *)photo withAnimation:(DBackgroundPhotoAnimationTransitional)animation {
    if (animation < DBackgroundPhotoChangeAnimationTransitionalLeft) {
        return;
    }
    
    CGRect frame = [_backgroundImageView frame];
    
    switch (animation) {
        case DBackgroundPhotoChangeAnimationTransitionalLeft:
            frame.origin.x += _imageViewOffset;
            break;
        case DBackgroundPhotoChangeAnimationTransitionalRight:
            frame.origin.x -= _imageViewOffset;
            break;
            
        case DBackgroundPhotoChangeAnimationTransitionalUp:
            frame.origin.y += _imageViewOffset;
            break;
            
        case DBackgroundPhotoChangeAnimationTransitionalDown:
            frame.origin.y -= _imageViewOffset;
            break;
            
        default:
            break;
    }
    
    _transitionalBackgroundImageView = [[UIImageView alloc] initWithFrame:frame];
    [_transitionalBackgroundImageView setImage:photo];
    [_transitionalBackgroundImageView setAlpha:0.0];
    [self.view addSubview:_transitionalBackgroundImageView];
    [self.view sendSubviewToBack:_transitionalBackgroundImageView];
    _transitionalAnimation = animation;
    
    _backgroundInTransitionCenterOrigin = _backgroundImageView.center;
    _transitionalBackgroundInTransitionCenterOrigin = _transitionalBackgroundImageView.center;
}

- (void)setTransitionalBackgroundPhotoTransitionProgress:(float)progress {
    if (_transitionalAnimation < DBackgroundPhotoChangeAnimationTransitionalLeft) {
        return;
    }
    
    if (progress < 0.0) {
        progress = 0.0;
    } else if (progress > 1.0) {
        progress = 1.0;
    }
    
    CGFloat offset = _imageViewOffset * progress;
    
    CGPoint centerOffset;
    
    switch (_transitionalAnimation) {
        case DBackgroundPhotoChangeAnimationTransitionalLeft:
            centerOffset = CGPointMake(-offset, 0);
            break;
            
        case DBackgroundPhotoChangeAnimationTransitionalRight:
            centerOffset = CGPointMake(offset, 0);
            break;
            
        case DBackgroundPhotoChangeAnimationTransitionalUp:
            centerOffset = CGPointMake(0, -offset);
            break;
            
        case DBackgroundPhotoChangeAnimationTransitionalDown:
            centerOffset = CGPointMake(0, offset);
            break;
            
        default:
            break;
    }
    
    CGPoint backgroundCenter = _backgroundInTransitionCenterOrigin;
    backgroundCenter.x += centerOffset.x;
    backgroundCenter.y += centerOffset.y;
    
    [_backgroundImageView setAlpha:(1.0 - progress)];
    [_backgroundImageView setCenter:backgroundCenter];
    
    CGPoint transitionalCenter = _transitionalBackgroundInTransitionCenterOrigin;
    transitionalCenter.x += centerOffset.x;
    transitionalCenter.y += centerOffset.y;
    
    [_transitionalBackgroundImageView setAlpha:progress];
    [_transitionalBackgroundImageView setCenter:transitionalCenter];
}

- (void)didFinishTransitionalBackgroundPhotoTransition {
    _backgroundImageView = _transitionalBackgroundImageView;
    _transitionalAnimation = DBackgroundPhotoChangeAnimationTransitionalNone;
    _transitionalBackgroundImageView = nil;
    _backgroundInTransitionCenterOrigin = CGPointZero;
    _transitionalBackgroundInTransitionCenterOrigin = CGPointZero;
}

@end
