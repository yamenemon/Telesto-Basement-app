//
//  loginView.h
//  Telesto Basement App
//
//  Created by CSM on 3/6/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIView *forgetView;



@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatusSwitch;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@property (weak, nonatomic) IBOutlet UITextField *forgetEmailField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *forgetLoadingIndicator;
@end
