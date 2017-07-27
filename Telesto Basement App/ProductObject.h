//
//  ProductObject.h
//  Telesto Basement App
//
//  Created by CSM on 5/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property (nonatomic, assign) int productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) float productXcoordinate;
@property (nonatomic, assign) float productYcoordinate;
@property (nonatomic, assign) float productWidth;
@property (nonatomic, assign) float productHeight;
@property (nonatomic, assign) float productPrice;
@property (nonatomic, assign) int imageCount;
@property (nonatomic, strong) NSMutableArray *storedMediaArray;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *unitType;
@property (assign, nonatomic) float discount;
@end
