//
//  CustomerDataManager.m
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerDataManager.h"
#import "CustomerRecordViewController.h"
#import "CustomerListViewController.h"
#import "CountryListObject.h"
#import "BaseViewController.h"
#import "DesignViewController.h"
#import "CustomTemplateObject.h"
#import "CustomerProposalsViewController.h"
#import "CustomerProposalObject.h"
#import "ProposalViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BASE_URL  @"http://telesto.centralstationmarketing.com/"
#define AUTH_KEY @"authKey"
#define TOKEN_STRING @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH"

@implementation CustomerDataManager
@synthesize uploadedBuildingMediaArray;
@synthesize downloadedBuildingMediaArray;
@synthesize countryList,productObjectArray,templateObjectArray;
@synthesize dbHandler;

+ (CustomerDataManager *)sharedManager {
    static CustomerDataManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:NULL] init];
    });

    return _sharedManager;
}
-(id)init{
    if(self = [super init]){
        dbHandler = [[CoreDataHelper alloc] init];
    }
    return self;
}
- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}
-(void)createCustomerAfterEditing:(CustomerDetailInfoObject*)objects withCompletionBlock:(void (^)(void))completionBlock{
    
    if (uploadedBuildingMediaArray.count>0) {
        NSString *endPoint = @"edit_customer";
        NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               [NSNumber numberWithLong:objects.customerId],@"customerId",
                                               objects.customerFirstName,@"fName",
                                               objects.customerLastName,@"lName",
                                               objects.customerStreetAddress,@"address",
                                               objects.customerCityName,@"city",
                                               objects.customerStateName,@"state",
                                               objects.customerZipName,@"zip",
                                               objects.customerCountryName,@"countryId",
                                               objects.customerEmailAddress,@"email",
                                               objects.customerNotes,@"details",
                                               objects.customerAreaCode,@"area_code",
                                               objects.customerPhoneNumber,@"phone",
                                               objects.latitude,@"latitude",
                                               objects.longitude,@"longitude",
                                               [NSNumber numberWithBool:objects.smsReminder],@"smsNotify",
                                               [NSNumber numberWithBool:objects.emailNotification],@"emailNotify",
                                               [NSNumber numberWithLong:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue]],@"userId",
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
        completionBlock();
    }
    
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
                                               objects.customerAreaCode,@"area_code",
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
        completionBlock();
    }
}

