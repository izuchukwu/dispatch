//
//  ICNetworkingCommon.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#ifndef FeedlyKit_ICNetworkingCommon_h
#define FeedlyKit_ICNetworkingCommon_h

enum ICNetworkingHTTPMethod {
    ICNetworkingHTTPMethodGET = 0,
    ICNetworkingHTTPMethodPOST = 1
}; typedef enum ICNetworkingHTTPMethod ICNetworkingHTTPMethod;

#define kICNetworkingOAuthHTTPHeader @"Authorization"
#define kICNetworkingOAuthStringPrefix @"OAuth"

#define kICNetworkingHTTPHeaderContentType @"Content-Type"

#define kICNetworkingHTTPMethodGET @"GET"
#define kICNetworkingHTTPMethodPOST @"POST"

#endif
