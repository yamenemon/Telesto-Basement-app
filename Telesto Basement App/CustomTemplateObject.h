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
@property (strong,nonatomic) NSString *authKey;
@property (assign,nonatomic) int customTemplateId;
@property (strong,nonatomic) NSString *customTemplateName;
@property (strong,nonatomic) UIImage *screenShot;
@property (assign,nonatomic) NSInteger customerId;
@property (strong,nonatomic) NSMutableArray *productObjectArray;
@end
//POST KEY : authKey,custom_template_id,custom_template_name,product_name,product_price,product_x_coordinate,product_y_coordinate,product_width,product_height,product_images,imageCount
//Optional : type. If send then value should be “update”
