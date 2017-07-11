//
//  CustomerDataManager.m
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerDataManager.h"
#import "CustomerRecordViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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

    if (uploadedBuildingMediaArray.count>0) {
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
                                               objects.latitude,@"latitude",
                                               objects.longitude,@"longitude",
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
            }
        }
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParametersDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:@"photo" fileName:@"profile_photo.jpg" mimeType:@"image/jpg"];
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [_baseController.hud hideAnimated:YES];
            [_baseController rootControllerBack];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@", error);
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [_baseController.hud hideAnimated:YES];
        }];
        
        
        completionBlock();
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Upload Error" message:@"Upload minimum One building image" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController withCompletionBlock:(void (^)(void))completionBlock{

    _baseController = rootController;
    BOOL isValidEmail = [Utility NSStringIsValidEmail:objects.customerEmailAddress];
    if (isValidEmail==YES) {
        [self createCustomer:objects withCompletionBlock:^{
            completionBlock();
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

        for (int i = 0; i<fileType.count; i++) {
            [uploadedBuildingMediaArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[file objectAtIndex:i]],[NSString stringWithFormat:@"%@",[fileType objectAtIndex:i]], nil]];
        }
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
-(NSMutableArray*)loadCustomerListWithCompletionBlock:(void (^)(void))completionBlock{

    NSMutableArray *countryList = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"country_list";
    NSString *countryListUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",nil];
    [manager POST:countryListUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        NSLog(@"%@",jsonDic);
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", @"CountryList not loaded".capitalizedString);
        NSLog(@"%@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CountryList not loaded" message:@"Press on country field to load the country list." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        completionBlock();
    }];
    return countryList;

}
@end
