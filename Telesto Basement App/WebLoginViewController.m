//
//  WebLoginViewController.m
//  Telesto Basement App
//
//  Created by CSM on 9/25/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "WebLoginViewController.h"

@interface WebLoginViewController ()

@end

@implementation WebLoginViewController
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webView.delegate = self;
    NSString *deviceToken = [(AppDelegate *)[[UIApplication sharedApplication] delegate] deviceToken];

    NSString *urlString =[NSString stringWithFormat:@"http://api.web1.stag.csm.to/1.0/login?response_type=token&state=%@&redirect_uri=telesto://authorize",deviceToken] ;
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [webView loadRequest:urlRequest];
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
        else{
            NSString *redirectString = url.absoluteString;
            NSArray *temp = [redirectString componentsSeparatedByString:@"="];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[temp objectAtIndex:2] forKey:@"access_token"];
            [userDefaults synchronize];
            NSLog(@"%@",temp);
            [self dismissViewControllerAnimated:YES completion:nil];
            [self sendNotification:[temp objectAtIndex:2]];
            return YES;
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad");

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"web did finished");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError");

}
- (void)sendNotification:(NSString*)accessToken {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLoginWebView" object:accessToken];
}
- (IBAction)cancelBtnAction:(id)sender {
    
}
@end
