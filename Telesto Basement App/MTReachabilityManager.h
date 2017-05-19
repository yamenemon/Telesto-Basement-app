//
//  MTReachabilityManager.h
//  GoLogo
//
//  Created by CSM on 4/6/17.
//  Copyright © 2017 CSM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface MTReachabilityManager : NSObject
@property Reachability *reachability;
+ (MTReachabilityManager *)sharedManager;
#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable;
+ (BOOL)isUnreachable;
+ (BOOL)isReachableViaWWAN;
+ (BOOL)isReachableViaWiFi;
@end
