//
//  ProductSliderCustomView.m
//  Telesto Basement App
//
//  Created by CSM on 6/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProductSliderCustomView.h"
#import "DesignViewController.h"

@implementation ProductSliderCustomView
@synthesize designViewController;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
//        _productBtn.backgroundColor = [UIColor clearColor];
        _productName.backgroundColor = [UIColor redColor];
        _productDetails.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (IBAction)detailsBtnAction:(id)sender {
    [designViewController showProductDetailsPopUp:(int)self.productBtn.tag];
}
@end
