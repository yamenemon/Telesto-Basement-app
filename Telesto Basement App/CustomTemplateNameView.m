//
//  CustomTemplateNameView.m
//  Telesto Basement App
//
//  Created by CSM on 3/20/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomTemplateNameView.h"
#import "DesignViewController.h"

@implementation CustomTemplateNameView
@synthesize activityIndicator;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)savedBtnAction:(id)sender {
    if (_templateNameTextField.text.length == 0) {
        _messageLabel.hidden = NO;
        _messageLabel.text = @"Template name can not be empty.";
    }
    else{
        _messageLabel.text = @"Initializing template for proposal";
        [_designViewController saveTemplateName:_templateNameTextField.text];
    }
}
- (IBAction)dismissBaseController:(id)sender {
    [_designViewController dismissController];
}
-(void)dismissKeyboardFromCustomTemplateNameWindow{
    [activityIndicator startAnimating];
    [_templateNameTextField resignFirstResponder];
}
@end
