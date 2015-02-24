//
//  ICNetworkingQueuedItem.h
//  izuchukwu.co
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ICNetworkingCommon.h"

@class ICNetworking;

@protocol ICNetworkingDelegate <NSObject>

- (void)didUpdateProgressForItemAtURL:(NSURL *)url withProgress:(double)progress;
//  Delegate method called when progress has been made on an existing queued download

- (void)didFinishDownloadingItemAtURL:(NSURL *)url withSuccess:(BOOL)success data:(NSData *)data;
//  Delegate methods called upon completion of download in queue

@end

@interface ICNetworkingQueuedItem : NSObject

@property (nonatomic) NSURLRequest *request;

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *contentType;
@property (nonatomic) ICNetworkingHTTPMethod method;

@property (nonatomic) id<ICNetworkingDelegate> delegate;

@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) NSUInteger expected;
@property (nonatomic) NSUInteger progress;

@property (nonatomic) NSMutableData *data;

- (void)setOAuthStringWithPrimaryValue:(NSString *)primaryValue keyedValues:(NSDictionary *)keyedValues;
- (void)clearOAuth;

@end
