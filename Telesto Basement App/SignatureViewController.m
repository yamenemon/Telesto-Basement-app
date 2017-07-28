//
//  SignatureViewController.m
//  Telesto Basement App
//
//  Created by CSM on 7/28/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "SignatureViewController.h"

@interface SignatureViewController ()

@end

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SignatureView *signView= [[ SignatureView alloc] initWithFrame: CGRectMake(10, 10, self.view.frame.size.width-40, 500)];
    [signView setBackgroundColor:[UIColor whiteColor]];
    signView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    signView.layer.borderWidth = 1.0;
    [self.view addSubview:signView];
    
    UILabel *confirmationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 515, self.view.frame.size.width-40, 30)];
    [self.view addSubview:confirmationLabel];
    confirmationLabel.textColor = [UIColor darkGrayColor];
    confirmationLabel.backgroundColor = [UIColor lightGrayColor];
    confirmationLabel.text = @"Confirmation waring message will be here.";
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
