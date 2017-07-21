//
//  CustomTemplateObject.h
//  Telesto Basement App
//
//  Created by CSM on 7/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ProductObject;
@interface CustomTemplateObject : NSObject
//authKey, name, screenshot, customer_id,
@property (strong,nonatomic) NSString *authKey;
@property (strong,nonatomic) NSString *templateName;
@property (strong,nonatomic) UIImage *screenShot;
@property (assign,nonatomic) NSInteger customerId;
@property (strong,nonatomic) ProductObject *productObject;
@end
