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
#import "CustomerProposalObject.h"
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
    _proposalListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getUserProposals];
}
-(void)getUserProposals{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *window = [UIApplication sharedApplication].keyWindow;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        [hud showAnimated:YES];
    });
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager getCustomerProposalsWithCustomerId:[[Utility sharedManager] getCurrentCustomerId] withBaseController:self withCompletionBlock:^(BOOL success){
        if (success) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            _proposalListObject  = [manager getdownloadedProposalObject];
            [_proposalListTableView reloadData];
        }
        else{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }
    }];

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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date  = [formatter dateFromString:customerInfo.scheduleDate];
    
    // Convert to new Date Format
    [formatter setDateFormat:@"MMMM d, yyyy HH:mm:ss a"];
    NSString *newDate = [formatter stringFromDate:date];
    
    self.salesAppointmentTime.text = [NSString stringWithFormat:@"%@",newDate];
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
    
    return _proposalListObject.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"CustomerProposalTableViewCell";
    
    CustomerProposalTableViewCell *cell = (CustomerProposalTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomerProposalTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_proposalListObject.count>0) {
        CustomerProposalObject *obj = [_proposalListObject objectAtIndex:indexPath.row];
        if (obj.proposalComplete == 1) {
            cell.editProposals.enabled = NO;
            cell.editProposals.alpha = 0.5;
        }
        else{
            cell.editProposals.enabled = YES;
            cell.editProposals.alpha = 1.0;
        }
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",obj.screenShotImageName]] placeholderImage:[UIImage imageNamed:@"username"]];
        cell.cellImage.contentMode = UIViewContentModeScaleToFill;
        cell.proposalName.text = obj.templateName;
        
        cell.editProposals.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
        cell.editProposals.tag = indexPath.row;
        cell.editProposals.layer.cornerRadius = 5.0;
        
        cell.duplicateProposals.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
        cell.duplicateProposals.tag = indexPath.row;
        cell.duplicateProposals.layer.cornerRadius = 5.0;
        
        [cell.editProposals addTarget:self action:@selector(loadFaqForEditingProposals) forControlEvents:UIControlEventTouchUpInside];
        [cell.duplicateProposals addTarget:self action:@selector(duplicateProposalsBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    else{
        cell.textLabel.text = @"No Proposal Available";
    }
    return cell;
}
-(void)duplicateProposalsBtnAction:(id)sender{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Maintainance Error!!!"
                                  message:@"This page is under maintainance."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Ok"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)loadFaqForEditingProposals{
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FaqsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewController"];
    vc.downloadedCustomTemplateProposalInfo = [manager getdownloadedProposalObject];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
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
