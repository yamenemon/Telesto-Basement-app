//
//  CustomerListViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerListViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerListViewController ()

@end

@implementation CustomerListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[Utility colorWithHexString:@"0A5571"]];
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

    NSString *customerData = @"{ \"firstName\": \"Oliver\",\"lastName\": \"Smith\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData2 = @"{ \"firstName\": \"Paul\",\"lastName\": \"A. Heckel\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData3 = @"{ \"firstName\": \"Archie\",\"lastName\": \"M. Milton\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData4 = @"{ \"firstName\": \"Charles\",\"lastName\": \"H. Ertl\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData5 = @"{ \"firstName\": \"Nathalie\",\"lastName\": \"D. Pittman\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData6 = @"{ \"firstName\": \"Courtney\",\"lastName\": \"C. Schroeder\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData7 = @"{ \"firstName\": \"Karen\",\"lastName\": \"J. Mauck\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData8 = @"{ \"firstName\": \"Janice\",\"lastName\": \"D. White\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData9 = @"{ \"firstName\": \"Leon\",\"lastName\": \"Halpern\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    
    NSString *customerData10 = @"{ \"firstName\": \"Carolyn\",\"lastName\": \"Leger\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    NSArray *arr = [NSArray arrayWithObjects:customerData,customerData2,customerData3,customerData4,customerData5,customerData6,customerData7,customerData8,customerData9,customerData10, nil];
    _customerInfoObjArray = [[NSMutableArray alloc] init];
    for (int i=0; i<arr.count; i++) {
        // Convert to JSON object:
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[[arr objectAtIndex:i] dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:0 error:NULL];
        NSLog(@"jsonObject=%@", jsonObject);
        
        CustomerInfoObject *customerInfoObj = [[CustomerInfoObject alloc] init];
        customerInfoObj.customerName = [NSString stringWithFormat:@"%@ %@",[jsonObject valueForKey:@"firstName"],[jsonObject valueForKey:@"lastName"]] ;
        customerInfoObj.customerAddress = [jsonObject valueForKey:@"address"];
//        customerInfoObj.scheduleDate = [jsonObject valueForKey:@"number"];
        [_customerInfoObjArray addObject:customerInfoObj];
    }
    
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
    
    return 10;//[_customerInfoObjArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:indexPath.row];
    static NSString *simpleTableIdentifier = @"CustomTableViewCell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.cellImageView.image = [UIImage imageNamed:@"userName"];
    
        [cell.proposalsBtn addTarget:self action:@selector(cellMethod:) forControlEvents:UIControlEventTouchUpInside];
        cell.proposalsBtn.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
        cell.proposalsBtn.tag = indexPath.row;
        cell.proposalsBtn.layer.cornerRadius = 5.0;

    cell.cityTextLabel.text = @": New York.\npostalCode : 10021.\nstate : NY.\nstreetAddress : 21 2nd Street.";
    cell.lastLoginTextLabel.text = @": Monday, June 15, 2009 8:45:30 PM ";
    NSLog(@"\nCustomer Name: %@ \n Customer Address: %@ \n Customer Schedule: %@ \n",customerInfoObject.customerName,customerInfoObject.customerAddress,customerInfoObject.scheduleDate);
    cell.nameTextLabel.text = [NSString stringWithFormat:@"%@", customerInfoObject.customerName];

    return cell;
}
-(void)cellMethod:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerProposals"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
