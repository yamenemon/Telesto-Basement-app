//
//  ProductInfoDetailsPopup.h
//  Telesto Basement App
//
//  Created by CSM on 6/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DesignViewController;

@interface ProductInfoDetailsPopup : UIView
@property (strong, nonatomic) DesignViewController *designViewController;
@property (weak, nonatomic) IBOutlet UIImageView *productDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptions;

@end
