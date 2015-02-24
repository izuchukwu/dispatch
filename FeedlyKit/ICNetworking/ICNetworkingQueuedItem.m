//
//  ICNetworkingQueuedItem.m
//  izuchukwu.co
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "ICNetworkingQueuedItem.h"

@interface ICNetworkingQueuedItem ()

@property (nonatomic) NSString *oAuthString;

@end

@implementation ICNetworkingQueuedItem

- (NSURLRequest *)request {
    if (_request) {
        return _request;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    
    if (_oAuthString) {
        [request setValue:_oAuthString forHTTPHeaderField:kICNetworkingOAuthHTTPHeader];
    }
    
    if (_contentType) {
        [request setValue:_contentType forKey:kICNetworkingHTTPHeaderContentType];
    }
    
    switch (_method) {
        case ICNetworkingHTTPMethodPOST:
            [request setHTTPMethod:kICNetworkingHTTPMethodPOST];
            break;
          
        case ICNetworkingHTTPMethodGET:
        default:
            [request setHTTPMethod:kICNetworkingHTTPMethodGET];
            break;
    }
    
    return request;
}

- (void)setOAuthStringWithPrimaryValue:(NSString *)primaryValue keyedValues:(NSDictionary *)keyedValues {
    
    NSMutableString *oAuthString = [NSMutableString stringWithFormat:@"%@ ", kICNetworkingOAuthStringPrefix];
    
    if (primaryValue) {
        [oAuthString appendFormat:@"%@%@", primaryValue, (keyedValues ? @" " : @"")];
    }
    
    if (keyedValues) {
        NSArray *valueKeys = [keyedValues allKeys];
        
        for (NSString *key in valueKeys) {
            [oAuthString appendFormat:@"%@%@=%@", (([valueKeys indexOfObject:key] == 0) ? @"" : @"&"), key, [keyedValues objectForKey:key]];
        }
    }
    
     _oAuthString = oAuthString;
}

- (void)clearOAuth {
    _oAuthString = nil;
}

@end
