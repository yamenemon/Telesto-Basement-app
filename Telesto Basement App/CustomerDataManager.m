//
//  CustomerDataManager.m
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerDataManager.h"
#import "CustomerRecordViewController.h"
#define BaseURL  @"http://telesto.centralstationmarketing.com/"

@implementation CustomerDataManager
+ (CustomerDataManager *)sharedManager {
    static CustomerDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}
-(void)createCustomer:(CustomerDetailInfoObject*)objects{

    NSString* tokenAsString = @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH";
    NSString *endPoint = @"create_customer";
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    objects.customerFirstName,@"fName",
                                    objects.customerLastName,@"lName",
                                    objects.customerStreetAddress,@"address",
                                    objects.customerCityName,@"city",
                                    objects.customerStateName,@"state",
                                    objects.customerZipName,@"zip",
                                    objects.customerCountryName,@"countryId",
                                    objects.customerEmailAddress,@"email",
                                    objects.customerNotes,@"details",
                                    objects.customerPhoneNumber,@"phone",
                                    [NSNumber numberWithLong:objects.latitude],@"latitude",
                                    [NSNumber numberWithLong:objects.longitude],@"longitude",
                                    [NSNumber numberWithBool:objects.smsReminder],@"smsNotify",
                                    [NSNumber numberWithBool:objects.emailNotification],@"emailNotify",
                                    [NSNumber numberWithLong:objects.customerId],@"userId",
                                    tokenAsString,@"authKey",
                                    nil];
    NSLog(@"Parameter: %@\n",aParametersDic);
    NSData *imageData;
    if([objects.customerOtherImageDic count] > 0) {
        for (int i=0; i<objects.customerOtherImageDic.count; i++) {
            UIImage* image = [objects.customerOtherImageDic valueForKey:@"pp"];
            imageData = UIImagePNGRepresentation(image);
            //            NSLog(@"Data :%@",imageData);
        }
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:[NSString stringWithFormat:@"%@%@",BaseURL,endPoint] parameters:aParametersDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"photo" fileName:@"profile_photo.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController{

    _baseController = rootController;
    BOOL isValidEmail = [Utility NSStringIsValidEmail:objects.customerEmailAddress];
    if (isValidEmail==YES) {
        [self createCustomer:objects];
    }
}
@end