-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController withAfterEditing:(BOOL)isEditing withCompletionBlock:(void (^)(BOOL succeeded))completionBlock{

    _baseController = rootController;
    BOOL isValidEmail = [Utility NSStringIsValidEmail:objects.customerEmailAddress];
    if (isValidEmail==YES) {
        if (isEditing == YES) {
            [self createCustomerAfterEditing:objects withCompletionBlock:^{
                completionBlock(YES);
            }];
        }
        else{
            [self createCustomer:objects withCompletionBlock:^{
                completionBlock(YES);
            }];
        }
        
    }
    else{
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uploading Error" message:@"Email is not correct!!!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction* ok = [UIAlertAction
//                             actionWithTitle:@"OK"
//                             style:UIAlertActionStyleDefault
//                             handler:^(UIAlertAction * action)
//                             {
//                                 [alert dismissViewControllerAnimated:YES completion:nil];
//                                 
//                             }];
//        [alert addAction:ok];
//        [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        completionBlock(NO);

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
-(void)loadCustomerBuildingImagesWithCustomerId:(NSString*)customerId withCompletionBlock:(void (^)(void))completionBlock{
    self.downloadedBuildingMediaArray = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"customer_details";
    NSString *customerBuildingImagesUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",customerId,@"customerId",nil];
    [manager POST:customerBuildingImagesUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:[[jsonDic valueForKey:@"files"] valueForKey:@"fileName"]];
        NSMutableArray *tempArr = [arr objectAtIndex:0];
        [self.downloadedBuildingMediaArray addObjectsFromArray:tempArr];
//        NSLog(@"%@",jsonDic);
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    
    }];
}
-(NSMutableArray*)getDownloadedBuildingMediaArray{
    return downloadedBuildingMediaArray;
}
-(NSMutableArray*)getCountryListArray{
    return countryList;
}
-(NSMutableArray*)loadCountryListWithCompletionBlock:(void (^)(void))completionBlock{

    countryList = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"country_list";
    NSString *countryListUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",nil];
    [manager POST:countryListUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&e];
        NSMutableDictionary *dic = [[jsonDic valueForKey:@"results"] valueForKey:@"country"];
        for (NSMutableDictionary *temp in dic) {
            CountryListObject *countryObject = [[CountryListObject alloc] init];
            countryObject.countryCode = [temp valueForKey:@"country_code"];
            countryObject.countryName = [temp valueForKey:@"country_name"];
            countryObject.countryId =   [[temp valueForKey:@"id"] intValue];
            [countryList addObject:countryObject];
        }
//        NSLog(@"%@",countryList);
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", @"CountryList not loaded".capitalizedString);
        NSLog(@"%@",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"CountryList not loaded" message:@"Press of country field" preferredStyle:UIAlertControllerStyleAlert];
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
-(void)getCustomerListWithBaseController:(CustomerListViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock{
    
    _customerList = [[NSMutableDictionary alloc] init];
    UIView *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"customer_list";
    NSString *customerListUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",[NSNumber numberWithLong:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue]],@"userId",nil];
    [manager POST:customerListUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // This is not called back on the main queue.
        // You are responsible for dispatching to the main queue for UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            NSLog(@"Uploading User FAQ and Use Template Name");
            [hud showAnimated:YES];

        });
    } success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        _customerList = [[jsonDic valueForKey:@"results"] valueForKey:@"customers"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            NSLog(@"Uploading User FAQ and Use Template Name");
            [hud hideAnimated:YES];
        });
//        NSLog(@"%@",_customerList);
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", @"Customer list not loaded".capitalizedString);
//        NSLog(@"%@",error);
        [hud hideAnimated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Customer not loaded" message:@"Reload?!!!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self getCustomerListWithBaseController:baseController withCompletionBlock:^(BOOL success){
                                     completionBlock(NO);
                                 }];
                             }];
        [alert addAction:ok];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:cancel];
        
        [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
        [cancel setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        completionBlock(NO);
    }];
}
-(NSMutableDictionary*)getCustomerData{
    return _customerList;
}
#pragma mark LOADING DEFAULT TEMPLATES IMAGES -

