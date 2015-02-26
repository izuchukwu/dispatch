//
//  DWindowDispatch.h
//  Dispatch
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DBackgroundViewController.h"

@class DWindowDispatch;

@protocol DWindowDispatchable <NSObject>

@property (nonatomic) DWindowDispatch *dispatcher;

@optional

- (void)didDispatch;

@end

@interface DWindowDispatch : NSObject

- (void)dispatchWindowWithViewController:(UIViewController<DWindowDispatchable> *)viewController;
- (void)recallWindow;

- (DBackgroundViewController *)backgroundViewController;

@end
