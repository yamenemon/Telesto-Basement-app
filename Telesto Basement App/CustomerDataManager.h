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
#import <AFURLRequestSerialization.h>

@class CustomerRecordViewController;
@class CustomerListViewController;
@class CountryListObject;

@interface CustomerDataManager : NSObject
@property (strong,nonatomic) NSMutableArray *countryList;
@property (strong,nonatomic) NSMutableDictionary *customerList;
@property (strong,nonatomic) NSMutableArray *uploadedBuildingMediaArray;
@property (strong,nonatomic) NSMutableArray *downloadedBuildingMediaArray;
@property (strong,nonatomic) CustomerRecordViewController *baseController;
+ (CustomerDataManager *)sharedManager;
-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController withCompletionBlock:(void (^)(void))completionBlock;
-(void)uploadBuildingMediaImagesArray:(NSMutableArray*)imageArray withController:(CustomerRecordViewController*)rootController withCompletion:(void (^)(void))completionBlock;
-(NSMutableArray*)uploadedBuildingMediaArray;
-(NSMutableDictionary*)getCustomerData;
-(NSMutableArray*)getDownloadedBuildingMediaArray;
-(NSMutableArray*)getCountryListArray;
-(NSMutableArray*)loadCountryListWithCompletionBlock:(void (^)(void))completionBlock;
-(void)getCustomerListWithBaseController:(CustomerListViewController*)baseController withCompletionBlock:(void (^)(void))completionBlock;
-(void)loadCustomerBuildingImagesWithCustomerId:(NSString*)customerId withCompletionBlock:(void (^)(void))completionBlock;
@end
