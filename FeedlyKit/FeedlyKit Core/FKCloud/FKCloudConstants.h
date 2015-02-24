//
//  FKCloudConstants.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#ifndef FeedlyKit_FKCloudConstants_h
#define FeedlyKit_FKCloudConstants_h

#define kFKCloudDomain @"https://sandbox.feedly.com"
#define kFKCloudAccountType @"feedly"

#define FKNSURL(string) [NSURL URLWithString:string]

//
//  Authentication
//

//  First Step (Code)

#define kFKCloudEndpointAuth @"v3/auth/auth"

#define kFKCloudAuthParamDefaultResponseType @"code"
#define kFKCloudAuthParamDefaultRedirectURI @"http://localhost"
#define kFKCloudAuthParamDefaultScope @"https://cloud.feedly.com/subscriptions"
#define kFKCloudAuthParamDefaultState @"wedidit"

#define kFKCloudAuthURLPointError @"?error="
#define kFKCloudAuthURLPointCode @"?code="
#define kFKCloudAuthURLPointJoint @"&"

//  Second Step (OAuth)

#define kFKCloudEndpointOAuth @"v3/auth/token"

#define kFKCloudOAuthParamCode @"code"
#define kFKCloudOAuthParamClientID kFKCloudAuthParamClientID
#define kFKCloudOAuthParamClientSecret @"client_secret"
#define kFKCloudOAuthParamRedirectURI kFKCloudAuthParamRedirectURI
#define kFKCloudOAuthParamState @"state"
#define kFKCloudOAuthParamGrantType @"grant_type"

#define kFKCloudOAuthParamDefaultRedirectURI kFKCloudAuthParamDefaultRedirectURI
#define kFKCloudOAuthParamDefaultState kFKCloudAuthParamDefaultState
#define kFKCloudOAuthParamDefaultGrantType @"authorization_code"

#define kFKCloudOAuthResponseKeyAccessToken @"access_token"
#define kFKCloudOAuthResponseKeyUserID @"id"
#define kFKCloudOAuthResponseKeyRefreshToken @"refresh_token"
#define kFKCloudOAuthResponseKeyExpiry @"expires_in"
#define kFKCloudOAuthResponseKeyPlan @"plan"

#endif
