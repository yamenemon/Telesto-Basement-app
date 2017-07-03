//
//  CustomerDataManager.m
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerDataManager.h"
#import "CustomerRecordViewController.h"
#define BASE_URL  @"http://telesto.centralstationmarketing.com/"
#define TOKEN_STRING @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH"

@implementation CustomerDataManager
@synthesize uploadedBuildingMediaArray;

+ (CustomerDataManager *)sharedManager {
    static CustomerDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });

    return _sharedManager;
}
-(void)createCustomer:(CustomerDetailInfoObject*)objects withCompletionBlock:(void (^)(void))completionBlock{

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
                                    [NSNumber numberWithFloat:objects.latitude],@"latitude",
                                    [NSNumber numberWithFloat:objects.longitude],@"longitude",
                                    [NSNumber numberWithBool:objects.smsReminder],@"smsNotify",
                                    [NSNumber numberWithBool:objects.emailNotification],@"emailNotify",
                                    [NSNumber numberWithLong:objects.customerId],@"userId",
                                    TOKEN_STRING,@"authKey",
                                    uploadedBuildingMediaArray,@"buildingImages",
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
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParametersDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileData:imageData name:@"photo" fileName:@"profile_photo.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [_baseController.hud hideAnimated:YES];
    
    completionBlock();
}

-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController withCompletionBlock:(void (^)(void))completionBlock{

    _baseController = rootController;
    BOOL isValidEmail = [Utility NSStringIsValidEmail:objects.customerEmailAddress];
    if (isValidEmail==YES) {
        [self createCustomer:objects withCompletionBlock:^{
            completionBlock();
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
}
-(void)uploadBuildingMediaImagesArray:(NSMutableArray*)imageArray withController:(CustomerRecordViewController*)rootController withCompletion:(void (^)(void))completionBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"upload_customer_file";
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",[NSNumber numberWithLong:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue]],@"userId",[NSNumber numberWithInt:1],@"fileType",[NSNumber numberWithUnsignedInteger:imageArray.count],@"imageCount",nil];
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParametersDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        int i = 0;
        for(UIImage *eachImage in imageArray)
        {
            NSData *imageData = UIImagePNGRepresentation(eachImage);
            [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i] fileName:[NSString stringWithFormat:@"file%d.jpg",i ] mimeType:@"image/jpg"];
            i++;
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // This is not called back on the main queue.
        // You are responsible for dispatching to the main queue for UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            NSLog(@"Uploading Image");
        });
    }
    success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSError *e = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        NSLog(@"%@",jsonDic);
        NSMutableDictionary *dataDic = [jsonDic valueForKey:@"data"];
        NSMutableArray *file = [dataDic valueForKey:@"file"];
        NSMutableArray *fileType = [dataDic valueForKey:@"fileType"];
        uploadedBuildingMediaArray = [[NSMutableArray alloc] init];

        NSMutableArray *imageArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<fileType.count; i++) {
            [imageArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[file objectAtIndex:i]],[NSString stringWithFormat:@"%@",[fileType objectAtIndex:i]], nil]];
        }
        [uploadedBuildingMediaArray addObject:imageArray];
//        NSLog(@"Image Arr: %@\n",imageArray);
        NSLog(@"responseArray Arr: %@",uploadedBuildingMediaArray);
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock();
    }];
}
-(NSMutableArray*)uploadedBuildingMediaArray{
    return uploadedBuildingMediaArray;
}
@end
