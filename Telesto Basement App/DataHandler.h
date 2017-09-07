//
//  DataHandler.h
//  Telesto Basement App
//
//  Created by CSM on 9/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataHelper.h"

#import "Product.h"
#import "GrateProducts.h"

@interface DataHandler : NSObject{
    CoreDataHelper *dbHandler;
}
+ (id)sharedManager;
-(NSArray*)fetchAllProductData;
@end
