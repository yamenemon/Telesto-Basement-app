//
//  BaseViewController.h
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsAndConditionViewController.h"
#import "Utility.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "loginView.h"
#import <AVFoundation/AVFoundation.h>

@interface BaseViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) loginView *customLoginView;
@property (weak, nonatomic) IBOutlet UITextField *useNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UISwitch *rememberSwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;

@end
