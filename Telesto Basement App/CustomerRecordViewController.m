//
//  CustomerRecordViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerRecordViewController.h"
#define BaseURL  @"http://telesto.centralstationmarketing.com/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerRecordViewController ()

@end

@implementation CustomerRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Customer Records";
    [_rightView endEditing:YES];
//    [self changeTextfieldStyle:_firstNameTextField];
//    [self changeTextfieldStyle:_lastNameTextField];
//    [self changeTextfieldStyle:_streetAddressTextField];
//    [self changeTextfieldStyle:_cityTextField];
//    [self changeTextfieldStyle:_zipCodeTextField];
//    [self changeTextfieldStyle:_countryTextField];
//    [self changeTextfieldStyle:_emailTextField];
//    [self changeTextfieldStyle:_areaTextField];
//    [self changeTextfieldStyle:_phoneNumberTextField];
//    [self changeTextfieldStyle:_stateNameTextField];
    
}
-(void)viewDidLayoutSubviews{
    self.customerImageView.layer.cornerRadius = self.customerImageView.frame.size.width / 2;
    self.customerImageView.layer.borderWidth = 3.0f;
    self.customerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customerImageView.clipsToBounds = YES;
}
-(UITextField*)changeTextfieldStyle:(UITextField*)textField{
    
    UITextField *tempTextField = textField;
    tempTextField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height+30);
    tempTextField.layer.borderWidth = 1.0f;
    tempTextField.layer.borderColor = UIColorFromRGB(0xC5C6C5).CGColor;
    tempTextField.layer.cornerRadius = 5;
    tempTextField.clipsToBounds      = YES;
    return tempTextField;
    
}
-(void)createCustomer{

//    tokenAsString = @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH";
    NSString *endPoint = @"create_customer";
//    fName, lName, address, city, state, zip, countryId, email, phone, userId
    NSString *post = [NSString stringWithFormat:@"fName=%@&lName=%@&address=%@&city=%@&state=%@&zip=%@&countryId=%@&email=%@&phone=%@&userId=%@", _firstNameTextField.text, _lastNameTextField.text, _streetAddressTextField.text,_cityTextField.text,_stateNameTextField.text,_zipCodeTextField.text,_countryTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,endPoint]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [self sendRequest:request];

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
                                                                   
                                                               }
                                                           }
                                                       }];
    [dataTask resume];
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error: &e];
    long loginStatus = [[jsonArray objectForKey:@"success"] longValue];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)customerRecordPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
