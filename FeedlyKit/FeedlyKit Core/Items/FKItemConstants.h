//
//  FKItemConstants.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#ifndef FeedlyKit_FKItemConstants_h
#define FeedlyKit_FKItemConstants_h

// Categories

#define kFKCategoryKeyID @"id"
#define kFKCategoryKeyLabel @"label"

// Feeds
// Alts are the counterparts used when article:origin dictionaries are given

#define kFKFeedKeyID @"id"
#define kFKFeedKeyIDAlt @"id"
#define kFKFeedKeyTitle @"title"
#define kFKFeedKeySite @"website"
#define kFKFeedKeySiteAlt @"htmlUrl"
#define kFKFeedKeyCategories @"categories"

// Articles

#define kFKArticleKeyID @"id"
#define kFKArticleKeyTitle @"title"
#define kFKArticleKeyAuthor @"author"

#define kFKArticleKeyContentDictionary @"content"
#define kFKArticleKeyContentHTML @"content"

#define kFKArticleKeyPublished @"published"
#define kFKArticleKeyUpdated @"updated"

#define kFKArticleKeyVisual @"visual"
#define kFKArticleKeyVisualURL @"url"
#define kFKArticleKeyVisualContentType @"contentType"

#define kFKArticleKeyMedia @"enclosure"
#define kFKArticleKeyMediaURL @"href"
#define kFKArticleKeyMediaContentType @"type"

#define kFKArticleKeyKeywords @"keywords"
#define kFKArticleKeyUnread @"unread"
#define kFKArticleKeyFeed @"origin"

// Profiles

#define kFKProfileKeyID @"id"
#define kFKProfileKeyFirstName @"givenName"
#define kFKProfileKeyLastName @"familyName"
#define kFKProfileKeyFullName @"fullName"
#define kFKProfileKeyEmail @"givenName"

#define kFKProfileKeyPhotoURL @"picture"
#define kFKProfileKeyWave @"wave"

#define kFKProfileNameWithTrailingSpace(name) [NSString stringWithFormat:@"%@ ", name]
#define kFKProfileNameUnknown @"Dispatcher"

#endif
