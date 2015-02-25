//
//  FKProfile.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKProfile.h"

@implementation FKProfile

@synthesize ID, JSONdata;

- (NSString *)name {
    if (_firstName) {
        return _firstName;
    } else if (_fullName) {
        return _fullName;
    } else if (_email) {
        return _email;
    } else {
        return kFKProfileNameUnknown;
    }
}

+ (FKProfile *)profileFromJSONDictionary:(NSDictionary *)dictionary {
    FKProfile *profile = [[FKProfile alloc] init];
    [profile setID:[dictionary objectForKey:kFKProfileKeyID]];
    
    NSString *firstName = [dictionary objectForKey:kFKProfileKeyFirstName];
    NSString *lastName = [dictionary objectForKey:kFKProfileKeyLastName];
    NSString *fullName = [dictionary objectForKey:kFKProfileKeyFullName];
    
    if (!fullName) {
        fullName = [NSString stringWithFormat:@"%@%@", (firstName ? kFKProfileNameWithTrailingSpace(firstName) : @""), (lastName ? lastName : @"")];
        if ([fullName isEqualToString:@""]) {
            fullName = nil;
        }
    }
    
    [profile setFullName:fullName];
    
    [profile setPhotoURL:[dictionary objectForKey:kFKProfileKeyPhotoURL]];
    [profile setWave:[dictionary objectForKey:kFKProfileKeyWave]];
    
    [profile setJSONdata:dictionary];
    return profile;
}

@end