-(void)loadingDefaultTemplatesWithBaseController:(BaseViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",nil];
    NSString *endPoint = @"template_list";
    NSString *productUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    [manager POST:productUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        NSMutableArray *tempArr = [[jsonDic valueForKey:@"results"] valueForKey:@"templates"];
        templateObjectArray = [[NSMutableArray alloc] init];
        __block int count = (int)tempArr.count;
        for (NSMutableDictionary *dic in tempArr) {
            
            DefaultTemplateObject *defaultTempObj = [[DefaultTemplateObject alloc] init];
            defaultTempObj.templateId = [[dic valueForKey:@"templateId"] intValue];
            defaultTempObj.templateImage = [dic valueForKey:@"image"];
            defaultTempObj.templateName = [dic valueForKey:@"name"];
            
            [templateObjectArray addObject:defaultTempObj];
            [self downloadDefaultTemplateImageWithProductObject:defaultTempObj completionBlock:^(BOOL succeeded){
                count--;
                NSLog(@"Donwloaded template and Saved and count %d",count);
                if (count == 0) {
                    completionBlock(YES);
                }
            }];
        }
        //        NSLog(@"%@",tempArr);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(NO);
        NSLog(@"fail to connect and error %@",error);
    }];
}
- (void)downloadDefaultTemplateImageWithProductObject:(DefaultTemplateObject*)defaultTempObj completionBlock:(void (^)(BOOL succeeded))completionBlock{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",defaultTempObj.templateImage]];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:[NSURLRequest requestWithURL:imageUrl]
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if ( !error )
                                                           {
                                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                                               [self saveDefaultTemplateImage:image withImageName:defaultTempObj.templateName completionBlock:^(BOOL succeeded) {
                                                                   if (succeeded) {
                                                                       NSLog(@"Downloaded %@ and Saved to document directory",defaultTempObj.templateName);
                                                                       completionBlock(YES);
                                                                   }
                                                                   else{
                                                                       NSLog(@"Not Downloaded %@ and Saved to document directory",defaultTempObj.templateName);
                                                                   }
                                                               }];
                                                           } else{
                                                               completionBlock(NO);
                                                           }
                                                       }];
    [dataTask resume];
    
}
- (void)saveDefaultTemplateImage: (UIImage*)image withImageName:(NSString*)imageName completionBlock:(void (^)(BOOL succeeded))completionBlock{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/template"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/template/%@.png",imageName]];
    NSData* data = UIImagePNGRepresentation(image);
    BOOL saved = [data writeToFile:path options:NSASCIIStringEncoding error:&error];
    if (error) {
        NSLog(@"Fail: %@", [error localizedDescription]);
        completionBlock(NO);
    }
    if (saved == YES) {
        completionBlock(YES);
    }
}
- (NSString*)loadDefaultTemplateImageWithImageName:(NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"template/%@",imageName]];
//    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return path;
}
-(NSMutableArray*)getTemplateObjectArray{
    if (templateObjectArray.count==0) {
        templateObjectArray = [[NSMutableArray alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *myPath = [paths objectAtIndex:0];
        // if you save fies in a folder
        myPath = [myPath stringByAppendingPathComponent:[NSString stringWithFormat:@"template"]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // all files in the path
        NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
        
        // filter image files
        NSMutableArray *subpredicates = [NSMutableArray array];
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
        [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpg'"]];
        NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
        
        NSArray *onlyImages = [directoryContents filteredArrayUsingPredicate:filter];
        
        for (int i = 0; i < onlyImages.count; i++) {
            NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];

            DefaultTemplateObject *defaultTempObj = [[DefaultTemplateObject alloc] init];
            defaultTempObj.templateId = i;
            defaultTempObj.templateImage = imagePath;
            defaultTempObj.templateName = [onlyImages objectAtIndex:i];
            [templateObjectArray addObject:defaultTempObj];
        }
    }
    return templateObjectArray;
}
#pragma mark LOADING PRODUCT IMAGES -
-(void)loadingProductImagesWithBaseController:(UIViewController*)baseController withCompletionBlock:(void (^)(BOOL succeeded))completionBlock{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *aParametersDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:TOKEN_STRING,@"authKey",[NSNumber numberWithInt:1],@"categoryId",nil];
    NSString *endPoint = @"product_list";
    NSString *productUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,endPoint];
    [manager POST:productUrl parameters:aParametersDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
        NSError *e;
        NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
        NSMutableArray *tempArrProductArr = [[jsonDic valueForKey:@"results"] valueForKey:@"products"];
        productObjectArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *dics in tempArrProductArr) {
            NSString *imageUrl = [dics valueForKey:@"image"];
            
            NSURL *candidateURL = [NSURL URLWithString:imageUrl];
            // WARNING > "test" is an URL according to RFCs, being just a path
            // so you still should check scheme and all other NSURL attributes you need
            if (candidateURL && candidateURL.scheme && candidateURL.host) {
                [tempArr addObject:dics];
            }
        }
        
        __block int count = (int)tempArr.count;
        for (NSMutableDictionary *dic in tempArr) {
           /*
            description = "demo description";
            discount = 5;
            image = "http://telesto.centralstationmarketing.com/images/products/-SFA.png";
            name = "-SFA";
            productId = 1;
            unitPrice = "200.00";
            unitType = piece;
            */

                Product *productObj = [[Product alloc] init];
                productObj.productDescription = [dic valueForKey:@"description"];
                productObj.discount = [[dic valueForKey:@"discount"] floatValue];
                productObj.productImageUrl = [dic valueForKey:@"image"];
                productObj.productName = [dic valueForKey:@"name"];
                productObj.productId = [[dic valueForKey:@"productId"] intValue];
                productObj.productPrice = [[dic valueForKey:@"unitPrice"] floatValue];
                productObj.unitType = [dic valueForKey:@"unitType"];
                [productObjectArray addObject:productObj];
                
                [self downloadImageWithProductObject:productObj completionBlock:^(BOOL succeeded){
                    count--;
                    NSLog(@"Donwloaded and Saved and count %d",count);
                    if (count == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //Save in the document directory.
//                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                            NSString *documentsDirectory = [paths objectAtIndex:0];
//                            NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
//                            NSMutableArray *myObject=[NSMutableArray array];
//                            [myObject addObject:productObjectArray];
//                            AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//                            mainDelegate.sharedProductArray = productObjectArray;
//                            [NSKeyedArchiver archiveRootObject:myObject toFile:appFile];
                        });
                        completionBlock(YES);
                    }
                }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(NO);
    }];
}
- (void)downloadImageWithProductObject:(Product*)productObj completionBlock:(void (^)(BOOL succeeded))completionBlock{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",productObj.productImageUrl]];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:[NSURLRequest requestWithURL:imageUrl]
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if ( !error )
                                                           {
                                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                                               NSData *imageData = UIImagePNGRepresentation(image);

//                                                               [self saveImage:image withImageName:productObj.productName completionBlock:^(BOOL succeeded) {
//                                                                   if (succeeded) {
//                                                                       NSLog(@"Downloaded %@ and Saved to document directory",productObj.productName);
//                                                                       completionBlock(YES);
//                                                                   }
//                                                                   else{
//                                                                       NSLog(@"Not Downloaded %@ and Saved to document directory",productObj.productName);
//                                                                   }
//                                                               }];
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   
                                                                   [self saveProductDetailsInDatabaseWithProductObject:productObj withProductImage:imageData completionBlock:^(BOOL success){
                                                                       if (success == YES) {
                                                                           NSLog(@"save at database");
                                                                           completionBlock(YES);
                                                                       }
                                                                   }];
                                                               });
                                                               
                                                           } else{
                                                               completionBlock(NO);
                                                           }
                                                       }];
    [dataTask resume];

}

