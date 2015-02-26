//
//  AppDelegate.m
//  Dispatch
//
//  Created by Izuchukwu Elechi on 2/25/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "AppDelegate.h"
#import "DWindowDispatch.h"

@interface AppDelegate ()

@property (nonatomic) DWindowDispatch *dispatch;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIViewController *homeViewController = [[UIViewController alloc] init];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:homeViewController.view.frame];
    [lbl setText:@"homevc"];
    [lbl setTextAlignment:NSTextAlignmentRight];
    [homeViewController.view addSubview:lbl];
    
    _dispatch = [[DWindowDispatch alloc] init];
    
    NSLog(@"control: %@", [[UIApplication sharedApplication] windows]);
    [_dispatch dispatchWindowWithViewController:(UIViewController<DWindowDispatchable> *)homeViewController];
    NSLog(@"after dispatch: %@", [[UIApplication sharedApplication] windows]);
    //[_dispatch recallWindow];
    //NSLog(@"after recall: %@", [[UIApplication sharedApplication] windows]);
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
