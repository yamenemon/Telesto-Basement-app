//
//  CustomerRecordViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerRecordViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerRecordViewController ()

@end

@implementation CustomerRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Customer Records";
    
    
    
}
-(void)viewDidLayoutSubviews{
    self.customerImageView.layer.cornerRadius = self.customerImageView.frame.size.width / 2;
    self.customerImageView.layer.borderWidth = 3.0f;
    self.customerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customerImageView.clipsToBounds = YES;
    
    
    self.basementImageView.layer.cornerRadius = 5;
    self.basementImageView.layer.borderWidth = 2.0f;
    self.basementImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.basementImageView.clipsToBounds = YES;
    
    [self changeTextfieldStyle:_firstNameTextField];
    [self changeTextfieldStyle:_lastNameTextField];
    [self changeTextfieldStyle:_streetAddressTextField];
    [self changeTextfieldStyle:_cityTextField];
    [self changeTextfieldStyle:_zipCodeTextField];
    [self changeTextfieldStyle:_countryTextField];
    [self changeTextfieldStyle:_emailTextField];
    [self changeTextfieldStyle:_areaTextField];
    [self changeTextfieldStyle:_phoneNumberTextField];
    [self changeTextfieldStyle:_stateNameTextField];
    
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
