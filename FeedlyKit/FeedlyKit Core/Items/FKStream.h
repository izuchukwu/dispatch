//
//  FKStream.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKStreamable <NSObject>

@property (nonatomic) NSString *ID;
@property (nonatomic) NSDictionary *JSONdata;

@end

@interface FKStream : NSObject

@end
