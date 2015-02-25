//
//  FKCache.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKCache : NSObject

- (void)cacheCategories:(NSArray *)categories;
- (void)cacheArticles:(NSArray *) forStreamable:(id<FKStreamable>)streamable;



@end