-(void)saveProductDetailsInDatabaseWithProductObject:(Product*)productObject withProductImage:(NSData*)data completionBlock:(void (^)(BOOL succeeded))completionBlock{
    
    NSManagedObjectContext  *localContext=[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPersistentStoreOpenError];//[dbHandler managedObjectContext];
    localContext.persistentStoreCoordinator = [dbHandler persistentStoreCoordinator];
    GrateProducts *grateProducts = [NSEntityDescription insertNewObjectForEntityForName:@"GrateProduct" inManagedObjectContext:localContext];
    grateProducts.productId = [NSNumber numberWithInt:productObject.productId];
    grateProducts.productName = productObject.productName;
    grateProducts.image = data;
    grateProducts.productPrice = productObject.productPrice;
    grateProducts.productDescription = productObject.productDescription;
    grateProducts.unitType = productObject.unitType;
    grateProducts.discount = productObject.discount;
    NSLog(@"Local Context: %@",localContext);
    NSError *error;
    if (![localContext save:&error]) {
        NSLog(@"Sorry");
        completionBlock(NO);
    }
    else{
        completionBlock(YES);
    }
}
- (void)saveImage: (UIImage*)image withImageName:(NSString*)imageName completionBlock:(void (^)(BOOL succeeded))completionBlock{
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/products"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/products/%@.png",imageName]];
    NSData* data = UIImagePNGRepresentation(image);
    BOOL saved = [data writeToFile:path options:NSASCIIStringEncoding error:&error];
    if (error) {
        NSLog(@"Fail: %@", [error localizedDescription]);
        completionBlock(NO);
    }
    if (saved == YES) {
        completionBlock(YES);
    }
}
- (NSString*)loadProductImageWithImageName:(NSString*)imageName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"products/%@",imageName]];
    //    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return path;
}
-(NSMutableArray*)getProductObjectArray{
    
    return productObjectArray;
}
//-(NSMutableArray*)loadingProductObjectArray{
//    if (productObjectArray.count==0) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
//        
//        productObjectArray = [[NSKeyedUnarchiver unarchiveObjectWithFile:appFile] objectAtIndex:0];
//    }
//    
//    return productObjectArray;
//}
#pragma mark -
#pragma mark SAVE USER DESIGN

