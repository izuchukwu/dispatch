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

#define kFKCloudAuthParamDefaultRedirectURI @"http://localhost"
#define kFKCloudAuthParamDefaultScope @"https://cloud.feedly.com/subscriptions"

//  Second Step (OAuth)

#define kFKCloudEndpointOAuth @"v3/auth/token"

#define kFKCloudOAuthResponseKeyUserID @"id"
#define kFKCloudOAuthResponseKeyPlan @"plan"

//
//  Requests
//

// Endpoints

#define kFKCloudEndpointCategories @"v3/categories"
#define kFKCloudEndpointSubscriptions @"v3/subscriptions"
#define kFKCloudEndpointStream @"v3/streams/ids"
#define kFKCloudEndpointStreamContent @"v3/streams/contents"
#define kFKCloudEndpointArticle @"v3/entries/.mget"

// Parameters

#define kFKCloudRequestParamStreamID @"streamId"
#define kFKCloudRequestParamStreamCount @"count"
#define kFKCloudRequestParamStreamContinuation @"continuation"

#define kFKCloudRequestParamStreamCountDefault 20

// Response Keys

#define kFKCloudRequestResponseKeyStreamIDs @"ids"
#define kFKCloudRequestResponseKeyStreamContentItems @"items"

#endif
