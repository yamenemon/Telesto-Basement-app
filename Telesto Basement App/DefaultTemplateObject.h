//
//  DefaultTemplateObject.h
//  Telesto Basement App
//
//  Created by CSM on 7/18/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultTemplateObject : NSObject
@property (assign,nonatomic) int templateId;
@property (strong,nonatomic) NSString *templateName;
@property (strong,nonatomic) NSString *templateImage;
@end
