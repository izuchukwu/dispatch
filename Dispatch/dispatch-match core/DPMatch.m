//
//  DPMatch.m
//  dispatch-match
//
//  Created by Izuchukwu Elechi on 9/13/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import "DPMatch.h"

#import "DPTwitterQueryResult.h"
#import "DPFeedlyQueryResult.h"
#import "DPSource.h"
#import "GTMNSString+HTML.h"

@interface DPMatch()

@property (nonatomic, strong) TWTRAPIClient *client;

@end

@implementation DPMatch

- (void)matchesWithQuery:(NSString *)query client:(TWTRAPIClient *)client completion:(void (^)(NSArray *results))completion {
    self.client = client;
    [self queryTwitterWithQuery:query completion:completion];
}

- (void)queryTwitterWithQuery:(NSString *)query completion:(void (^)(NSArray *results))completion {
    NSString *statusesShowEndpoint = @"https://api.twitter.com/1.1/users/search.json";
    NSDictionary *params = @{@"count":@"5", @"q":query};
    NSError *clientError;
    
    NSURLRequest *request = [self.client URLRequestWithMethod:@"GET" URL:statusesShowEndpoint parameters:params error:&clientError];
    
    if (request) {
        [self.client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                NSMutableArray *twresults = [[NSMutableArray alloc] init];
                
                for (NSDictionary *twresult in json) {
                    DPTwitterQueryResult *result = [[DPTwitterQueryResult alloc] init];
                    NSMutableArray *URLs = [[NSMutableArray alloc] init];
                    for (NSDictionary *twURL in twresult[@"entities"][@"description"][@"urls"]) {
                        NSURL *URL = [NSURL URLWithString:twURL[@"expanded_url"]];
                        [URLs addObject:URL];
                    }
                    for (NSDictionary *twURL in twresult[@"entities"][@"url"][@"urls"]) {
                        NSURL *URL = [NSURL URLWithString:twURL[@"expanded_url"]];
                        [URLs addObject:URL];
                    }
                    
                    result.handle = twresult[@"screen_name"];
                    result.URLs = URLs;
                    
                    result.name = twresult[@"name"];
                    result.location = twresult[@"location"];
                    
                    result.twdescription = twresult[@"description"];
                    result.twdescriptionURLSet = twresult[@"entities"][@"description"][@"urls"];
                    result.verified = [twresult[@"verified"] boolValue];
                    result.accentColor = [self colorFromHexString:twresult[@"profile_link_color"]];
                    result.profilePhotoURL = [NSURL URLWithString:[twresult[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""]];
                    result.backgroundPhotoURL = [NSURL URLWithString:twresult[@"profile_background_image_url_https"]];
                    [twresults addObject:result];
                }
                
                [self queryFeedlyWithQuery:query twitterResults:twresults completion:completion];
            }
            else {
                NSLog(@"Error: %@", connectionError);
            }
        }];
    }
    else {
        NSLog(@"Error: %@", clientError);
    }
}

- (void)queryFeedlyWithQuery:(NSString *)query twitterResults:(NSArray *)twresults completion:(void (^)(NSArray *results))completion {
    NSString *escapedQuery = [[query gtm_stringByEscapingForHTML] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *queryURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cloud.feedly.com/v3/search/feeds?query=%@", escapedQuery]];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:queryURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError *jsonError;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError][@"results"];
        
        NSMutableArray *flresults = [[NSMutableArray alloc] init];
        
        for (NSDictionary *flresult in json) {
            DPFeedlyQueryResult *result = [[DPFeedlyQueryResult alloc] init];
            result.URL = [NSURL URLWithString:flresult[@"website"]];
            result.name = flresult[@"title"];
            result.fldescription = flresult[@"description"];
            result.flcategory = [flresult[@"deliciousTags"] firstObject];
            result.feedURL = [NSURL URLWithString:[flresult[@"feedId"] stringByReplacingOccurrencesOfString:@"feed/" withString:@"" options:0 range:[flresult[@"feedId"] rangeOfString:@"feed/"]]];
            [flresults addObject:result];
        }
        
        [self matchWithTwitterResults:twresults feedlyResults:flresults completion:completion];
    }] resume];
}

- (void)matchWithTwitterResults:(NSArray *)twresults feedlyResults:(NSArray *)flresults completion:(void (^)(NSArray *results))completion {
    NSMutableArray *matchedHosts = [[NSMutableArray alloc] init];
    NSMutableArray *matches = [[NSMutableArray alloc] init];
    NSMutableArray *sources = [[NSMutableArray alloc] init];
    
    for (DPFeedlyQueryResult *flresult in flresults) {
        NSString *hostname = [[flresult.URL host] lowercaseString];
        if ([hostname hasPrefix:@"www."]) {
            hostname = [hostname stringByReplacingOccurrencesOfString:@"www." withString:@"" options:0 range:[hostname rangeOfString:@"www."]];
        }
        for (DPTwitterQueryResult *twresult in twresults) {
            for (NSURL *URL in twresult.URLs) {
                if (![matchedHosts containsObject:hostname] && [[[URL host] lowercaseString] isEqualToString:hostname]) {
                    // found
                    [matchedHosts addObject:hostname];
                    [matches addObject:@[flresult, twresult]];
                }
            }
        }
    }
    
    for (NSArray *match in matches) {
        DPFeedlyQueryResult *flresult = match[0];
        DPTwitterQueryResult *twresult = match[1];
        
        NSString *desc = twresult.twdescription;
        for (NSDictionary *URLset in twresult.twdescriptionURLSet) {
            desc = [desc stringByReplacingOccurrencesOfString:URLset[@"url"] withString:URLset[@"display_url"]];
        }
        
        DPSource *source = [[DPSource alloc] init];
        source.name = twresult.name;
        source.twitterHandle = twresult.handle;
        source.twitterVerified = twresult.verified;
        source.sourceDescription = desc;
        source.category = flresult.flcategory;
        source.location = twresult.location;
        source.feedURL = flresult.feedURL;
        source.siteURL = flresult.URL;
        source.profilePhotoURL = twresult.profilePhotoURL;
        source.backgroundPhotoURL = twresult.backgroundPhotoURL;
        source.accentColor = twresult.accentColor;
        
        [sources addObject:source];
    }
    
    completion(sources);
}

#pragma mark - Utility

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
