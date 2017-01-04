//
//  UserProfileViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()

@property (weak, nonatomic) IBOutlet UIView *previousProposalView;
@property (weak, nonatomic) IBOutlet UIView *latestProposalView;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews{

    _previousProposalView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _latestProposalView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.title = @"Customer Profile";
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
