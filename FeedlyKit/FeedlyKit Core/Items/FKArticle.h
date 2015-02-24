//
//  FKArticle.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKStream.h"
#import "FKFeed.h"

@interface FKArticle : NSObject<FKStreamable>

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *author;
@property (nonatomic) NSString *contentHTML;

@property (nonatomic) NSDate *published;
@property (nonatomic) NSDate *updated;
@property (nonatomic) BOOL unread;

@property (nonatomic) NSURL *visualURL;
@property (nonatomic) NSString *visualContentType;

@property (nonatomic) FKFeed *feed;
@property (nonatomic) NSArray *keywords;

+ (NSArray *)articlesFromJSONArray:(NSArray *)array;

@end
