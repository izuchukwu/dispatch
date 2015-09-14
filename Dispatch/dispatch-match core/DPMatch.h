//
//  DPMatch.h
//  dispatch-match
//
//  Created by Izuchukwu Elechi on 9/13/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

@interface DPMatch : NSObject

- (void)matchesWithQuery:(NSString *)query client:(TWTRAPIClient *)client completion:(void (^)(NSArray *results))completion;

@end
