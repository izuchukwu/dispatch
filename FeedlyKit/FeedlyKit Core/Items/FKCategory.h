//
//  FKCategory.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKStream.h"
#import "FKItemConstants.h"

@interface FKCategory : NSObject<FKStreamable>

@property (nonatomic) NSString *label;
@property (nonatomic) NSArray *feeds;

+ (FKCategory *)categoryFromJSONDictionary:(NSDictionary *)jsonDictionary;
+ (NSArray *)categoriesFromJSONArray:(NSArray *)array;

@end
