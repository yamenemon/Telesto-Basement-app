//
//  ProposalViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProposalViewController.h"

@interface ProposalViewController ()
@property (weak, nonatomic) IBOutlet UITableView *pricingTable;

@end

@implementation ProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    tableView.backgroundColor = [UIColor clearColor];
    
    UILabel *productName;
    UILabel *quantity;
    UILabel *price;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];

        productName = [[UILabel alloc] init];
        productName.frame = CGRectMake(5, 5, tableView.frame.size.width/3 - 5, 35);
        productName.backgroundColor =[UIColor clearColor];
        [cell addSubview:productName];
        productName.tag = 1;
        
        quantity = [[UILabel alloc] init];
        quantity.frame = CGRectMake(productName.frame.size.width + 10, 5, tableView.frame.size.width/3 - 5, 35);
        [cell addSubview:quantity];
        quantity.backgroundColor = [UIColor clearColor];
        quantity.tag = 2;
        quantity.textAlignment = NSTextAlignmentCenter;
        
        price = [[UILabel alloc] init];
        price.frame = CGRectMake(quantity.frame.size.width+productName.frame.size.width+15, 5, tableView.frame.size.width/3 - 5, 35);
        [cell addSubview:price];
        price.backgroundColor = [UIColor clearColor];
        price.tag = 3;
    }
    else{
        productName = [cell viewWithTag:1];
        quantity = [cell viewWithTag:2];
        price = [cell viewWithTag:3];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
            productName.text = @"Product Name";
            quantity.text = @"Quantity";
            price.text = @"Price";
            break;
        case 1:
            productName.text = @"Greate Sump Plus";
            quantity.text = @"1";
            price.text = @"$500";
            break;
        case 2:
            productName.text = @"Vapor Barrier";
            quantity.text = @"2";
            price.text = @"$300";
            break;
        case 3:
            productName.text = @"Greate Trench";
            quantity.text = @"1";
            price.text = @"$100";
            break;
        case 4:
            productName.text = @"Fast Sump";
            quantity.text = @"1";
            price.text = @"$500";
            break;
        case 5:
            productName.text = @"Battery Backup";
            quantity.text = @"1";
            price.text = @"600";
            break;
        case 6:
            productName.text =@"Data Sump";
            quantity.text = @"1";
            price.text = @"100";
            break;
        case 7:
            productName.text =@"Corner Port";
            quantity.text = @"1";
            price.text = @"$100";
            break;
        case 8:
            productName.text =@"Finish Shield";
            quantity.text = @"1";
            price.text = @"$1000";
            break;
        case 10:
            productName.text =@"Total";
            quantity.text = @"= 9";
            price.text = @"= $3200";
            break;
            
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width, 25)];
    [label setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string =@"Pricing";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}
- (IBAction)FaqListBtnAction:(id)sender {
}
- (IBAction)emailToCustomerAction:(id)sender {
    
}

@end
