//
//  FKProfile.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FKItemConstants.h"
#import "FKStream.h"

@interface FKProfile : NSObject<FKStreamable>

@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *fullName;
@property (nonatomic) NSString *email;

@property (nonatomic) NSURL *photoURL;
@property (nonatomic) UIImage *photo;

@property (nonatomic) NSString *wave;

- (NSString *)name;
+ (FKProfile *)profileFromJSONDictionary:(NSDictionary *)dictionary;

@end
