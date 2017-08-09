//
//  Utility.m
//  Telesto Basement App
//
//  Created by CSM on 12/6/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "Utility.h"
#define DOMAIN_NAME @"jupiter.centralstationmarketing.com"

@implementation Utility
@synthesize customerId,faqImageArray;

+ (Utility *)sharedManager {
    static Utility *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}
+ (void)loadLoginView {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
}
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
} 

+ (void)showMainViewController {
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
}


+ (void)showBaseViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
}
+ (void)showCustomerListViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
}
+ (void)checkForCookie {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"Domains %@", [cookie domain]);
        if([[cookie domain] isEqualToString:DOMAIN_NAME]) {
            [self showMainViewController];
        }
    }
}
+ (BOOL)iSUserLoggedIn {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"Domains %@", [cookie domain]);
        if([[cookie domain] isEqualToString:DOMAIN_NAME]) {
            return TRUE;
        }
    }
    return FALSE;
}
+ (BOOL)isLoggedIn{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
}
+ (void)storeCookie {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        NSLog(@"Cookie Domain: %@", [cookie domain]);
        if([[cookie domain] isEqualToString:DOMAIN_NAME]) {
            NSData *cookieData = [NSKeyedArchiver archivedDataWithRootObject:cookie];
            [[NSUserDefaults standardUserDefaults] setValue:cookieData forKey:DOMAIN_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}
+ (void)restoreCookie {
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:DOMAIN_NAME];
    @try {
        if(cookiesdata) {
            NSHTTPCookie *cookie = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Error there was an exception.");
    }
    
}
+ (void)removeCookie {
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:DOMAIN_NAME]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DOMAIN_NAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}
+ (void)authenticationRequired {
    [self removeCookie];
    [self loadLoginView];
}
+(UIImage*)imageWithImage:(UIImage*)sourceImage
             scaledToWidth:(float)i_width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(void)showConnectionErroMessage {
    [self showAlertWithTitle:@"Error"
                          withMessage:@"Error while getting data from server, please try later"];
}
+(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(void)showJSONErroMessage {
    [self showAlertWithTitle:@"Error"
                          withMessage:@"Error parsing data from server, please try later."];
}
+(void)showLocationError:(UIViewController*)controller{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Location Error!!!"
                                  message:@"Failed to Get Your Location"
                                  preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Called when user taps outside
    }]];
    [controller presentViewController:alert animated:YES completion:nil];

}
-(int)getCurrentCustomerId{
    return customerId;
}
-(void)setCurrentCustomerId:(int)customerIdentification{
    customerId = customerIdentification;
}
- (UIImage*)loadScreenShotImageWithImageName:(NSString*)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@%@.jpg",imageName,imageName,@"ScreenShot"]];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}
-(void)storeImage:(NSMutableArray*)arr{
    faqImageArray = arr;
}
-(NSMutableArray*)getImageFromArr{
    return faqImageArray;
}
@end
