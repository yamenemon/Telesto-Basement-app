//
//  CountryListObject.h
//  Telesto Basement App
//
//  Created by CSM on 7/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryListObject : NSObject
@property (strong,nonatomic) NSString *countryCode;
@property (strong,nonatomic) NSString *countryName;
@property (assign,nonatomic) int countryId;
@end
