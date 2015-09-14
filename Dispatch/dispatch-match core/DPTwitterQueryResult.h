//
//  DPTwitterQueryResult.h
//  dispatch-match
//
//  Created by Izuchukwu Elechi on 9/13/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPTwitterQueryResult : NSObject

#pragma mark - query essentials

@property (nonatomic, copy) NSString *handle;
@property (nonatomic, copy) NSArray *URLs;

#pragma mark - metadata

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *twdescription;
@property (nonatomic, copy) NSDictionary *twdescriptionURLSet;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, strong) UIColor *accentColor;
@property (nonatomic, assign) BOOL verified;

@property (nonatomic, strong) NSURL *profilePhotoURL;
@property (nonatomic, strong) NSURL *backgroundPhotoURL;

@end
