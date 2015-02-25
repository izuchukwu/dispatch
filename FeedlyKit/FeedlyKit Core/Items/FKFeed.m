//
//  FKFeed.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKFeed.h"

@implementation FKFeed

@synthesize ID, JSONdata;

+ (FKFeed *)feedFromJSONDictionary:(NSDictionary *)subDictionary {
    FKFeed *sub = [[FKFeed alloc] init];
    if ([subDictionary objectForKey:kFKFeedKeyID]) {
        [sub setID:[subDictionary objectForKey:kFKFeedKeyID]];
    } else {
        [sub setID:[subDictionary objectForKey:kFKFeedKeyIDAlt]];
    }
    
    [sub setTitle:[subDictionary objectForKey:kFKFeedKeyTitle]];
    
    if ([subDictionary objectForKey:kFKFeedKeySite]) {
        [sub setSite:[NSURL URLWithString:[subDictionary objectForKey:kFKFeedKeySite]]];
    } else {
        [sub setSite:[NSURL URLWithString:[subDictionary objectForKey:kFKFeedKeySiteAlt]]];
    }
    
    NSMutableDictionary *categoriesJSON = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *category in [subDictionary objectForKey:kFKFeedKeyCategories]) {
        [categoriesJSON setObject:category forKey:[category objectForKey:kFKCategoryKeyID]];
    }
    
    [sub setCategoriesJSON:categoriesJSON];
    
    [sub setJSONdata:subDictionary];
    return sub;
}

+ (NSArray *)feedsFromSubscriptionsJSONArray:(NSArray *)array {
    NSMutableArray *subs = [[NSMutableArray alloc] init];
    
    for (NSDictionary *subDictionary in array) {
        
        FKFeed *sub = [self feedFromJSONDictionary:subDictionary];
        [subs addObject:sub];
    }
    
    return subs;
}

- (NSString *)description {
    return (_title ? _title : [super description]);
}

@end
