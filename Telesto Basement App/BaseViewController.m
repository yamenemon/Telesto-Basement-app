//
//  BaseViewController.m
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [self showingTermsAndConditionScreen];
}
-(void)showingTermsAndConditionScreen{

    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"First_Logged_in"];
    if(isLoggedIn == YES) {
        NSLog(@"Show loginWindow");
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First_Logged_in"];
        [self displayTermsAndCondition];
    }

}
-(void)displayTermsAndCondition{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"termsAndCondition"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}
- (IBAction)loginButtonPressed:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString* tokenAsString = [appDelegate deviceToken];
    
    HttpHelper *serviceHelper = [[HttpHelper alloc] init];
    
    NSString* userId = _useNameTextField.text;
    NSString* password = _passwordTextField.text;
    
    NSString *post = [NSString stringWithFormat:@"userid=%@&password=%@&device_token=%@", userId, password, tokenAsString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://jupiter.centralstationmarketing.com/api/ios/Login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *data = [serviceHelper sendRequest:request];
    NSLog(@"data in string: %@",[[NSString alloc] initWithData:data encoding:4]);
}
#pragma mark UITextField Delegate

- (IBAction)editingChanged:(id)sender {
    if (_passwordTextField.text.length>0 && _useNameTextField.text.length>0) {
        [UIView animateWithDuration:0.10 animations:^{
            _loginBtn.enabled = YES;
            _loginBtn.alpha = 1.0;
        }];

    } else {
        [UIView animateWithDuration:0.10 animations:^{
            _loginBtn.enabled = NO;
            _loginBtn.alpha = 0.25;
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
