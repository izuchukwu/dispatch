//
//  PKPhotoStore.m
//  PhotoKit
//
//  Created by Izuchukwu Elechi on 7/17/14.
//  Copyright (c) 2014 Izuchukwu Elechi. All rights reserved.
//

#import "PKPhotoStore.h"
#import "SDWebImageManager.h"

@implementation PKPhotoStore

+ (void)initialize {
    // Default Max Size & Age Threshold
    // 75 MB & 1 day
    
    unsigned int defaultMaxAgeThresholdInSeconds = 24*60*60;
    unsigned int defaultMaxCacheSizeInBytes = 75*1000000;
    
    [self setStoreAgeThresholdInSeconds:defaultMaxAgeThresholdInSeconds];
    [self setStoreSizeCapacityInBytes:defaultMaxCacheSizeInBytes];
    
    [self setStoreLoggingLevel:PKStoreLoggingLevelDont];
}

+ (void)getPhotoForURL:(NSURL *)url withPriority:(PKFetchPriority)priority completion:(PKFetchCompletion)completion {
    [self getPhotoForURL:url withPriority:priority completion:completion progressUpdate:nil];
}

+ (void)getPhotoForURL:(NSURL *)url withPriority:(PKFetchPriority)priority completion:(PKFetchCompletion)completion progressUpdate:(PKFetchProgressUpdate)update {
    [[SDWebImageManager sharedManager] downloadImageWithURL:url options:((priority == PKFetchPrioritySnappy) ? SDWebImageHighPriority : 0) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float progress = (float)receivedSize / (float)expectedSize;
        update(progress);
    } completed:^(NSObject *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (completion && finished) {
            completion(image, (image ? isFLGIF(image) : NO));
        }
    }];
}

+ (BOOL)isPhotoCachedForURL:(NSURL *)url {
    return [[SDWebImageManager sharedManager] cachedImageExistsForURL:url];
}

+ (void)setStoreLoggingLevel:(PKStoreLoggingLevel)level {
    switch (level) {
        case PKStoreLoggingLevelAllYouGot:
            [[SDImageCache sharedImageCache] setShouldPrintCacheStatusVerbose:YES];
            
        case PKStoreLoggingLevelHereAndThere:
            [[SDImageCache sharedImageCache] setShouldPrintCacheStatus:YES];
            break;
            
        case PKStoreLoggingLevelDont:
        default:
            [[SDImageCache sharedImageCache] setShouldPrintCacheStatusVerbose:NO];
            [[SDImageCache sharedImageCache] setShouldPrintCacheStatus:NO];
            break;
    }
}

+ (void)setStoreSizeCapacityInBytes:(unsigned int)max{
    [[SDImageCache sharedImageCache] setMaxCacheSize:max];
}

+ (void)setStoreAgeThresholdInSeconds:(unsigned int)threshold{
    [[SDImageCache sharedImageCache] setMaxCacheAge:threshold];
}

+ (void)cleanStore {
    [[SDImageCache sharedImageCache] cleanDisk];
}

+ (void)backgroundCleanStore
{
    [[SDImageCache sharedImageCache] backgroundCleanDisk];
}

+ (void)clearStore {
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
