//
//  DataHandler.m
//  Telesto Basement App
//
//  Created by CSM on 9/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "DataHandler.h"
static DataHandler *sharedManager = nil;

@implementation DataHandler
+ (id)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
-(id)init{
    if(self = [super init]){
        dbHandler = [[CoreDataHelper alloc] init];
    }
    return self;
}
-(NSMutableArray*)fetchAllProductData{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = [dbHandler persistentStoreCoordinator];

//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"GrateProduct"];
    
    NSError *error = nil;
//    NSArray *results = [moc executeFetchRequest:request error:&error];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"swingDate" ascending:NO];
//    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc] initWithKey:@"swingTime" ascending:NO];
//    [request setSortDescriptors:[NSArray arrayWithObjects:sortByDate,sortByTime,nil]];
    [request setEntity:[NSEntityDescription entityForName:@"GrateProduct" inManagedObjectContext:moc]];
    NSSortDescriptor *sortByTime = [[NSSortDescriptor alloc] initWithKey:@"productId" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObjects:sortByTime,nil]];
    NSArray *results = [moc  executeFetchRequest:request error:&error];
    
    
    for (int i = 0; i<results.count; i++) {
        Product *product = [[Product alloc] init];
        GrateProducts *grateProduct = [results objectAtIndex:i];
        product.productId = (int)grateProduct.productId;
        product.productName = grateProduct.productName;
        product.productPrice = grateProduct.productPrice;
        product.imageData = grateProduct.image;
        product.unitType = grateProduct.unitType;
        product.discount = grateProduct.discount;
        product.productDescription = grateProduct.productDescription;
        [arr addObject:product];
    }
    if (!results) {
        NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    return arr;
    
    
}
@end
