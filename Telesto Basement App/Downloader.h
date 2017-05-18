//
//  Downloader.h
//  Telesto Basement App
//
//  Created by CSM on 5/18/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject
+ (id)sharedManager;
- (NSMutableArray*)downloadDefautlTemplates;
- (NSMutableArray*)downloadProducts;
@end
