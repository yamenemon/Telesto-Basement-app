//
//  Utility.h
//  Telesto Basement App
//
//  Created by CSM on 12/6/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utility : NSObject

@property (assign,nonatomic) int customerId;
@property (strong,nonatomic) NSMutableArray *faqImageArray;
+ (Utility *)sharedManager;
+ (BOOL)isLoggedIn;
+ (void)loadLoginView;
+ (void)showMainViewController;
+ (void)showBaseViewController;
+ (void)showCustomerListViewController;

+ (void)checkForCookie;
+ (BOOL)iSUserLoggedIn;
+ (void)storeCookie;
+ (void)restoreCookie;
+ (void)removeCookie;

+ (void)authenticationRequired;

+ (void)showAlertWithTitle:(NSString*)title
               withMessage:(NSString*)message;

+ (UIImage*)imageWithImage:(UIImage*)sourceImage
             scaledToWidth:(float)i_width;

+(void)showConnectionErroMessage;
+(void)showJSONErroMessage;
+(UIColor*)colorWithHexString:(NSString*)hex;
+(BOOL)NSStringIsValidEmail:(NSString *)checkString;
+(void)showLocationError:(UIViewController*)controller;

-(int)getCurrentCustomerId;
-(void)setCurrentCustomerId:(int)customerIdentification;
- (UIImage*)loadScreenShotImageWithImageName:(NSString*)imageName;

-(void)storeImage:(NSMutableArray*)arr;
-(NSMutableArray*)getImageFromArr;
@end
