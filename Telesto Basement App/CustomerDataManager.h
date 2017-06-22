//
//  CustomerDataManager.h
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomerDetailInfoObject.h"
#import "Utility.h"
#import <AFNetworking.h>

@class CustomerRecordViewController;
@interface CustomerDataManager : NSObject
@property (strong,nonatomic) CustomerRecordViewController *baseController;
+ (CustomerDataManager *)sharedManager;
-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController*)rootController;
@end
