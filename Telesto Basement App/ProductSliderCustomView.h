//
//  ProductSliderCustomView.h
//  Telesto Basement App
//
//  Created by CSM on 6/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DesignViewController;
@interface ProductSliderCustomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *productBtn;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UIButton *productDetails;
@property (strong, nonatomic) DesignViewController*designViewController;
@end
