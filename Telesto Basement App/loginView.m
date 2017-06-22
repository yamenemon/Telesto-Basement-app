//
//  loginView.m
//  Telesto Basement App
//
//  Created by CSM on 3/6/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "loginView.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "StringClass.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation loginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)addSpinner {
    [self endEditing:YES];
    self.loadingIndicator.hidden = NO;
    [self.loadingIndicator startAnimating];
}
- (IBAction)loginButtonPressed:(id)sender {


        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            //Add some method process in global queue - normal for data processing
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSString* tokenAsString = [appDelegate deviceToken];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                //Add method, task you want perform on mainQueue
                //Control UIView, IBOutlet all here
                [self hideButton];
                [self addSpinner];
                _errorMessageLabel.text = @"";
                
            });
            
            //Add some method process in global queue - normal for data processing
            NSString* userId = _emailField.text;
            NSString* password = _passwordField.text;

            tokenAsString = @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH";
            NSString *endPoint = @"user_login";
            NSString *post = [NSString stringWithFormat:@"email=%@&password=%@&authKey=%@", userId, password, tokenAsString];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,endPoint]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            [self sendRequest:request];
        });
    
}
-(void)sendRequest:(NSURLRequest*)urlRequest{

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                               if (data) {
                                                                   [self parseJOSNLoginStatus:data];
                                                               }
                                                               else{
                                                                   [self showButton];
                                                                   NSString *message = @"Login Failed";
                                                                   NSLog(@"%@", message);
                                                                   
                                                                   _errorMessageLabel.hidden = NO;
                                                                   _errorMessageLabel.text = message;
                                                                   _loadingIndicator.hidden = YES;
                                                                   [_loadingIndicator stopAnimating];
                                                               }
                                                           }
                                                           else{
                                                               [self showButton];
                                                               NSString *message = @"Login Failed";
                                                               NSLog(@"%@", message);
                                                               
                                                               _errorMessageLabel.hidden = NO;
                                                               _errorMessageLabel.text = message;
                                                               _loadingIndicator.hidden = YES;
                                                               [_loadingIndicator stopAnimating];
                                                           }
                                                       }];
    [dataTask resume];
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error: &e];
    long loginStatus = [[jsonArray objectForKey:@"success"] longValue];

    long userId = [[[jsonArray objectForKey:@"results"] objectForKey:@"userId"] longValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:userId] forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if(loginStatus == 1) {
        NSLog(@"Login Successful");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];

        if([self.activeStatusSwitch isOn]) {
            [self updateLoginEmailAddress:self.emailField.text];
        } else {
            [self clearOldLoginEmailAddress];
        }
        
        [Utility storeCookie];
        dispatch_async(dispatch_get_main_queue(), ^(){
            [Utility showCustomerListViewController];
            
        });
        return YES;
    } else {
        [self showButton];
        NSString *message = @"Login Failed";
        NSLog(@"%@", message);

        _errorMessageLabel.hidden = NO;
        _errorMessageLabel.text = message;
        _loadingIndicator.hidden = YES;
        [_loadingIndicator stopAnimating];
        
        return NO;
    }
    return NO;
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
    if (_passwordField.text.length>0 && _emailField.text.length>0) {
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
-(void)hideButton {
    self.loginBtn.hidden = TRUE;
}
-(void)showButton {
    self.loginBtn.hidden = FALSE;
}
- (IBAction)forgetBtnPressed:(id)sender {
    [UIView animateWithDuration:0.65 animations:^{
        _loginView.alpha = 0.0;
        _termsView.alpha = 0.0;
        _forgetView.alpha = 1.0;
    }];
}
- (IBAction)sendBtnAction:(id)sender {
    [UIView animateWithDuration:0.65 animations:^{
        _forgetView.alpha = 0.0;
        _termsView.alpha = 0.0;
        _loginView.alpha = 1.0;
    }];
}
- (IBAction)termsOfUse:(id)sender {
    [UIView animateWithDuration:0.65 animations:^{
    _forgetView.alpha = 0.0;
    _termsView.alpha = 1.0;
    _loginView.alpha = 0.0;
    }];
}
- (IBAction)termsDoneBtnActions:(id)sender {
    [UIView animateWithDuration:0.65 animations:^{
        _forgetView.alpha = 0.0;
        _termsView.alpha = 0.0;
        _loginView.alpha = 1.0;
    }];
}
@end
