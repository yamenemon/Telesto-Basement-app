//
//  CustomerProposalObject.h
//  Telesto Basement App
//
//  Created by CSM on 8/1/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CustomerProposalObject : NSObject
@property (assign,nonatomic) long defaultTemplateID;
@property (strong,nonatomic) NSMutableDictionary *faq;
@property (strong,nonatomic) NSString *templateName;
@property (strong,nonatomic) NSString *screenShotImageName;
@property (assign,nonatomic) long templateID;
@property (strong,nonatomic) NSMutableArray *productArray;
@property (assign,nonatomic) int proposalComplete;
@property (strong,nonatomic) NSString *signatureUrl;
@end
