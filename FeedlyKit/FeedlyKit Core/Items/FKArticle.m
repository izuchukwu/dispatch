//
//  FKArticle.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKArticle.h"

@implementation FKArticleMedia

@end

@implementation FKArticle

@synthesize ID, JSONdata;

+ (FKArticle *)articleFromJSONDictionary:(NSDictionary *)articleDictionary {
    FKArticle *article = [[FKArticle alloc] init];
    
    [article setID:[articleDictionary objectForKey:kFKArticleKeyID]];
    [article setTitle:[articleDictionary objectForKey:kFKArticleKeyTitle]];
    [article setAuthor:[articleDictionary objectForKey:kFKArticleKeyAuthor]];
    
    [article setContentHTML:[[articleDictionary objectForKey:kFKArticleKeyContentDictionary] objectForKey: kFKArticleKeyContentHTML]];
    
    [article setPublished:[NSDate dateWithTimeIntervalSince1970:([[articleDictionary objectForKey:kFKArticleKeyPublished] doubleValue] / 1000)]];
    [article setUpdated:[NSDate dateWithTimeIntervalSince1970:([[articleDictionary objectForKey:kFKArticleKeyUpdated] doubleValue] / 1000)]];
    
    [article setVisualURL:[NSURL URLWithString:[[articleDictionary objectForKey:kFKArticleKeyVisual] objectForKey:kFKArticleKeyVisualURL]]];
    [article setVisualContentType:[[articleDictionary objectForKey:kFKArticleKeyVisual] objectForKey:kFKArticleKeyVisualContentType]];
    
    NSMutableArray *enclosedMedia = [[NSMutableArray alloc] init];
    for (NSDictionary *media in [articleDictionary objectForKey:kFKArticleKeyMedia]) {
        FKArticleMedia *articleMedia = [[FKArticleMedia alloc] init];
        [articleMedia setURL:[media objectForKey:kFKArticleKeyMediaURL]];
        [articleMedia setContentType:[media objectForKey:kFKArticleKeyMediaContentType]];
        [enclosedMedia addObject:articleMedia];
    }
    [article setEnclosedMedia:enclosedMedia];
    
    [article setKeywords:[articleDictionary objectForKey:kFKArticleKeyKeywords]];
    [article setUnread:[[articleDictionary objectForKey:kFKArticleKeyUnread] boolValue]];
    
    FKFeed *feed = [FKFeed feedFromJSONDictionary:[articleDictionary objectForKey:kFKArticleKeyFeed]];
    [article setFeed:feed];
    
    [article setJSONdata:articleDictionary];
    return article;
}

+ (NSArray *)articlesFromJSONArray:(NSArray *)array {
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    
    for (NSDictionary *articleDictionary in array) {
        [articles addObject:[self articleFromJSONDictionary:articleDictionary]];
    }
    
    return articles;
}

- (NSString *)description {
    return (_title ? (_published ? [NSString stringWithFormat:@"%@ — %@", _title, _published] : _title) : [super description]);
}

@end
