//
//  FeedlyKit.h
//  FeedlyKit
//
//  Created by Izuchukwu Elechi on 2/23/15.
//  Copyright (c) 2015 Izuchukwu Elechi. All rights reserved.
//

#ifndef FeedlyKit_FeedlyKit_h
#define FeedlyKit_FeedlyKit_h

#import "FKCloud.h"
#import "UAObfuscatedString.h"

//
// NXOAuth2 Abstraction
//

// Accounts Store

#define FKSharedAccountsStore [NXOAuth2AccountStore sharedStore]

// Notifications

#define FKAccountsDidChangeNotification NXOAuth2AccountStoreAccountsDidChangeNotification
#define FKDidFailToRequestAccessNotification NXOAuth2AccountStoreDidFailToRequestAccessNotification
#define FKRequestAccessErrorKey NXOAuth2AccountStoreErrorKey

#endif