-(void)saveUserTemplateName:(NSString*)templateName withUserFAQs:(NSMutableDictionary*)userFAQData withRootController:(DesignViewController*)baseController withCompletionBlock:(void(^)(BOOL success))completionBlock{
    //authKey, name, customer_id,faq
    __block int customTemplateId = 0;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"create_custom_template";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userFAQData
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          TOKEN_STRING,AUTH_KEY,
                                          templateName,@"name",
                                          [NSNumber numberWithInt:[[Utility sharedManager] getCurrentCustomerId]],@"customer_id",
                                          jsonString,@"faq",
                                          nil];
    NSLog(@"%@",aParameterDic);
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        // This is not called back on the main queue.
        // You are responsible for dispatching to the main queue for UI updates
        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            NSLog(@"Uploading User FAQ and Use Template Name");
        });
    }
          success:^(NSURLSessionDataTask *task, id responseObject) {
              NSError *e;
              NSLog(@"Response: %@", responseObject);
              NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);

              NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error: &e];
              NSLog(@"json Dic: %@",jsonDic);
              int success = [[jsonDic valueForKey:@"success"] intValue];
              if (success == 1) {
                  int templateId = [[[jsonDic valueForKey:@"customTemplate"] valueForKey:@"id"] intValue];
                  customTemplateId = templateId;
                  baseController.currentActiveTemplateID = customTemplateId;
                  NSLog(@"Customer ID: %d",customTemplateId);
                  completionBlock(YES);
              }
              else{
                  completionBlock(NO);
              }
          } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", error);
              completionBlock(NO);
          }];
}


-(void)saveUserDesignWithBaseController:(DesignViewController*)baseController withCustomTemplateID:(int)templateId withCustomTemplateName:(NSString*)templateName withProductArray:(NSMutableArray *)customerTemplateObjArr withCompletionBlock:(void (^)(BOOL success))completionBlock{
    NSLog(@"CustomerTemplateObj: %@",customerTemplateObjArr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"add_custom_template_products";
    __block int uploadedIndex = (int)customerTemplateObjArr.count;
    for (CustomProductView *view in customerTemplateObjArr) {
        /*
         authKey,custom_template_id,custom_template_name,product_name,product_price,product_x_coordinate,product_y_coordinate,product_width,product_height,product_images,imageCount
         */
        NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              TOKEN_STRING,AUTH_KEY,
                                              [NSNumber numberWithInt:templateId],@"custom_template_id",
                                              templateName,@"custom_template_name",
                                              [NSNumber numberWithInt:view.customTemplateProductUniqueId],@"custom_template_product_id",
                                              view.productObject.productName,@"product_name",
                                              [NSNumber numberWithInt:view.productObject.productId],@"product_id",
                                              [NSNumber numberWithFloat:view.productObject.productPrice],@"product_price",
                                              [NSNumber numberWithFloat:view.productObject.productXcoordinate],@"product_x_coordinate",
                                              [NSNumber numberWithFloat:view.productObject.productYcoordinate],@"product_y_coordinate",
                                              [NSNumber numberWithFloat:view.productObject.productWidth],@"product_width",
                                              [NSNumber numberWithFloat:view.productObject.productHeight],@"product_height",
                                              [NSNumber numberWithFloat:view.productObject.discount],@"discount",
                                              [NSNumber numberWithInt:view.productObject.imageCount],@"imageCount",
                                              nil];
        /*Check Editing proposal or New Proposal for server store*/
        if (baseController.isFromNewProposals == NO) {
            [aParameterDic setObject:@"update" forKey:@"type"];
        }
        NSLog(@"Dictionary of Parameter: %@",aParameterDic);
        [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            int i = 0;
            for(UIImage *eachImage in view.productObject.storedMediaArray)
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
                  NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);

                  uploadedIndex--;
                  NSLog(@"uploadedIndex: %d",uploadedIndex);
                  if (uploadedIndex == 0) {
                      completionBlock(YES);
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"Error: %@", error);
                  completionBlock(NO);
        }];
    }
}
-(void)saveCustomTemplatewithCustomTemplateID:(int)templateId withCustomTemplateName:(NSString*)templateName withScreenShot:(UIImage*)screenShot withDefaultTemplateId:(int)defaultTemplateId withCompletionBlock:(void (^)(BOOL success))completionBlock{
    /*
     end point : save_custom_template
     Method : post
     POST KEY : authKey,custom_template_id,custom_template_name, screenshot,
     Optional : default_template_id
     */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"save_custom_template";

    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                              TOKEN_STRING,AUTH_KEY,
                                              [NSNumber numberWithInt:templateId],@"custom_template_id",
                                              templateName,@"custom_template_name",
                                              [NSNumber numberWithInt:defaultTemplateId],@"default_template_id",
                                              nil];
        
    NSLog(@"Dictionary of Parameter: %@",aParameterDic);

    NSData* imageData = UIImagePNGRepresentation(screenShot);

    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"screenshot" fileName:@"screenshot.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO);
    }];
}
/*
 end point : custom_template_list
 Method : post
 POST KEY : authKey, customer_id,

 */
