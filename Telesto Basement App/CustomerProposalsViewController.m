//
//  CustomerProposalsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 3/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerProposalsViewController.h"
#import "Utility.h"
#import "CustomerInfoObject.h"
#import "CustomerProposalTableViewCell.h"
#import "FaqsViewController.h"
#define BASE_URL  @"http://telesto.centralstationmarketing.com/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomerProposalsViewController ()

@end

@implementation CustomerProposalsViewController
@synthesize customInfoObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationController.navigationBar.translucent = NO;
    self.title = @"Customer Profile";

}
-(void)viewWillAppear:(BOOL)animated{

    NSLog(@"customInfoObject === %@",customInfoObject);
    [self setCustomerInfo:customInfoObject];
}
-(void)setCustomerInfo:(CustomerInfoObject*)customerInfo{
    NSString *imageUrl = [NSString stringWithFormat:@"%@images/customer/profile/%@",BASE_URL,customerInfo.customerOtherImageDic];
    NSLog(@"%@",imageUrl);
    self.customerProfileImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.customerProfileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
    self.customerNameLabel.text = [NSString stringWithFormat:@"%@",customerInfo.customerName];
    self.streetLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerAddress];
    self.cityLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerCityName];
    self.stateLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerStateName];
    self.zipLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerZipName];
    self.phoneLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerPhoneNumber];
    self.emailLabel.text = [NSString stringWithFormat:@": %@",customerInfo.customerEmailAddress];
}
-(void)viewDidLayoutSubviews{
   
    self.customerProfileImage.layer.cornerRadius = 10;
    self.customerProfileImage.layer.borderWidth = 2.0f;
    self.customerProfileImage.layer.borderColor = UIColorFromRGB(0x0A5571).CGColor;
    self.customerProfileImage.clipsToBounds = YES;
    
    self.proposalBtn.layer.cornerRadius = 2.0f;
    self.editProfileBTn.layer.cornerRadius = 2.0f;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;//[_customerInfoObjArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    CustomerInfoObject *customerInfoObject ;//= [_customerInfoObjArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"CustomerProposalTableViewCell";
    
    CustomerProposalTableViewCell *cell = (CustomerProposalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerProposalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellImage.image = [UIImage imageNamed:@"userName"];
    
    cell.proposalName.text = @"Basement Waterproofing";
    
    cell.signProposals.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.signProposals.tag = indexPath.row;
    cell.signProposals.layer.cornerRadius = 5.0;
    
    cell.editProposals.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.editProposals.tag = indexPath.row;
    cell.editProposals.layer.cornerRadius = 5.0;
    
    cell.duplicateProposals.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.duplicateProposals.tag = indexPath.row;
    cell.duplicateProposals.layer.cornerRadius = 5.0;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (IBAction)logoutBtnAction:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Log Out"
                                  message:@"Do you want to Log out?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [Utility showBaseViewController];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"NO"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    //        [alert setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)newProposalsBtnAction:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FaqsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
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
