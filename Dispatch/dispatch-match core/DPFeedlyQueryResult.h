//
//  DPFeedlyQueryResult.h
//  dispatch-match
//
//  Created by Izuchukwu Elechi on 9/13/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPFeedlyQueryResult : NSObject

#pragma mark - query essentials

@property (nonatomic, strong) NSURL *URL;

#pragma mark - metadata

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fldescription;
@property (nonatomic, copy) NSString *flcategory;
@property (nonatomic, strong) NSURL *feedURL;

@end
