//
//  FKCategory.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKCategory.h"

@implementation FKCategory

@synthesize ID;

+ (NSArray *)categoriesFromJSONArray:(NSArray *)array {
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    
    for (NSDictionary *categoryDictionary in array) {
        FKCategory *category = [[FKCategory alloc] init];
        [category setID:[categoryDictionary objectForKey:kFKCategoryKeyID]];
        [category setLabel:[categoryDictionary objectForKey:kFKCategoryKeyLabel]];
        [categories addObject:category];
    }
    
    return categories;
}

- (NSString *)description {
    return (_label ? (_feeds ? [NSString stringWithFormat:@"Label: %@, Feeds: %@", _label, _feeds] : _label) : [super description]);
}

@end
