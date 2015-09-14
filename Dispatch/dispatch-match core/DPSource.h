//
//  DPSource
//  dispatch-match
//
//  Created by Izuchukwu Elechi on 9/13/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DPSource : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *twitterHandle;
@property (nonatomic, assign) BOOL twitterVerified;
@property (nonatomic, copy) NSString *sourceDescription;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *location;

@property (nonatomic, strong) NSURL *feedURL;
@property (nonatomic, strong) NSURL *siteURL;

@property (nonatomic, strong) NSURL *profilePhotoURL;
@property (nonatomic, strong) NSURL *backgroundPhotoURL;

@property (nonatomic, strong) UIColor *accentColor;

@end
