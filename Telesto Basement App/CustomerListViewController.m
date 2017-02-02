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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[Utility colorWithHexString:@"0A5571"]];
    [self customSetup];
    [self getCustomerData];
}
-(void)viewWillLayoutSubviews{

    _customerListTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;//[Utility colorWithHexString:@"0x0A5A78"].CGColor;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;//[_customerInfoObjArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    UILabel *userName;
    UILabel *userAddress;
    UILabel *scheduleLabel;
    UIImageView *userImageView;
    UIButton *viewButton;
    
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:indexPath.row];

    if (cell) {
        userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userName"]];
        [cell addSubview:userImageView];
        userImageView.frame = CGRectMake(3,150/2, 50, 50);
        userImageView.tag = 0;
        
        userName = [[UILabel alloc] initWithFrame:CGRectMake(60, 2, 500, 50)];
        [cell addSubview:userName];
        userName.font = [UIFont fontWithName:@"Roboto-Bold" size:30];
        userName.tag = 1;
        
        userAddress = [[UILabel alloc] initWithFrame:CGRectMake(60, 52, 500, 100)];
        [cell addSubview:userAddress];
        userAddress.tag = 2;
        userAddress.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        userAddress.numberOfLines = 10;
        
        scheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 152, 500, 30)];
        [cell addSubview:scheduleLabel];
        scheduleLabel.tag = 3;
        
        viewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [viewButton addTarget:self action:@selector(cellMethod:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton setTitle:@"Show View" forState:UIControlStateNormal];
        viewButton.backgroundColor = [Utility colorWithHexString:@"0x0A5A78"];
        viewButton.frame = CGRectMake(tableView.frame.size.width - 180, (184-40)/2, 160.0, 40.0);
        viewButton.tag = 5;
        viewButton.layer.cornerRadius = 5.0;
        [cell addSubview:viewButton];
    }
    else{
        userImageView = [cell viewWithTag:0];
        userName = [cell viewWithTag:1];
        userAddress = [cell viewWithTag:2];
        scheduleLabel = [cell viewWithTag:3];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    userName.backgroundColor = [UIColor clearColor];
    userAddress.backgroundColor = [UIColor clearColor];
    scheduleLabel.backgroundColor = [UIColor clearColor];
//    userName.text = @"Steve Lenon";
    userAddress.text = @"city : New York.\npostalCode : 10021.\nstate : NY.\nstreetAddress : 21 2nd Street.";
    scheduleLabel.text = @"Monday, June 15, 2009 8:45:30 PM ";
    NSLog(@"\nCustomer Name: %@ \n Customer Address: %@ \n Customer Schedule: %@ \n",customerInfoObject.customerName,customerInfoObject.customerAddress,customerInfoObject.scheduleDate);
    userName.text = [NSString stringWithFormat:@"%@", customerInfoObject.customerName];
//    userAddress.text = [NSString stringWithFormat:@"%@", customerInfoObject.customerAddress];
//    scheduleLabel.text = [NSString stringWithFormat:@"%@", customerInfoObject.scheduleDate];

    return cell;
}
-(void)cellMethod:(id)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DesignViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 184;

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

@end
