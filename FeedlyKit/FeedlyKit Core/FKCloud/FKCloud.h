//
//  FKCloud.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "NXOAuth2.h"

#import "FKAuthViewController.h"

@class FKCloud;

@protocol FKCloudDelegate <NSObject>

@optional

- (void)presentAuthenticationViewController:(FKAuthViewController *)authViewController;
- (void)feedlyAuthenticationDidCompleteWithSuccess:(BOOL)success;

@end

@interface FKCloud : NSObject<FKAuthViewControllerDelegate>

@property (nonatomic) id<FKCloudDelegate> delegate;

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret;

- (void)requestReauthentication;

- (NSArray *)fetchCategoriesWithRefresh:(BOOL)shouldRefresh;
- (NSArray *)fetchSubscriptionsWithRefresh:(BOOL)shouldRefresh;
- (NSArray *)fetchTagsWithRefresh:(BOOL)shouldRefresh;

- (NSArray *)fetchEntriesForStreamWithID:(NSString *)streamID withRefresh:(BOOL)shouldRefresh;

@end
