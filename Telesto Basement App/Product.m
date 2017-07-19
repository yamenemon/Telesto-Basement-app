//
//  Product.m
//  Telesto Basement App
//
//  Created by CSM on 5/5/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize productId;
@synthesize productName;
@synthesize productImageName;
@synthesize productImageUrl;
@synthesize productPrice;
@synthesize productDescription;
@synthesize unitType;
@synthesize discount;

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:[NSNumber numberWithInt:self.productId] forKey:@"productId"];
    [encoder encodeObject:self.productName forKey:@"productName"];
    [encoder encodeObject:self.productImageName forKey:@"productImageName"];
    [encoder encodeObject:self.productImageUrl forKey:@"productImageUrl"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.productPrice] forKey:@"productPrice"];
    [encoder encodeObject:self.productDescription forKey:@"productDescription"];
    [encoder encodeObject:self.unitType forKey:@"unitType"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.discount] forKey:@"discount"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.productId = [[decoder decodeObjectForKey:@"productId"] intValue];
        self.productName = [decoder decodeObjectForKey:@"productName"];
        self.productImageName = [decoder decodeObjectForKey:@"productImageName"];
        self.productImageUrl = [decoder decodeObjectForKey:@"productImageUrl"];
        self.productPrice = [[decoder decodeObjectForKey:@"productPrice"] floatValue];
        self.productDescription = [decoder decodeObjectForKey:@"productDescription"];
        self.unitType = [decoder decodeObjectForKey:@"unitType"];
        self.discount = [[decoder decodeObjectForKey:@"discount"] floatValue];
    }
    return self;
}
@end
