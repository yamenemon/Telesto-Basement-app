//
//  CustomerListViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerListViewController.h"
#import "CustomerDataManager.h"
#import "CustomerInfoObject.h"
#import "CustomerRecordViewController.h"

#define BASE_URL  @"http://telesto.centralstationmarketing.com/"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerListViewController ()

@end

@implementation CustomerListViewController
@synthesize customerDataManager;
//@synthesize customerInfoObject;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[Utility colorWithHexString:@"0A5571"]];

    
}
-(void)viewWillAppear:(BOOL)animated{
    customerDataManager = [CustomerDataManager sharedManager];
    _customerInfoObjArray = [[NSMutableArray alloc] init];
    [self customSetup];
    [self getCustomerData];
}
-(void)viewWillLayoutSubviews{

    _customerListTableView.layer.borderColor = [UIColor clearColor].CGColor;//[Utility colorWithHexString:@"0x0A5A78"].CGColor;
    _customerListTableView.layer.borderWidth = 2.0;
    _customerListTableView.layer.cornerRadius = 2.0;
}

-(void)getCustomerData{
    _customerListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
     [customerDataManager getCustomerListWithBaseController:self withCompletionBlock:^(BOOL success){
         _customerInfoDic = [customerDataManager getCustomerData];
         if (_customerInfoDic.count>0) {
             for (NSMutableDictionary *dic in _customerInfoDic) {
                 
                 CustomerInfoObject *customerInfoObj = [[CustomerInfoObject alloc] init];
                 customerInfoObj.customerName = [NSString stringWithFormat:@"%@ %@",[dic valueForKey:@"fName"],[dic valueForKey:@"lName"]] ;
                 customerInfoObj.customerAddress = [dic valueForKey:@"address"];
                 customerInfoObj.scheduleDate = [dic valueForKey:@"created"];
                 customerInfoObj.customerId = [dic valueForKey:@"id"];
                 customerInfoObj.customerFirstName = [dic valueForKey:@"fName"];
                 customerInfoObj.customerLastName = [dic valueForKey:@"lName"];
                 customerInfoObj.customerCityName = [dic valueForKey:@"city"];
                 customerInfoObj.customerStateName = [dic valueForKey:@"state"];
                 customerInfoObj.customerZipName = [dic valueForKey:@"zip"];
                 customerInfoObj.customerCountryName = [[dic valueForKey:@"countryId"] stringValue];
                 customerInfoObj.emailNotification = [dic valueForKey:@"emailNotify"];
                 customerInfoObj.customerEmailAddress = [dic valueForKey:@"email"];
                 customerInfoObj.smsReminder = [dic valueForKey:@"smsNotify"];
                 customerInfoObj.customerPhoneNumber = [dic valueForKey:@"phone"];
                 customerInfoObj.customerNotes = [dic valueForKey:@"details"];
                 customerInfoObj.customerOtherImageDic = [dic valueForKey:@"photo"];
                 customerInfoObj.buildingImages = [dic valueForKey:@""];
                 customerInfoObj.latitude = [dic valueForKey:@"latitude"];
                 customerInfoObj.longitude = [dic valueForKey:@"longitude"];
                 [_customerInfoObjArray addObject:customerInfoObj];
             }
             [_customerListTableView reloadData];
             NSLog(@"Customer data: %@",_customerInfoDic);
         }
         else{
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Customer!!" message:@"There is no user for this user.Please create new customer from top navigation bar." preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction
                                  actionWithTitle:@"OK"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                      
                                  }];
             [alert addAction:ok];
             [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
             [self presentViewController:alert animated:YES completion:nil];
         }
         
    }];
}
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}

#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}
#pragma mark -
#pragma mark UITableView delegate Method -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _customerInfoDic.count;//[_customerInfoObjArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    CustomerInfoObject *customerInfoObjects = [_customerInfoObjArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"CustomTableViewCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.MapItBtn.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.MapItBtn.tag = indexPath.row;
    cell.MapItBtn.layer.cornerRadius = 5.0;
    
    cell.customProfileBtn.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.customProfileBtn.tag = indexPath.row;
    cell.customProfileBtn.layer.cornerRadius = 5.0;
    [cell.customProfileBtn addTarget:self action:@selector(customProfileBtnActon:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MapItBtn addTarget:self action:@selector(mapItBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    /*
     7 Saint Andrews Ct
     Trophy Club, TX
     Sales Appointment: July 21st, 2017 2:14PM
     
     address = Ashuganj;
     city = fjeisdiiw;
     countryId = 0;
     created = "2017-07-21 14:14:17";
     details = Skdjhfsdjcsdcoij;
     email = "emon@gmail.com";
     emailNotify = 1;
     fName = Yamen;
     id = 27;
     lName = Emon;
     latitude = "23.7831";
     longitude = "90.3943";
     modified = "0000-00-00 00:00:00";
     phone = 748648;
     photo = "1500646457a243wd3sq21e.jpg";
     smsNotify = 0;
     state = inij;
     status = 1;
     userId = 2;
     zip = 3454;
     */

    cell.streetAddress.text = [NSString stringWithFormat:@"%@",customerInfoObjects.customerAddress];
    
    cell.citZip.text = [NSString stringWithFormat:@"%@,%@",customerInfoObjects.customerCityName,customerInfoObjects.customerStateName];
    cell.salesAppointment.text = [NSString stringWithFormat:@"Sales Appointment : %@", customerInfoObjects.scheduleDate];
    cell.nameTextLabel.text = [NSString stringWithFormat:@"%@", customerInfoObjects.customerName];
    NSString *imageUrl = [NSString stringWithFormat:@"%@images/customer/profile/%@",BASE_URL,customerInfoObjects.customerOtherImageDic];
    NSLog(@"%@",imageUrl);
    cell.cellImageView.contentMode = UIViewContentModeScaleToFill;
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:indexPath.row];
    [self cellMethod:(long)indexPath.row withCustomerInfo:customerInfoObject];
}
-(void)mapItBtnAction:(UIButton*)sender{
    UIButton *btn = (UIButton*)sender;
    long tag = btn.tag;
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:tag];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapItViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MapItViewController"];
    vc.customInfoObject = customerInfoObject;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cellMethod:(long)sender withCustomerInfo:(CustomerInfoObject*)infoObject{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerProposalsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerProposals"];
    vc.customInfoObject = infoObject;
    [[Utility sharedManager] setCurrentCustomerId:(int)infoObject.customerId];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)customProfileBtnActon:(UIButton*)sender{
    UIButton *btn = (UIButton*)sender;
    long tag = btn.tag;
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:tag];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerRecordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerRecordViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.isFromCustomProfile = YES;
    vc.customerInfoObjects = customerInfoObject;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)createNewCustomer:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerRecordViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerRecordViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    vc.isFromCustomProfile = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)testBtnCalled:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DesignViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logoutBtnAction:(id)sender {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Log Out"
                                      message:@"Do you want to Log out?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action){
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

@end
