//
//  FKAuthViewController.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FKAuthCommon.h"

@protocol FKAuthViewControllerDelegate <NSObject>

- (void)authViewController:(UIViewController *)authViewController didReturnWithRedirectURL:(NSURL *)URL;

@end

@interface FKAuthViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic) id<FKAuthViewControllerDelegate> delegate;

- (id)initWithAuthRequest:(NSURLRequest *)request redirectPrefix:(NSString *)redirectPrefix;

- (void)authenticationStepDidComplete;

@end
