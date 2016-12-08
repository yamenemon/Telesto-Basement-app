//
//  CustomerListViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerListViewController.h"

@interface CustomerListViewController ()

@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidLayoutSubviews{

    _sliderTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _sliderView.hidden = NO;
    _sliderView.frame = CGRectMake(-_sliderView.frame.size.width, _sliderView.frame.origin.y, _sliderView.frame.size.width, _sliderView.frame.size.height);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sliderBtnClicked:(id)sender {
    
    [UIView animateWithDuration:0.4
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (_isShown == NO) {
                             _isShown = YES;
                             _sliderView.frame = CGRectMake(0, _sliderView.frame.origin.y, _sliderView.frame.size.width, _sliderView.frame.size.height);
                         }
                         else{
                             _isShown = NO;
                             _sliderView.frame = CGRectMake(-_sliderView.frame.size.width, _sliderView.frame.origin.y, _sliderView.frame.size.width, _sliderView.frame.size.height);                         }
                     }
                     completion:^(BOOL finished){
                         //...second completion block...
                     }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return 5;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if (tableView.tag==1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Settings";
                break;
            case 1:
                cell.textLabel.text = @"Old Proposals";
                break;
            case 2:
                cell.textLabel.text = @"Training Video";
                break;
            case 3:
                cell.textLabel.text = @"Presentations";
                break;
            case 4:
                cell.textLabel.text = @"Logout";
                break;
                
                
            default:
                break;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        if (indexPath.row == 4) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [Utility loadLoginView];
        }
    }

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
