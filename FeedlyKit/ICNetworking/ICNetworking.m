//
//  ICNetworking.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "ICNetworking.h"

#define concurrentDownloadCap 5
//  Defines the maximum number of concurrent download operations permitted

@interface ICNetworking()
@property (nonatomic) NSMutableArray *queue;
//  The queue of items to be downloaded

@property (nonatomic) NSMutableArray *inProgress;
//  The list of items currently being downloaded

@end

@implementation ICNetworking

- (id)init {
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
        _inProgress = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public

- (void)addQueuedItem:(ICNetworkingQueuedItem *)item {
    // If item exists in queue, do not download
    
    if ([self itemExistsInQueueWithURL:[item url]]) {
        NSLog(@"Item with URL %@ not added to queue: already in queue.", [[item url] absoluteString]);
    } else {
        // Not in queue, adds it
        
        [_queue addObject:item];
        [self beginDownload];
    }
}

- (void)addItemWithURL:(NSURL *)url toDownloadQueueWithDelegate:(id<ICNetworkingDelegate>)delegate {
    // If item exists in queue, do not download
    
    if ([self itemExistsInQueueWithURL:url]) {
        NSLog(@"Item with URL %@ not added to queue: already in queue.", [url absoluteString]);
    } else {
        // Not in queue, creates an ICNetworkingQueuedItem instance and adds it to the queue
        
        ICNetworkingQueuedItem *item = [[ICNetworkingQueuedItem alloc] init];
        [item setUrl:url];
        [item setDelegate:delegate];
        [_queue addObject:item];
        [self beginDownload];
    }
}

#pragma mark - Queueing

- (BOOL)itemExistsInQueueWithURL:(NSURL *)url {
    //  Checks if the request with this unique URL currently exists in the queue
    
    NSString *absString = [url absoluteString];
    
    for (ICNetworkingQueuedItem *item in _queue) {
        NSURL *itemURL = [item url];
        
        if ([[itemURL absoluteString] isEqualToString:absString]) {
            return true;
        }
    }
    
    return false;
}

#pragma mark - Downloading

- (void)beginDownload {
    //  Verifies a potential download against the concurrency cap
    
    if (![_inProgress count] || [_inProgress count] < concurrentDownloadCap) {
        [self newConnectionForDownload];
    }
}

- (void)newConnectionForDownload {
    //  Creates a new NSURLConnection and begins the downloading process asynchronously
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    ICNetworkingQueuedItem *item = [_queue firstObject];
    [_queue removeObject:[_queue firstObject]];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:[item request] delegate:self startImmediately:YES];
    
    [item setConnection:connection];
    [item setExpected:0];
    [item setProgress:0];
    
    [_inProgress addObject:item];
}

#pragma mark - NSURLConnection

- (ICNetworkingQueuedItem *)itemForConnection:(NSURLConnection *)connection {
    //  Retrieves the associated FICNeetworkingQueuedItem for a given NSURLConnection
    
    for (ICNetworkingQueuedItem *item in _inProgress) {
        if ([[item connection] isEqual:connection]) {
            return item;
        }
    }
    
    return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //  Delegate callback for NSURLConnection upon receipt of an initial response
    //  Used to properly intialize the ICNetworkingQueuedItem to prepare receipt of data
    
    ICNetworkingQueuedItem *item = [self itemForConnection:connection];
    
    if (!item) {
        NSLog(@"Note: Did receive response for untracked connection with URL: %@", [[[connection originalRequest] URL] absoluteString]);
        return;
    }
    
    [item setExpected:(NSUInteger)[response expectedContentLength]];
    [item setData:[[NSMutableData alloc] init]];
    if ([[item delegate] respondsToSelector:@selector(didUpdateProgressForItemAtURL:withProgress:)]) {
        [[item delegate] didUpdateProgressForItemAtURL:[item url] withProgress:((double)[item progress] / (double)[item expected])];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //  Delegate callback for NSURLConnection upon receipt of data
    //  The appropriate ICNetworkingQueuedItem is retrieved and the data is appended to it
    
    ICNetworkingQueuedItem *item = [self itemForConnection:connection];
    
    if (!item) {
        NSLog(@"Note: Did receive data for untracked connection with URL: %@", [[[connection originalRequest] URL] absoluteString]);
        return;
    }
    
    [[item data] appendData:data];
    [item setProgress:[data length]];
    if ([[item delegate] respondsToSelector:@selector(didUpdateProgressForItemAtURL:withProgress:)]) {
        [[item delegate] didUpdateProgressForItemAtURL:[item url] withProgress:((double)[item progress] / (double)[item expected])];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //  Delegate callback for NSURLConnection upon completion of a download
    //  Used to wrap up data retrieval, alert delegate, and continue to next item in queue
    
    ICNetworkingQueuedItem *item = [self itemForConnection:connection];
    
    if (!item) {
        NSLog(@"Note: Did receive finished-loading for untracked connection with URL: %@", [[[connection originalRequest] URL] absoluteString]);
        return;
    }
    
    [[item delegate] didFinishDownloadingItemAtURL:[item url] withSuccess:YES data:[item data]];
    [_inProgress removeObject:item];
    
    if (([_inProgress count] < concurrentDownloadCap) && [_queue count]) {
        // If items remain in queue, pop & start download
        
        [self beginDownload];
    } else {
        if (![_inProgress count]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //  Delegate callback for NSURLConnection for failed download
    //  Alert delegate and move on with queue
    
    ICNetworkingQueuedItem *item = [self itemForConnection:connection];
    
    if (!item) {
        NSLog(@"Note: Did receive finished-loading for untracked connection with URL: %@", [[[connection originalRequest] URL] absoluteString]);
        return;
    } else {
        NSLog(@"Failed [!]: Download for URL %@ did fail with error: %@", [[item url] absoluteString], [error description]);
    }
    
    [[item delegate] didFinishDownloadingItemAtURL:[item url] withSuccess:NO data:[item data]];
    [_inProgress removeObject:item];
    
    if (([_inProgress count] < concurrentDownloadCap) && [_queue count]) {
        // If items remain in queue, pop & start download
        
        [self beginDownload];
    } else {
        if (![_inProgress count]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

@end