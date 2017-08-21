//
//  StoreImageDescriptionView.m
//  Telesto Basement App
//
//  Created by CSM on 8/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "StoreImageDescriptionView.h"
#import "ProductStoreImageDescriptionViewController.h"

@implementation StoreImageDescriptionView
@synthesize baseView,galleryItem;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    _descriptionTextView.placeholderText = @"Your Image Description";
    _descriptionTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _descriptionTextView.layer.borderWidth = 2.0;
}
- (IBAction)saveBtnAction:(id)sender {
    [self endEditing:YES];
    [baseView updateCarouselWithText:_descriptionTextView.text];
}
@end
