//
//  FKFeed.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKStream.h"
#import "FKItemConstants.h"

@interface FKFeed : NSObject<FKStreamable>

@property (nonatomic) NSString *title;
@property (nonatomic) NSURL *site;

@property (nonatomic) NSArray *categoryIDs;
@property (nonatomic) FKStream *articles;

+ (NSArray *)feedsFromSubscriptionsJSONArray:(NSArray *)array;

@end
