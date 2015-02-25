//
//  FKCloud.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKCloud.h"
#import "FKCloudConstants.h"

@interface FKCloud()

@property (nonatomic) NSString *clientID;
@property (nonatomic) NSString *clientSecret;

@property (nonatomic) FKAuthViewController *authViewController;

@property (nonatomic) NSMutableDictionary *networkingFetchQueue;

@end

enum FKCloudNetworkingFetchType {
    FKCloudNetworkingFetchTypeArticles = 0
}; typedef enum FKCloudNetworkingFetchType FKCloudNetworkingFetchType;

@implementation FKCloud

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret account:(NXOAuth2Account *)account {
    self = [super init];
    if (self) {
        _clientID = clientID;
        _clientSecret = clientSecret;
        _account = account;
        
        NSMutableDictionary *oAuthConfiguration = [[NSMutableDictionary alloc] init];
        [oAuthConfiguration setObject:_clientID forKey:kNXOAuth2AccountStoreConfigurationClientID];
        [oAuthConfiguration setObject:_clientSecret forKey:kNXOAuth2AccountStoreConfigurationSecret];
        [oAuthConfiguration setObject:[NSSet setWithObject:kFKCloudAuthParamDefaultScope] forKey:kNXOAuth2AccountStoreConfigurationScope];
        [oAuthConfiguration setObject:[FKCloud requestURLWithEndpoint:kFKCloudEndpointAuth] forKey:kNXOAuth2AccountStoreConfigurationAuthorizeURL];
        [oAuthConfiguration setObject:[FKCloud requestURLWithEndpoint:kFKCloudEndpointOAuth] forKey:kNXOAuth2AccountStoreConfigurationTokenURL];
        [oAuthConfiguration setObject:FKNSURL(kFKCloudAuthParamDefaultRedirectURI) forKey:kNXOAuth2AccountStoreConfigurationRedirectURL];
        
        [[NXOAuth2AccountStore sharedStore] setConfiguration:oAuthConfiguration forAccountType:kFKCloudAccountType];
    }
    return self;
}

#pragma mark - Public

- (void)requestReauthentication {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:kFKCloudAccountType withPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        _authViewController = [[FKAuthViewController alloc] initWithAuthRequest:[NSURLRequest requestWithURL:preparedURL] redirectPrefix:kFKCloudAuthParamDefaultRedirectURI];
        [_authViewController setDelegate:self];
        
        [_delegate presentAuthenticationViewController: _authViewController];
    }];
}

- (void)fetchCategoriesWithRefresh:(BOOL)shouldRefresh {
    NSAssert1(@"Account", @"To fetch categories, set an authenticated account.", _account);
    
    [NXOAuth2Request performMethod:@"GET" onResource:[FKCloud requestURLWithEndpoint:kFKCloudEndpointCategories] usingParameters:nil withAccount:_account sendProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            NSLog(@"[!] Error Fetching Categories: %@", [error description]);
        }
        
        NSArray *categories = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        [self fetchSubscriptionsWithCategories:[FKCategory categoriesFromJSONArray:categories]];
    }];
}

- (void)fetchArticlesForStreamable:(id<FKStreamable>)streamable withPaginationID:(NSString *)pageID shouldRefresh:(BOOL)shouldRefresh {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:[streamable ID] forKey:kFKCloudRequestParamStreamID];
    [parameters setObject:[NSString stringWithFormat:@"%d", kFKCloudRequestParamStreamCountDefault] forKey:kFKCloudRequestParamStreamCount];
    if (pageID) {
        [parameters setObject:pageID forKey:kFKCloudRequestParamStreamContinuation];
    }
    
    [NXOAuth2Request performMethod:@"GET" onResource:[FKCloud requestURLWithEndpoint:kFKCloudEndpointStreamContent] usingParameters:parameters withAccount:_account sendProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            NSLog(@"[!] Error Fetching Articles: %@", [error description]);
        }
        
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSArray *articlesJSON = [responseJSON objectForKey:kFKCloudRequestResponseKeyStreamContentItems];
        NSArray *articles = [FKArticle articlesFromJSONArray:articlesJSON];
        
        if ([_delegate respondsToSelector:@selector(didFetchArticles:forStreamable:withPaginationID:)]) {
            [_delegate didFetchArticles:articles forStreamable:streamable withPaginationID:[responseJSON objectForKey:kFKCloudRequestParamStreamContinuation]];
        }
    }];
}

- (void)unauthenticate {
    if (_account) {
        [[NXOAuth2AccountStore sharedStore] removeAccount:_account];
        _account = nil;
    } else {
        NSLog(@"[!] Attempted unauthentication without account set");
    }
}

#pragma mark - Fetch

