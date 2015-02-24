//
//  FKFeed.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKFeed.h"

@implementation FKFeed

@synthesize ID;

+ (NSArray *)feedsFromSubscriptionsJSONArray:(NSArray *)array {
    NSMutableArray *subs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *subDictionary in array) {
        FKFeed *sub = [[FKFeed alloc] init];
        [sub setID:[subDictionary objectForKey:kFKFeedKeyID]];
        [sub setTitle:[subDictionary objectForKey:kFKFeedKeyTitle]];
        [sub setSite:[NSURL URLWithString:[subDictionary objectForKey:kFKFeedKeySite]]];
        [subs addObject:sub];
        
        NSMutableArray *categoryIDs = [[NSMutableArray alloc] init];
        
        for (NSDictionary *category in [subDictionary objectForKey:kFKFeedKeyCategories]) {
            [categoryIDs addObject:[category objectForKey:kFKCategoryKeyID]];
        }
        
        [sub setCategoryIDs:categoryIDs];
    }
    
    return subs;
}

- (NSString *)description {
    return (_title ? _title : [super description]);
}

@end
