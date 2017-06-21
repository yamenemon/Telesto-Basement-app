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
-(void)saveCustomerData{

}
- (void)uploadMultipleImageInSingleRequest
{
    NSString *returnString;

    NSString *urlString; // an url where the request to be posted
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] initWithURL:url] ;

    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];


    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
}
-(NSString *) getHTTPBodyParamsFromDictionary: (NSDictionary *)params boundary:(NSString *)boundary
{
    NSMutableString *tempVal = [[NSMutableString alloc] init];
    for(NSString * key in params)
    {
        [tempVal appendFormat:@"\r\n--%@\r\n", boundary];
        [tempVal appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[params objectForKey:key]];
    }
    return [tempVal description];
}
-(void)createCustomer:(CustomerDetailInfoObject*)objects{

    NSString* tokenAsString = @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH";
    NSString *endPoint = @"create_customer";
    /*
     $customer->latitude = $req['latitude'];
     $customer->longitude = $req['longitude'];
     $customer->smsNotify = $req['smsNotify'];
     $customer->emailNotify = $req['emailNotify'];
     $customer->userId = $req['userId'];
     */

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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,endPoint]]];
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    request.timeoutInterval = 100000;
    NSMutableData *postbody = [NSMutableData data];
    NSString *postData = [self getHTTPBodyParamsFromDictionary:aParametersDic boundary:boundary];
    [postbody appendData:[postData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];

    if([objects.customerOtherImageDic count] > 0) {
        for (int i=0; i<objects.customerOtherImageDic.count; i++) {
            UIImage* image = [objects.customerOtherImageDic valueForKey:@"pp"];
            NSData *imageData = UIImagePNGRepresentation(image);
//            NSLog(@"Data :%@",imageData);
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%d\"\r\n", 1]] dataUsingEncoding:NSUTF8StringEncoding]];
            [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            [postbody appendData:[NSData dataWithData:imageData]];
            [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            [request setHTTPBody:postbody];

        }
    }
    [self sendRequest:request];
}
-(void)sendRequest:(NSURLRequest*)urlRequest{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];


    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error.description);

                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                               if (data) {
                                                                   BOOL isSuccessfull = [self parseJOSNLoginStatus:data];
                                                                   if (isSuccessfull == YES) {

                                                                   }
                                                                   else{
                                                                       NSLog(@"Not successful");
                                                                   }
//                                                                   [_baseController pop]
                                                               }
                                                               else{

                                                               }
                                                           }
                                                       }];
    [dataTask resume];
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error: &e];
    long loginStatus = [[jsonArray objectForKey:@"success"] longValue];
    return loginStatus;
}

-(void)validateObjects:(CustomerDetailInfoObject*)objects withRootController:(CustomerRecordViewController *)rootController{

    _baseController = rootController;
    BOOL isValidEmail = [Utility NSStringIsValidEmail:objects.customerEmailAddress];
    if (isValidEmail==YES) {
        [self createCustomer:objects];
    }

}
@end