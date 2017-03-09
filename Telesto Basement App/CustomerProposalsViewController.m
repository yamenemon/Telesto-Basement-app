//
//  CustomerProposalsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 3/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerProposalsViewController.h"

@interface CustomerProposalsViewController ()

@end

@implementation CustomerProposalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = NO;

}
-(void)viewDidLayoutSubviews{

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