-(void)getCustomerProposalsWithCustomerId:(int)customerId withBaseController:(CustomerProposalsViewController*)baseController withCompletionBlock:(void (^)(BOOL success))completionBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"custom_template_list";
    
    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          TOKEN_STRING,AUTH_KEY,
                                          [NSNumber numberWithInt:customerId],@"customer_id",
                                          nil];
    
    NSLog(@"Dictionary of Parameter: %@",aParameterDic);
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
        _downloadedProposalObject = [[NSMutableArray alloc] init];
        NSMutableArray *dataDic = [[jsonData valueForKey:@"results"] valueForKey:@"templates"];
        if (dataDic.count>0) {
            for (NSMutableDictionary *dic in dataDic) {
                CustomerProposalObject *proposalListObject = [[CustomerProposalObject alloc] init];
                
                NSNumber* defaultTemplateId = [dic valueForKey:@"defaultTemplateId"];
                NSData *data = [[dic valueForKey:@"faq"] dataUsingEncoding:NSUTF8StringEncoding];
                id jsonOutput = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"%@",jsonOutput);
                NSMutableDictionary *faq = jsonOutput;
                NSString *screenshot = [dic valueForKey:@"screenshot"];
                NSString *name = [dic valueForKey:@"name"];
                NSNumber *templateId = [dic valueForKey:@"templateId"];
                NSLog(@"%@,%@,%@,%@,%@",defaultTemplateId,templateId,faq,screenshot,name);
                if (![defaultTemplateId isKindOfClass:[NSNull class]]) {
                    proposalListObject.defaultTemplateID = [defaultTemplateId longValue];
                }
                else{
                    proposalListObject.defaultTemplateID = 10000;
                    
                }
                proposalListObject.templateID = [templateId longValue];
                proposalListObject.faq = faq;
                proposalListObject.templateName = name;
                proposalListObject.screenShotImageName = screenshot;
                
                //Load Template products info
                [self loadCustomTemplateProductObjectsWithTemplateID:proposalListObject withCompletionBlock:^(BOOL success){
                    if (success == YES) {
                        completionBlock(YES);
                    }
                    else{
                        NSLog(@"NO DATA AVAILABLE");
                    }
                }];
            }
        }
        else{
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!!" message:@"No Proposal Available. Make Your Own Proposal" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:@"OK"
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     [alert dismissViewControllerAnimated:YES completion:nil];
//                                 }];
//            [alert addAction:ok];
//            
//            [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];            
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
            completionBlock(NO);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Proposal Not Loaded" message:@"Reload The Screen." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
        [alert addAction:ok];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancel];
        
        [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
        [cancel setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        completionBlock(NO);
    }];
}

