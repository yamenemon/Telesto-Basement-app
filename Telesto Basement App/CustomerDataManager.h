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
#import "Product.h"
#import "DefaultTemplateObject.h"

@class CustomerRecordViewController;
@class CustomerListViewController;
@class CountryListObject;
@class BaseViewController;
@class DesignViewController;
@class CustomTemplateObject;
@class CustomerProposalsViewController;
@class CustomerProposalObject;
@class ProposalViewController;

@interface CustomerDataManager : NSObject
@property (strong,nonatomic) NSMutableArray *templateObjectArray;
@property (strong,nonatomic) NSMutableArray *productObjectArray;
@property (strong,nonatomic) NSMutableArray *productsArray;
@property (strong,nonatomic) NSMutableArray *countryList;
@property (strong,nonatomic) NSMutableDictionary *customerList;
@property (strong,nonatomic) NSMutableArray *uploadedBuildingMediaArray;
@property (strong,nonatomic) NSMutableArray *downloadedBuildingMediaArray;
@property (strong,nonatomic) NSMutableArray *downloadedProposalObject;
@property (strong,nonatomic) CustomerRecordViewController *baseController;

+ (CustomerDataManager *)sharedManager;
- (BOOL)connected;
-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController withCompletionBlock:(void (^)(void))completionBlock;
-(void)uploadBuildingMediaImagesArray:(NSMutableArray*)imageArray withController:(CustomerRecordViewController*)rootController withCompletion:(void (^)(void))completionBlock;
-(NSMutableArray*)uploadedBuildingMediaArray;
-(NSMutableDictionary*)getCustomerData;
-(NSMutableArray*)getDownloadedBuildingMediaArray;
-(NSMutableArray*)getCountryListArray;
-(NSMutableArray*)getTemplateObjectArray;
-(NSMutableArray*)getProductObjectArray;
-(NSMutableArray*)loadingProductObjectArray;
-(NSMutableArray*)getdownloadedProposalObject;
-(NSMutableArray*)loadCountryListWithCompletionBlock:(void (^)(void))completionBlock;
-(void)getCustomerListWithBaseController:(CustomerListViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock;
-(void)loadCustomerBuildingImagesWithCustomerId:(NSString*)customerId withCompletionBlock:(void (^)(void))completionBlock;
-(void)loadingProductImagesWithBaseController:(BaseViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock;
-(void)loadingDefaultTemplatesWithBaseController:(BaseViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock;

- (NSString*)loadDefaultTemplateImageWithImageName:(NSString*)imageName;
- (NSString*)loadProductImageWithImageName:(NSString*)imageName;

-(void)saveUserTemplateName:(NSString*)templateName withUserFAQs:(NSMutableDictionary*)userFAQData withRootController:(DesignViewController*)baseController withCompletionBlock:(void(^)(BOOL success))completionBlock;
-(void)saveUserDesignWithBaseController:(DesignViewController*)baseController withCustomTemplateID:(int)templateId withCustomTemplateName:(NSString*)templateName withProductArray:(NSMutableArray *)customerTemplateObjArr withCompletionBlock:(void (^)(BOOL success))completionBlock;
-(void)saveCustomTemplatewithCustomTemplateID:(int)templateId withCustomTemplateName:(NSString*)templateName withScreenShot:(UIImage*)screenShot withDefaultTemplateId:(int)defaultTemplateId withCompletionBlock:(void (^)(BOOL success))completionBlock;


-(void)getCustomerProposalsWithCustomerId:(int)customerId withBaseController:(CustomerProposalsViewController*)baseController withCompletionBlock:(void (^)(BOOL success))completionBlock;

-(void)loadingStoredMediaWithFolderTag:(int)folderTag withPath:(NSString*)path withMediaURL:(id)imageURL withCompletionBlock:(void (^)(BOOL success))completionBlock;

-(void)savingUserPDFWithBaseController:(ProposalViewController*)baseController withObjects:(NSMutableDictionary*)templateDictionary withCompletionBlock:(void (^)(BOOL success))completionBlock;
@end
