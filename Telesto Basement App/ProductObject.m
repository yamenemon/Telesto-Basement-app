//
//  ProductObject.m
//  Telesto Basement App
//
//  Created by CSM on 5/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProductObject.h"

@implementation ProductObject

@synthesize productId;
@synthesize productName;
@synthesize productXcoordinate;
@synthesize productYcoordinate;
@synthesize productWidth;
@synthesize productHeight;
@synthesize storedMediaArray;

-(instancetype)init{
    self = [super init];
    if (self) {
        storedMediaArray = [[NSMutableArray alloc] init];
        return self;
    }
    return self;
}
@end