-(void)loadCustomTemplateProductObjectsWithTemplateID:(CustomerProposalObject*)proposalObject withCompletionBlock:(void (^)(BOOL success))completionBlock{

    /*
     end point : custom_template_detail
     Method : post
     POST KEY : authKey,custom_template_id,
     */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"custom_template_detail";
    
    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          TOKEN_STRING,AUTH_KEY,
                                          [NSNumber numberWithLong:proposalObject.templateID],@"custom_template_id",
                                          nil];
    
    NSLog(@"Dictionary of Parameter: %@",aParameterDic);
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSError *error;
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        NSMutableDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
        NSMutableArray *dataDic = [jsonData valueForKey:@"customTemplateproducts"];
        NSMutableArray *productArr = [[NSMutableArray alloc] init];
        for (NSMutableDictionary *productDic in dataDic) {
            /*
             created = "2017-08-07 14:02:34";
             customTemplateId = 165;
             discount = 999999;
             id = 116;
             productHeight = 90;
             productId = 999999;
             productImages = "";
             productName = horizentalWall;
             productPrice = 999999;
             productWidth = 90;
             productXCoordinate = 100;
             productYCoordinate = 10;
             */
            
            
            CustomProductView *customView = [[CustomProductView alloc] init];
            customView.customTemplateProductUniqueId = [[productDic valueForKey:@"id"] intValue];
            customView.productObject.productId = [[productDic valueForKey:@"productId"] intValue];
            customView.productObject.productName = [productDic valueForKey:@"productName"];
            customView.productObject.productXcoordinate = [[productDic valueForKey:@"productXCoordinate"] floatValue];
            customView.productObject.productYcoordinate = [[productDic valueForKey:@"productYCoordinate"] floatValue];
            customView.productObject.productWidth = [[productDic valueForKey:@"productWidth"] floatValue];
            customView.productObject.productHeight = [[productDic valueForKey:@"productHeight"] floatValue];
            customView.productObject.productPrice = [[productDic valueForKey:@"productPrice"] floatValue];
            customView.productObject.discount = [[productDic valueForKey:@"discount"] floatValue];
            customView.productObject.storedMediaArray = [productDic valueForKey:@"productImages"];
            proposalObject.templateID = [[productDic valueForKey:@"customTemplateId"] intValue];
            [productArr addObject:customView];
        }
        NSLog(@"%@",productArr);

        proposalObject.productArray = productArr;
        [_downloadedProposalObject addObject:proposalObject];

        NSLog(@"%@",_downloadedProposalObject);
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO);
    }];
}
-(NSMutableArray *)getdownloadedProposalObject{
    return _downloadedProposalObject;
}
#pragma mark -
#pragma mark Reload Image While Editing -
//(int)btnTag withPath:(NSString*)path withMediaImageArray:(UIImage*)imageUrlArr
-(void)loadingStoredMediaWithFolderTag:(int)folderTag withPath:(NSString*)path withMediaURL:(id)imageURL withCompletionBlock:(void (^)(BOOL success))completionBlock{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    NSString *link = [NSString stringWithFormat:@"%@%@",BASE_URL,imageURL];
//    link = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"URL Hauwa: %@",link);
    [manager GET:[link stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             UIImage*downloadedImage = (UIImage *) responseObject;
             [self storeMediaWithPath:path withFolderTag:folderTag withImage:downloadedImage];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Load Image error - %@", [error description]);
         }];
}
-(void)storeMediaWithPath:(NSString*)path withFolderTag:(int)btnTag withImage:(UIImage*)downloadedImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d/%@.png",path,btnTag,downloadedImage]];
    NSLog(@"Saving folder directory: %@",savedImagePath);
    NSData *imageData = UIImagePNGRepresentation(downloadedImage);
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageData writeToFile:savedImagePath atomically:YES];
    });
}
#pragma mark Saving User Sign and ProposalPDF -

-(void)savingUserPDFWithBaseController:(ProposalViewController*)baseController withObjects:(NSMutableDictionary*)templateDictionary withCompletionBlock:(void (^)(BOOL success))completionBlock{

    NSLog(@"%@",templateDictionary);
    /*
     end point : save_custom_template
     Method : post
     POST KEY : authKey,custom_template_id,custom_template_name, screenshot,
     Optional : default_template_id
     */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"save_custom_template";
    
    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          TOKEN_STRING,AUTH_KEY,
                                          [templateDictionary valueForKey:@"templateId"],@"custom_template_id",
                                          [templateDictionary valueForKey:@"templateName"],@"custom_template_name",
                                          [templateDictionary valueForKey:@"pdfFile"],@"pdfFile",
                                          nil];
    
    NSLog(@"Dictionary of Parameter: %@",aParameterDic);
    UIImage *screenShot = [templateDictionary valueForKey:@"signature"];
    NSData* imageData = UIImagePNGRepresentation(screenShot);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"signature" fileName:@"screenshot.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO);
    }];

}
#pragma mark -
-(void)removeObjectFromProposalsWhileEditing:(CustomProductView*)productView templateId:(int)templateId templateName:(NSString*)templateName withCompletionBlock:(void (^)(BOOL success))completionBlock{
    /*
     end point : delete_custom_template_products
     Method : post
     POST KEY : authKey,custom_template_id,custom_template_name,product_id,
     */
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *endPoint = @"delete_custom_template_products";
    
    NSMutableDictionary *aParameterDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          TOKEN_STRING,AUTH_KEY,
                                          [NSNumber numberWithInt:templateId],@"custom_template_id",
                                          templateName,@"custom_template_name",
                                          [NSNumber numberWithInt:productView.productObject.productId],@"product_id",
                                          nil];
    
    NSLog(@"Dictionary of Parameter: %@",aParameterDic);
    [manager POST:[NSString stringWithFormat:@"%@%@",BASE_URL,endPoint] parameters:aParameterDic constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:4]);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        completionBlock(YES);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        completionBlock(NO);
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    }];
    
}

@end
