//
//  BaseViewController.m
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) UIActivityIndicatorView *aSpinner;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Utility checkForCookie];
    
    NSString *oldEmailAddress = [self getOldLoginEmailAddress];
    if (oldEmailAddress &&
        ![oldEmailAddress isEqualToString:@""]) {
        self.useNameTextField.text = oldEmailAddress;
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}
-(void)viewDidAppear:(BOOL)animated{
    [self showingTermsAndConditionScreen];
}
-(void)showingTermsAndConditionScreen{

    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"First_Logged_in"];
    if(isLoggedIn == YES) {
        NSLog(@"Show loginWindow");
        NSLog(@"Hide loginWindow");
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First_Logged_in"];
        [self displayTermsAndCondition];
    }
}
-(void)viewDidLayoutSubviews{

    
    _loginView.layer.cornerRadius = 10;
    _loginView.layer.borderColor = [Utility colorWithHexString:@"0x0A5A78"].CGColor;

}
-(void)displayTermsAndCondition{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"termsAndCondition"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}
-(void)hideButton {
    self.loginBtn.hidden = TRUE;
}


-(void)showButton {
    self.loginBtn.hidden = FALSE;
}


-(void)addSpinner {
    [self.view endEditing:YES];
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self hideButton];
    [self addSpinner];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString* tokenAsString = [appDelegate deviceToken];
    
    HttpHelper *serviceHelper = [[HttpHelper alloc] init];
    
    NSString* userId = _useNameTextField.text;
    NSString* password = _passwordTextField.text;
    
    NSString *post = [NSString stringWithFormat:@"userid=%@&password=%@&device_token=%@&device_type=iOS", userId, password, tokenAsString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://jupiter.centralstationmarketing.com/api/ios/Login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *data = [serviceHelper sendRequest:request];
    [self parseJOSNLoginStatus:data];
    
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableLeaves
                                                                error: &e];
    NSString *loginStatus = [jsonArray objectForKey:@"Login"];
    if([loginStatus isEqualToString:@"true"]) {
        NSLog(@"Login Successful");
        if([self.rememberSwitch isOn]) {
            [self updateLoginEmailAddress:self.useNameTextField.text];
        } else {
            [self clearOldLoginEmailAddress];
        }
        
        [Utility storeCookie];
        [Utility showCustomerListViewController];
        return YES;
    } else {
        [self showButton];
        NSString *message = @"Login Failed";
        NSLog(@"%@", message);
        [Utility showAlertWithTitle:@"Error"
                              withMessage:message];
        return NO;
    }
    return NO;
}
-(NSString*)getOldLoginEmailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(oldEmailSettings) {
        return [oldEmailSettings objectForKey:@"EmailAddress"];
    }
    return @"";
}


-(void)updateLoginEmailAddress:(NSString*)emailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(!oldEmailSettings) {
        oldEmailSettings = [[NSMutableDictionary alloc] init];
    }
    
    [oldEmailSettings setValue:emailAddress
                        forKey:@"EmailAddress"];
    
    [[NSUserDefaults standardUserDefaults] setObject:oldEmailSettings
                                              forKey:@"EmailSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)clearOldLoginEmailAddress {
    [self updateLoginEmailAddress:@""];
}
#pragma mark UITextField Delegate

- (IBAction)editingChanged:(id)sender {
    if (_passwordTextField.text.length>0 && _useNameTextField.text.length>0) {
        [UIView animateWithDuration:0.25 animations:^{
            _loginBtn.enabled = YES;
            _loginBtn.alpha = 1.0;
        }];

    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _loginBtn.enabled = NO;
            _loginBtn.alpha = 0.25;
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
