//
//  Product.h
//  Telesto Basement App
//
//  Created by CSM on 5/5/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (assign,nonatomic) int productId;
@property (strong,nonatomic) NSString *productName;
@property (strong,nonatomic) NSString *productImageName;
@property (strong,nonatomic) NSString *productImageUrl;
@property (assign,nonatomic) float productPrice;
@property (strong,nonatomic) NSString *productDescription;
@property (strong,nonatomic) NSString *unitType;
@property (assign,nonatomic) float discount;
@property (strong,nonatomic) NSData *imageData;
@end
