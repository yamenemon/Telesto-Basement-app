//
//  BasicFAQView.h
//  Telesto Basement App
//
//  Created by CSM on 7/20/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaqsViewController;

@interface BasicFAQView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *companyLogo;
@property (weak, nonatomic) IBOutlet UILabel *companyAddress;
@property (weak, nonatomic) IBOutlet UILabel *customerInfo;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UIImageView *customerBuildingImage;


@property FaqsViewController *baseViewController;

@end
