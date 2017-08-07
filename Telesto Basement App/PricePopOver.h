//
//  PricePopOver.h
//  Telesto Basement App
//
//  Created by CSM on 8/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowPriceViewController;
@class ProductObject;

@interface PricePopOver : UIView <UITextFieldDelegate>{
    int selectedIndex;
    UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UITextField *percentField;
@property (weak, nonatomic) IBOutlet UITextField *priceField;
@property (strong,nonatomic) ShowPriceViewController *showPriceVC;
@property (strong,nonatomic) ProductObject *proObject;
-(void)editableWindowWithProductObject:(ProductObject*)proObj withSelectedItemTag:(int)btnTag;
@end