- (void)fetchArticlesForArticleIDSet:(NSArray *)articleIDs streamable:(id<FKStreamable>)streamable __deprecated {
    
    // This method is used in the two-part method for fetching Articles
    // Instead, request the stream contents directly
    // The method is kept to illustrate using both NXOAuth2 & ICNetworking for POSTs
    
    NXOAuth2Request *request = [[NXOAuth2Request alloc] initWithResource:[FKCloud requestURLWithEndpoint:kFKCloudEndpointArticle] method:@"POST" parameters:nil];
    [request setAccount:_account];
    
    NSMutableURLRequest *signedRequest = (NSMutableURLRequest *)[request signedURLRequest];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:articleIDs options:0 error:nil];
    
    [signedRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [signedRequest setHTTPBody:jsonData];
    
    ICNetworkingQueuedItem *queuedRequest = [[ICNetworkingQueuedItem alloc] init];
    [queuedRequest setDelegate:self];
    [queuedRequest setRequest:signedRequest];
    
    if (!_networkingFetchQueue) {
        _networkingFetchQueue = [[NSMutableDictionary alloc] init];
    }
    
    [_networkingFetchQueue setObject:@(FKCloudNetworkingFetchTypeArticles) forKey:[[queuedRequest  request] URL]];
    [_networkingFetchQueue setObject:streamable forKey:[NSString stringWithFormat:@"%@-streamable", [[[queuedRequest  request] URL] absoluteString]]];
    
    ICNetworking *networking = [[ICNetworking alloc] init];
    [networking addQueuedItem:queuedRequest];
}

- (void)fetchSubscriptionsWithCategories:(NSArray *)categories {
    [NXOAuth2Request performMethod:@"GET" onResource:[FKCloud requestURLWithEndpoint:kFKCloudEndpointSubscriptions] usingParameters:nil withAccount:_account sendProgressHandler:nil responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if (error) {
            NSLog(@"[!] Error Fetching Subscriptions: %@", [error description]);
        }
        
        NSArray *subs = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        [self sortSubscriptions:[FKFeed feedsFromSubscriptionsJSONArray:subs] intoCategories:categories];
    }];
}

- (void)sortSubscriptions:(NSArray *)subs intoCategories:(NSArray *)categories {
    NSMutableDictionary *categorySubs = [[NSMutableDictionary alloc] init];
    
    for (FKFeed *sub in subs) {
        for (NSString *categoryID in [sub categoryIDs]) {
            if ([categorySubs objectForKey:categoryID]) {
                NSMutableArray *array = [categorySubs objectForKey:categoryID];
                [array addObject:sub];
            } else {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:sub];
                [categorySubs setObject:array forKey:categoryID];
            }
        }
    }
    
    for (NSString *categoryID in [categorySubs allKeys]) {
        FKCategory *category;
        
        for (FKCategory *cat in categories) {
            if ([[cat ID] isEqualToString:categoryID]) {
                category = cat;
            }
        }
        
        if (category) {
            [category setFeeds:[categorySubs objectForKey:categoryID]];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didFetchCategories:)]) {
        [_delegate didFetchCategories:categories];
    }
}

#pragma mark - Networking Delegate

- (void)didFinishDownloadingItemAtURL:(NSURL *)url withSuccess:(BOOL)success data:(NSData *)data {
    FKCloudNetworkingFetchType fetchType = (FKCloudNetworkingFetchType)[_networkingFetchQueue objectForKey:url];
    [_networkingFetchQueue removeObjectForKey:url];
    
    switch (fetchType) {
        default:
            break;
    }
}

#pragma mark - Auth VC Delegate

- (void)authViewController:(UIViewController *)authViewController didReturnWithRedirectURL:(NSURL *)URL {
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:URL];
    [_authViewController authenticationStepDidComplete];
    
    if ([_delegate respondsToSelector:@selector(feedlyIsAuthenticating)]) {
        [_delegate feedlyIsAuthenticating];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *notification){
        if ([[notification userInfo] objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey]) {
            // A successful authentication has occurred
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            _account = [[notification userInfo] objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
            
            if ([_delegate respondsToSelector:@selector(feedlyAuthenticationDidCompleteWithSuccess:)]) {
                [_delegate feedlyAuthenticationDidCompleteWithSuccess:YES];
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *notification){
        // An attempt to authenticate has failed
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        NSError *error = [notification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        NSLog(@"[!] Error Updating Accounts: %@", [error description]);
        
        if ([_delegate respondsToSelector:@selector(feedlyAuthenticationDidCompleteWithSuccess:)]) {
            [_delegate feedlyAuthenticationDidCompleteWithSuccess:NO];
        }
    }];
}

#pragma mark - Utils

+ (NSURL *)requestURLWithEndpoint:(NSString *)endpoint {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kFKCloudDomain, endpoint]];
}

@end