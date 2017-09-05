//
//  GrateProducts.h
//  Telesto Basement App
//
//  Created by CSM on 9/5/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface GrateProducts : NSManagedObject
@property (assign,nonatomic) NSNumber* productId;
@property (strong,nonatomic) NSString *productName;
@property (strong,nonatomic) NSData *productImage;
@property (assign,nonatomic) float productPrice;
@property (strong,nonatomic) NSString *productDescription;
@property (strong,nonatomic) NSString *unitType;
@property (assign,nonatomic) float discount;
@end
