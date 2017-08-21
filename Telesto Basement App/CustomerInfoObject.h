//
//  CustomerInfoObject.h
//  Telesto Basement App
//
//  Created by CSM on 12/21/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerInfoObject : NSObject
@property (nonatomic,strong) NSString *customerName;
@property (nonatomic,strong) NSString *scheduleDate;
@property (nonatomic,strong) NSString *customerAddress;
@property (assign,nonatomic) NSString* customerId;
@property (strong,nonatomic) NSString *customerFirstName;
@property (strong,nonatomic) NSString *customerLastName;
@property (strong,nonatomic) NSString *customerStreetAddress;
@property (strong,nonatomic) NSString *customerCityName;
@property (strong,nonatomic) NSString *customerStateName;
@property (strong,nonatomic) NSString *customerZipName;
@property (strong,nonatomic) NSString *customerCountryName;
@property (assign,nonatomic) BOOL emailNotification;
@property (strong,nonatomic) NSString *customerEmailAddress;
@property (assign,nonatomic) BOOL smsReminder;
@property (strong,nonatomic) NSString *customerPhoneNumber;
@property (strong,nonatomic) NSString *customerAreaCode;
@property (strong,nonatomic) NSString *customerNotes;
@property (strong,nonatomic) NSDictionary *customerOtherImageDic;
@property (strong,nonatomic) NSMutableArray *buildingImages;
@property (strong,nonatomic) NSString* latitude;
@property (strong,nonatomic) NSString* longitude;
@end
