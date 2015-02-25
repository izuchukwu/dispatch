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
#import "FKItems.h"
#import "ICNetworking.h"

@class FKCloud;

@protocol FKCloudDelegate <NSObject>

@optional

- (void)presentAuthenticationViewController:(FKAuthViewController *)authViewController;

- (void)feedlyIsAuthenticating;
- (void)feedlyAuthenticationDidCompleteWithSuccess:(BOOL)success;

- (void)didFetchCategories:(NSArray *)categories;
- (void)didFetchArticles:(NSArray *)articles forStreamable:(id<FKStreamable>)streamable withPaginationID:(NSString *)pageID;
- (void)didFetchProfile:(FKProfile *)profile;

@end

@interface FKCloud : NSObject<FKAuthViewControllerDelegate, ICNetworkingDelegate>

@property (nonatomic) id<FKCloudDelegate> delegate;

@property (nonatomic) NXOAuth2Account *account;

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret account:(NXOAuth2Account *)account;

- (void)requestReauthentication;

- (void)fetchCategoriesWithRefresh:(BOOL)shouldRefresh;
- (BOOL)canFetchArticlesForStreamable:(id<FKStreamable>)streamable;
- (void)fetchArticlesForStreamable:(id<FKStreamable>)streamabale withPaginationID:(NSString *)pageID;
- (void)fetchProfileWithRefresh:(BOOL)shouldRefresh;

- (void)unauthenticate;

@end
