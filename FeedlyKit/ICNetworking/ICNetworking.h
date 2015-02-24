//
//  ICNetworking.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ICNetworkingQueuedItem.h"

@interface ICNetworking : NSObject<NSURLConnectionDataDelegate>

- (void)addQueuedItem:(ICNetworkingQueuedItem *)item;
- (void)addItemWithURL:(NSURL *)url toDownloadQueueWithDelegate:(id<ICNetworkingDelegate>)delegate;
//  Adds an item to the download queue, along with the delegate for that particular item

@end
