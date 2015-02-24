//
//  ViewController.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *notification){
        NSError *error = [notification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        if (error) {
            NSLog(@"[!] Error Updating Accounts: %@", [error description]);
        } else {
            NSLog(@"Accounts Updated");
            NSLog(@"%@", [notification userInfo]);
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    FKCloud *feedlyCloud = [[FKCloud alloc] initWithClientID:@"sandbox" clientSecret:@"8LDQOW8KPYFPCQV2UL6J"];
    [feedlyCloud setDelegate:self];
    
    if (![[[NXOAuth2AccountStore sharedStore] accounts] count]) {
        NSLog(@"[!] No Accounts Found, Requesting Reauthentication");
        [feedlyCloud requestReauthentication];
    } else {
        NSLog(@"Retrieving Stored Accounts");
        NSLog(@"%@", [[NXOAuth2AccountStore sharedStore] accounts]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FKCloud Delegate

- (void)presentAuthenticationViewController:(FKAuthViewController *)authViewController {
    [self presentViewController:authViewController animated:YES completion:nil];
}

@end
