//
//  FKCache.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKCache.h"
#import "FKCacheConstants.h"
#import "PhotoKit.h"

@implementation FKCache

#pragma mark - Caching

+ (void)cacheCategories:(NSArray *)categories {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *categoriesData = [[NSMutableDictionary alloc] init];
    NSMutableArray *categoryIDs = [[NSMutableArray alloc] init];
    
    for (FKCategory *category in categories) {
        [categoriesData setObject:[category JSONdata] forKey:[category ID]];
        [categoryIDs addObject:[category ID]];
        NSMutableArray *feedData = [[NSMutableArray alloc] init];
        
        for (FKFeed *feed in [category feeds]) {
            [feedData addObject:[feed JSONdata]];
        }
        
        [categoriesData setObject:feedData forKey:kFKCacheCategoriesCacheFeedDataKey([category ID])];
    }
    
    [categoriesData setObject:categoryIDs forKey:kFKCacheCategoriesCacheKeyIDs];
    [defaults setObject:categoriesData forKey:kFKCacheDefaultsKeyCategories];
    [defaults setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:kFKCacheDefaultsKeyCategoriesTimestamp];
}

+ (void)cacheArticles:(NSArray *)articles forStreamable:(id<FKStreamable>)streamable {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *cachedArticleContexts = [NSMutableArray arrayWithArray:[defaults objectForKey:kFKCacheDefaultsKeyArticles]];
    
    if (!cachedArticleContexts) {
        cachedArticleContexts = [[NSMutableArray alloc] init];
    }
    
    BOOL contextDidExist = NO;
    for (NSDictionary *contextIterator in cachedArticleContexts) {
        if ([[contextIterator objectForKey:kFKCacheDefaultsArticlesContextKeyID] isEqualToString:[streamable ID]]) {
            contextDidExist = YES;
            [cachedArticleContexts removeObject:contextIterator];
        }
    }
    
    if (!contextDidExist && ([cachedArticleContexts count] > kFKCacheArticlesCacheMax)) {
        [cachedArticleContexts removeLastObject];
    }
    
    NSMutableArray *articlesData = [[NSMutableArray alloc] init];
    
    for (FKArticle *article in articles) {
        [articlesData addObject:[article JSONdata]];
    }
    
    NSMutableDictionary *context = [[NSMutableDictionary alloc] init];
    [context setObject:[streamable ID] forKey:kFKCacheDefaultsArticlesContextKeyID];
    [context setObject:articlesData forKey:kFKCacheDefaultsArticlesContextKeyArticles];
    
    [cachedArticleContexts insertObject:context atIndex:0];
    
    [defaults setObject:cachedArticleContexts forKey:kFKCacheDefaultsKeyArticles];
}

+ (void)cacheProfile:(FKProfile *)profile {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[profile JSONdata] forKey:kFKCacheDefaultsKeyProfile];
    [defaults setObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] forKey:kFKCacheDefaultsKeyProfileTimestamp];
}

#pragma mark - Retrieval

+ (NSArray *)retrieveCachedCategories {
    NSDictionary *categoriesData = [[NSUserDefaults standardUserDefaults] objectForKey:kFKCacheDefaultsKeyCategories];
    
    if (!categoriesData) {
        return nil;
    }
    
    NSArray *categoryIDs = [categoriesData objectForKey:kFKCacheCategoriesCacheKeyIDs];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (NSString *categoryID in categoryIDs) {
        NSMutableDictionary *categoryDictionary = [categoriesData objectForKey:categoryID];
        FKCategory *category = [FKCategory categoryFromJSONDictionary:categoryDictionary];
        NSMutableArray *feeds = [[NSMutableArray alloc] init];
        
        for (NSDictionary *feedDictionary in [categoriesData objectForKey:kFKCacheCategoriesCacheFeedDataKey(categoryID)]) {
            FKFeed *feed = [FKFeed feedFromJSONDictionary:feedDictionary];
            [feeds addObject:feed];
        }
        
        [category setFeeds:feeds];
        [categories addObject:category];
    }
    
    return categories;
}

+ (NSArray *)retrieveCachedArticlesForStreamable:(id<FKStreamable>)streamable {
    NSArray *cachedArticleContexts = [[NSUserDefaults standardUserDefaults] objectForKey:kFKCacheDefaultsKeyArticles];
    
    if (!cachedArticleContexts) {
        return nil;
    }
    
    NSDictionary *context;
    for (NSDictionary *contextIterator in cachedArticleContexts) {
        if ([[contextIterator objectForKey:kFKCacheDefaultsArticlesContextKeyID] isEqualToString:[streamable ID]]) {
            context = contextIterator;
        }
    }
    
    if (!context) {
        return nil;
    }
    
    NSArray *articlesData = [context objectForKey:kFKCacheDefaultsArticlesContextKeyArticles];
    return [FKArticle articlesFromJSONArray:articlesData];
}

+ (FKProfile *)retrieveCachedProfile {
    NSDictionary *profileDictionary = [[NSUserDefaults standardUserDefaults] objectForKey:kFKCacheDefaultsKeyProfile];
    
    if (profileDictionary) {
        return [FKProfile profileFromJSONDictionary:profileDictionary];
    } else {
        return nil;
    }
}

@end
