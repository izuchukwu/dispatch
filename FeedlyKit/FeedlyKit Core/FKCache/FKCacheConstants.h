//
//  FKCacheConstants.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#ifndef FeedlyKit_FKCacheConstants_h
#define FeedlyKit_FKCacheConstants_h

//
//  NSUserDefaults
//

#define kFKCacheDefaultsKeyCategories @"cache-categories"
#define kFKCacheDefaultsKeyArticles @"cache-articles"
#define kFKCacheDefaultsKeyProfile @"cache-profile"

// Timestamps

#define kFKCacheDefaultsKeyCategoriesTimestamp @"cache-categories-timestamp"
#define kFKCacheDefaultsKeyProfileTimestamp @"cache-profile-timestamp"

//
//  Categories Cache
//

#define kFKCacheCategoriesCacheFeedDataKey(ID) [NSString stringWithFormat:@"%@-feeds", ID]
#define kFKCacheCategoriesCacheKeyIDs @"cache-ids"

//
//  Articles Cache
//

#define kFKCacheArticlesCacheMax 50
#define kFKCacheDefaultsArticlesContextKeyID @"id"
#define kFKCacheDefaultsArticlesContextKeyArticles @"articles"

#endif
