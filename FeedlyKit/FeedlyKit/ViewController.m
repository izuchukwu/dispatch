//
//  ViewController.m
//  (
//
//  Created by Izuchukwu Elechi on 2/24/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) FKCloud *feedlyCloud;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *notification){
        NSLog(@"Accounts Updated");
        NSLog(@"%@", [notification userInfo]);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore] queue:nil usingBlock:^(NSNotification *notification){
        NSError *error = [notification.userInfo objectForKey:NXOAuth2AccountStoreErrorKey];
        NSLog(@"[!] Error Updating Accounts: %@", [error description]);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![[[NXOAuth2AccountStore sharedStore] accounts] count]) {
        NSLog(@"[!] No Accounts Found, Requesting Reauthentication");
        _feedlyCloud = [[FKCloud alloc] initWithClientID:@"sandbox" clientSecret:Obfuscate._8.L.D.Q.O.W._8.K.P.Y.F.P.C.Q.V._2.U.L._6.J account:nil];
        [_feedlyCloud setDelegate:self];
        [_feedlyCloud requestReauthentication];
    } else {
        NSLog(@"Retrieving Stored Accounts");
        NSLog(@"%@", [[NXOAuth2AccountStore sharedStore] accounts]);
        _feedlyCloud = [[FKCloud alloc] initWithClientID:@"sandbox" clientSecret:Obfuscate._8.L.D.Q.O.W._8.K.P.Y.F.P.C.Q.V._2.U.L._6.J account:[[[NXOAuth2AccountStore sharedStore] accounts] firstObject]];
        [_feedlyCloud setDelegate:self];
    }
    
    UITapGestureRecognizer *tapd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [self.view addGestureRecognizer:tapd];
}

- (void)tapped {
    [_feedlyCloud fetchCategoriesWithRefresh:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FKCloud Delegate

- (void)didFetchArticles:(NSArray *)articles forStreamable:(id<FKStreamable>)streamable {
    NSLog(@"articles: %@", articles);
}

- (void)didFetchCategories:(NSArray *)categories {
    NSLog(@"categories: %@", categories);
    [_feedlyCloud fetchArticlesForStreamable:[categories firstObject] withPaginationID:nil shouldRefresh:NO];
}

- (void)feedlyAuthenticationDidCompleteWithSuccess:(BOOL)success {
    NSLog(@"Authentication %@", (success ? @"Successful" : @"Failed"));
}

- (void)presentAuthenticationViewController:(FKAuthViewController *)authViewController {
    [self presentViewController:authViewController animated:YES completion:nil];
}

@end
