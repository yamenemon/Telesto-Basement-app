//
//  Downloader.m
//  Telesto Basement App
//
//  Created by CSM on 5/18/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader
+ (id)sharedManager {
    static Downloader *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (NSMutableArray*)downloadDefautlTemplates{
    NSMutableArray *templatesArray = [[NSMutableArray alloc] init];
    
    return templatesArray;
}

- (NSMutableArray*)downloadProducts{
    NSMutableArray *productArray = [[NSMutableArray alloc] init];
    
    return productArray;
}
@end
