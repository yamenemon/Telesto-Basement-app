//
//  loginView.m
//  Telesto Basement App
//
//  Created by CSM on 3/6/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "loginView.h"
#import "AppDelegate.h"
#import "HttpHelper.h"
#import "Utility.h"

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
        
        HttpHelper *serviceHelper = [[HttpHelper alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^(){
            //Add method, task you want perform on mainQueue
            //Control UIView, IBOutlet all here
            [self hideButton];
            [self addSpinner];
            
        });
        
        //Add some method process in global queue - normal for data processing
        NSString* userId = _emailField.text;
        NSString* password = _passwordField.text;
        
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
    });

    
    
    
    
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableLeaves
                                                                error: &e];
    NSString *loginStatus = [jsonArray objectForKey:@"Login"];
    if([loginStatus isEqualToString:@"true"]) {
        NSLog(@"Login Successful");
        if([self.activeStatusSwitch isOn]) {
            [self updateLoginEmailAddress:self.emailField.text];
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
//        [Utility showAlertWithTitle:@"Error"
//                        withMessage:message];
        _errorMessageLabel.hidden = NO;
        _errorMessageLabel.text = message;
        [_loadingIndicator stopAnimating];
        
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
@end
