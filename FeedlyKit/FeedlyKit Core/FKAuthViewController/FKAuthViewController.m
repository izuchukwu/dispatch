//
//  FKAuthViewController.m
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "FKAuthViewController.h"

@interface FKAuthViewController ()

@property (nonatomic) NSURLRequest *request;
@property (nonatomic) NSString *redirectPrefix;

@property (nonatomic) UIWebView *webView;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation FKAuthViewController

- (id)initWithAuthRequest:(NSURLRequest *)request redirectPrefix:(NSString *)redirectPrefix {
    self = [super init];
    if (self) {
        _request = request;
        _redirectPrefix = redirectPrefix;
    }
    return self;
}

#pragma mark - View

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"Requesting Authentication with URL: %@", [_request URL]);
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    [_webView loadRequest:_request];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
    [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setAlpha:0.0];
    [self.view addSubview:_activityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForCompletion {
    [UIView animateWithDuration:0.25 animations:^{
        [_webView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [_activityIndicatorView startAnimating];
        
        [UIView animateWithDuration:0.25 animations:^{
            [_activityIndicatorView setAlpha:1.0];
        }];
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public

- (void)authenticationStepDidComplete {
    [self dismiss];
}

#pragma mark - Web View Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[[request URL] absoluteString] hasPrefix:_redirectPrefix]) {
        [_delegate authViewController:self didReturnWithRedirectURL:[request URL]];
        [self prepareForCompletion];
        return NO;
    } else {
        return YES;
    }
}

@end
