//
//  ProductObject.h
//  Telesto Basement App
//
//  Created by CSM on 5/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) int productId;
@property (nonatomic, assign) int staticId;
@property (nonatomic, assign) float productXcoordinate;
@property (nonatomic, assign) float productYcoordinate;
@property (nonatomic, assign) float productWidth;
@property (nonatomic, assign) float productHeight;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, assign) float productQuantity;
@property (nonatomic, assign) float productUnitPrice;
@property (nonatomic, strong) NSString *productUnitType;
@property (nonatomic, assign) float productDiscount;
@property (nonatomic, strong) NSMutableArray *storedMediaArray;


@end
