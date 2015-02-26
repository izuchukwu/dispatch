//
//  DWindowDispatch.m
//  Dispatch
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "DWindowDispatch.h"

#define shouldDispatchBackgroundTester 0

@interface DWindowDispatch ()

@property (nonatomic) NSMutableArray *dispatchedWindows;
@property (nonatomic) int dispatchedCount;

@end

@implementation DWindowDispatch

- (id)init {
    self = [super init];
    if (self) {
        _dispatchedWindows = [[NSMutableArray alloc] init];
        _dispatchedCount = 0;
        
        for (int i = 0; i < 1; i++) {
            UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            [window setBackgroundColor:[UIColor clearColor]];
            [window setHidden:YES];
            [_dispatchedWindows addObject:window];
        }
    }
    return self;
}

#pragma mark - Dispatching

- (void)dispatchWindowWithViewController:(UIViewController<DWindowDispatchable> *)viewController {
    UIWindow *window = [_dispatchedWindows objectAtIndex:_dispatchedCount];
    
    [window setRootViewController:viewController];
    [window setHidden:NO];
    
    if ([viewController respondsToSelector:@selector(didDispatch)]) {
        [viewController didDispatch];
    }
}

- (void)recallWindow {
    [[_dispatchedWindows objectAtIndex:_dispatchedCount] setHidden:YES];
    _dispatchedCount++;
}

#pragma mark - Background

- (DBackgroundViewController *)backgroundViewController {
    return (DBackgroundViewController *)[[[DWindowDispatch windowHeirarchy] firstObject] rootViewController];
}

#pragma mark - Utils (Private)

+ (NSArray *)windowHeirarchy {
    return [[UIApplication sharedApplication] windows];
}

@end
