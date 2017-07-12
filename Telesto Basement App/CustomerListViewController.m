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
    
     [customerDataManager getCustomerListWithBaseController:self withCompletionBlock:^{
         _customerInfoDic = [customerDataManager getCustomerData];
         for (NSMutableDictionary *dic in _customerInfoDic) {
             
             /*
              address = thbggb;
              city = ggbggb;
              countryId = 4;
              created = "2017-07-11 13:06:18";
              details = Nfgvutngvgnvgtimtgimv;
              email = "fgbggb@frf.ffl";
              emailNotify = 1;
              fName = ggbggvbtg;
              id = 17;
              lName = ggbggb;
              latitude = "23.7832";
              longitude = "90.3942";
              modified = "0000-00-00 00:00:00";
              phone = 7575;
              photo = "1499778378ds32a2w13eq4.jpg";
              smsNotify = 0;
              state = ggbggbgg;
              status = 1;
              userId = 2;
              zip = ggbggbgg;
              
              
              @property (assign,nonatomic) long customerId;
              @property (strong,nonatomic) NSString *customerFirstName;
              @property (strong,nonatomic) NSString *customerLastName;
              @property (strong,nonatomic) NSString *customerStreetAddress;
              @property (strong,nonatomic) NSString *customerCityName;
              @property (strong,nonatomic) NSString *customerStateName;
              @property (strong,nonatomic) NSString *customerZipName;
              @property (strong,nonatomic) NSString *customerCountryName;
              @property (assign,nonatomic) BOOL emailNotification;
              @property (strong,nonatomic) NSString *customerEmailAddress;
              @property (assign,nonatomic) BOOL smsReminder;
              @property (strong,nonatomic) NSString *customerPhoneNumber;
              @property (strong,nonatomic) NSString *customerNotes;
              @property (strong,nonatomic) NSDictionary *customerOtherImageDic;
              @property (strong,nonatomic) NSMutableArray *buildingImages;
              @property (strong,nonatomic) NSString* latitude;
              @property (strong,nonatomic) NSString* longitude;
              
              */
             
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
             customerInfoObj.customerCountryName = [dic valueForKey:@"countryId"];
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

        cell.cellImageView.image = [UIImage imageNamed:@"userName"];
    
    cell.MapItBtn.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.MapItBtn.tag = indexPath.row;
    cell.MapItBtn.layer.cornerRadius = 5.0;
    
    cell.customProfileBtn.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
    cell.customProfileBtn.tag = indexPath.row;
    cell.customProfileBtn.layer.cornerRadius = 5.0;
    [cell.customProfileBtn addTarget:self action:@selector(cellMethod:) forControlEvents:UIControlEventTouchUpInside];

    cell.cityTextLabel.text =  [NSString stringWithFormat:@": %@", customerInfoObjects.customerAddress];
    cell.lastLoginTextLabel.text = [NSString stringWithFormat:@": %@", customerInfoObjects.scheduleDate];
    cell.nameTextLabel.text = [NSString stringWithFormat:@"%@", customerInfoObjects.customerName];
    NSString *imageUrl = [NSString stringWithFormat:@"%@images/customer/%@",BASE_URL,customerInfoObjects.customerOtherImageDic];
    NSLog(@"%@",imageUrl);
    [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
}
-(void)cellMethod:(UIButton*)sender{
    UIButton *btn = (UIButton*)sender;
    long tag = btn.tag;
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:tag];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CustomerProposalsViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerProposals"];
    vc.customInfoObject = customerInfoObject;
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:indexPath.row];
//    [self cellMethod:customerInfoObject];
//}
- (IBAction)createNewCustomer:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerRecordViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
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
