//
//  CustomTextField.m
//  Telesto Basement App
//
//  Created by CSM on 7/25/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.showDismissToolbar = YES;
    self.isOptionalDropDown = NO;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropdown"]];
}
    // override rightViewRectForBounds method:
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    
    CGRect rightBounds = CGRectMake(bounds.size.width - 30, (self.frame.size.height - 15)/2, 25, 15);
    return rightBounds ;
}
@end
