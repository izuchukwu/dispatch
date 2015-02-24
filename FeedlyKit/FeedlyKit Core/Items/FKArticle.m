//
//  FKArticle.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKArticle.h"

@implementation FKArticle

@synthesize ID;

+ (NSArray *)articlesFromJSONArray:(NSArray *)array {
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    
    for (NSDictionary *articleDictionary in array) {
        FKArticle *article = [[FKArticle alloc] init];
        
        [article setID:[articleDictionary objectForKey:kFKArticleKeyID]];
        [article setTitle:[articleDictionary objectForKey:kFKArticleKeyTitle]];
        [article setAuthor:[articleDictionary objectForKey:kFKArticleKeyAuthor]];
        
        [article setContentHTML:[[articleDictionary objectForKey:kFKArticleKeyContentDictionary] objectForKey: kFKArticleKeyContentHTML]];
        
        //[article setVisualURL:<#(NSURL *)#>]
        
        [articles addObject:article];
    }
    
    return articles;
}

- (NSString *)description {
    return (_title ? _title : [super description]);
}

@end
