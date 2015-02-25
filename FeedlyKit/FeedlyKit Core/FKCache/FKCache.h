////
//  FKCache.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKItems.h"

@interface FKCache : NSObject

+ (void)cacheCategories:(NSArray *)categories;
+ (void)cacheArticles:(NSArray *)articles forStreamable:(id<FKStreamable>)streamable;
+ (void)cacheProfile:(FKProfile *)profile;

+ (NSArray *)retrieveCachedCategories;
+ (NSArray *)retrieveCachedArticlesForStreamable:(id<FKStreamable>)streamable;
+ (FKProfile *)retrieveCachedProfile;

@end
