//
//  TermsAndConditionViewController.m
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "TermsAndConditionViewController.h"

@interface TermsAndConditionViewController ()


@end

@implementation TermsAndConditionViewController

-(id)initWithBaseViewController:(BaseViewController*)mainController{
    baseViewController = mainController;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonPressed:(id)sender {
    UIAlertView *confirmationAlert = [[UIAlertView alloc] initWithTitle:@"Confirmation Alert" message:@"Please Accept Terms and Condition for using the Application" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    [confirmationAlert show];
}
- (IBAction)AgreeButtonPressed:(id)sender {
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
