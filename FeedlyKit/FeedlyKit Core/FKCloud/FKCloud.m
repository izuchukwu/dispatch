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

@end

@implementation FKCloud

- (id)initWithClientID:(NSString *)clientID clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        _clientID = clientID;
        _clientSecret = clientSecret;
        
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

#pragma mark Authentication

- (void)didAuthenticateWithSuccess:(BOOL)success data:(NSData *)data {
    if (!success) {
        [_authViewController authenticationDidCompleteWithSuccess:NO];
    } else {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if ([response objectForKey:kFKCloudOAuthResponseKeyAccessToken]) {
            [_authViewController authenticationDidCompleteWithSuccess:YES];
        } else {
            [_authViewController authenticationDidCompleteWithSuccess:NO];
        }
    }
}

#pragma mark Auth VC Delegate

- (void)authViewController:(UIViewController *)authViewController didReturnWithRedirectURL:(NSURL *)URL {
    [[NXOAuth2AccountStore sharedStore] handleRedirectURL:URL];
    
}

#pragma mark - Utils

+ (NSURL *)requestURLWithEndpoint:(NSString *)endpoint {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kFKCloudDomain, endpoint]];
}

@end