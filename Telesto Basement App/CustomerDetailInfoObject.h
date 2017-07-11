//
//  CustomerDetailInfoObject.h
//  Telesto Basement App
//
//  Created by Emon on 6/16/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomerDetailInfoObject : NSObject
@property (assign,nonatomic) long customerId;
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
@property (strong,nonatomic) NSString *customerNotes;
//@property (strong,nonatomic) UIImage *customerProfileImage;
@property (strong,nonatomic) NSDictionary *customerOtherImageDic;
@property (strong,nonatomic) NSMutableArray *buildingImages;
@property (strong,nonatomic) NSString* latitude;
@property (strong,nonatomic) NSString* longitude;
@end
