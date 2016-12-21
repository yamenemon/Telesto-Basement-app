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

-(void)getCustomerData{

    NSString *customerData = @"{ \"firstName\": \"John\",\"lastName\": \"Smith\",\"age\": 25,\"address\":\{\"streetAddress\":\"21 2nd Street\",\"city\":\"New York\",\"state\":\"NY\",        \"postalCode\":\"10021\"},\"phoneNumber\":[{\"type\": \"home\",\"number\": \"212 555-1234\"},{\"type\":\"fax\",\"number\": \"646 555-4567\"}]}";
    // Convert to JSON object:
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[customerData dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0 error:NULL];
    NSLog(@"jsonObject=%@", jsonObject);
    
    
    CustomerInfoObject *customerInfoObj = [[CustomerInfoObject alloc] init];
    customerInfoObj.customerName = [NSString stringWithFormat:@"%@ %@",[jsonObject valueForKey:@"firstName"],[jsonObject valueForKey:@"lastName"]] ;
    customerInfoObj.customerAddress = [jsonObject valueForKey:@"address"];
    customerInfoObj.scheduleDate = [jsonObject valueForKey:@"number"];
    _customerInfoObjArray = [[NSMutableArray alloc] initWithObjects:customerInfoObj, nil];
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
    
    return [_customerInfoObjArray count];
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
    
    CustomerInfoObject *customerInfoObject = [_customerInfoObjArray objectAtIndex:indexPath.row];

    if (cell) {
        userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"userName"]];
        [cell addSubview:userImageView];
        userImageView.frame = CGRectMake(3, 2, 45, 45);
        userImageView.tag = 0;
        
        userName = [[UILabel alloc] initWithFrame:CGRectMake(48, 2, 200, 50)];
        [cell addSubview:userName];
        userName.tag = 1;
        
        userAddress = [[UILabel alloc] initWithFrame:CGRectMake(48, 52, 200, 150)];
        [cell addSubview:userAddress];
        userAddress.tag = 2;
        
        scheduleLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 252, 200, 48)];
        [cell addSubview:scheduleLabel];
        scheduleLabel.tag = 3;
    }
    else{
        userImageView = [cell viewWithTag:0];
        userName = [cell viewWithTag:1];
        userAddress = [cell viewWithTag:2];
        scheduleLabel = [cell viewWithTag:3];
    }
    NSLog(@"\nCustomer Name: %@ \n Customer Address: %@ \n Customer Schedule: %@ \n",customerInfoObject.customerName,customerInfoObject.customerAddress,customerInfoObject.scheduleDate);
    userName.text = [NSString stringWithFormat:@"%@", customerInfoObject.customerName];
    userAddress.text = [NSString stringWithFormat:@"%@", customerInfoObject.customerAddress];
    scheduleLabel.text = [NSString stringWithFormat:@"%@", customerInfoObject.scheduleDate];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 200;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
