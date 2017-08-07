//
//  PricePopOver.m
//  Telesto Basement App
//
//  Created by CSM on 8/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "PricePopOver.h"
#import "ShowPriceViewController.h"
#import "ProductObject.h"

@implementation PricePopOver
@synthesize proObject;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)editableWindowWithProductObject:(ProductObject*)proObj withSelectedItemTag:(int)btnTag{
    /*@property (weak, nonatomic) IBOutlet UITextField *percentField;
    @property (weak, nonatomic) IBOutlet UITextField *priceField;
     */
    proObject = proObj;
    selectedIndex = btnTag;

    _percentField.delegate = self;
    _priceField.delegate = self;
    
    float discountPrice = (proObject.discount * proObject.productPrice)/100;
    _priceField.text = [NSString stringWithFormat:@"%0.2f",discountPrice];
    _percentField.text = [NSString stringWithFormat:@"%0.2f",proObject.discount];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        activeField = textField;
}
- (IBAction)doneBtnClicked:(id)sender {
    if (activeField.tag == 1) {
        float percentValue = [activeField.text floatValue];
        if (percentValue<100) {
            proObject.discount = percentValue;
            NSLog(@"%f",proObject.discount);
        }
        else{
            
        }
    }
    else if (activeField.tag == 2){
        float priceValue = [activeField.text floatValue];
        if (proObject.productPrice>priceValue) {
            proObject.discount = (priceValue*100)/proObject.productPrice;
            NSLog(@"%f",proObject.discount);
        }
    }
    
    [_showPriceVC updateProductObjectWithObject:proObject withSelectedRow:selectedIndex];
}
@end
