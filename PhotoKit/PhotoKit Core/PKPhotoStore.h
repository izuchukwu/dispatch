//
//  PKPhotoStore.h
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 7/17/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^PKFetchCompletion)(NSObject *image, BOOL isGIF);
typedef void(^PKFetchProgressUpdate)(double progress);

typedef enum PKFetchPriority {
    PKFetchPrioritySnappy = 0,
    PKFetchPriorityItCanWait = 1
} PKFetchPriority;

typedef enum PKStoreLoggingLevel {
    PKStoreLoggingLevelDont = 0,
    PKStoreLoggingLevelHereAndThere = 1,
    PKStoreLoggingLevelAllYouGot = 2
} PKStoreLoggingLevel;

@interface PKPhotoStore : NSObject

+ (void)getPhotoForURL:(NSURL *)url withPriority:(PKFetchPriority)priority completion:(PKFetchCompletion)completion;
+ (void)getPhotoForURL:(NSURL *)url withPriority:(PKFetchPriority)priority completion:(PKFetchCompletion)completion progressUpdate:(PKFetchProgressUpdate)update;

+ (BOOL)isPhotoCachedForURL:(NSURL *)url;

+ (void)setStoreLoggingLevel:(PKStoreLoggingLevel)level;

+ (void)setStoreSizeCapacityInBytes:(unsigned int)max;
+ (void)setStoreAgeThresholdInSeconds:(unsigned int)threshold;

+ (void)cleanStore;
+ (void)backgroundCleanStore;

+ (void)clearStore;

@end
