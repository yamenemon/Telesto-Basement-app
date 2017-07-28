//
//  ShowPriceViewController.m
//  Telesto Basement App
//
//  Created by CSM on 2/2/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ShowPriceViewController.h"
#import "DesignViewController.h"
#import "CustomProductView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ShowPriceViewController ()

@end

@implementation ShowPriceViewController
@synthesize showPriceTableCell,productArray,baseController,downloadedProduct;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _priceTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)viewWillAppear:(BOOL)animated{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    NSMutableArray *twoDArr = [NSMutableArray arrayWithCapacity:productArray.count];
    for (int i = 0; i<productArray.count; i++) {
        [twoDArr addObject:[NSNumber numberWithInt:1]];
    }
    
    
    for (CustomProductView *view in productArray) {
        [temp addObject:[NSNumber numberWithInt:view.productObject.productId]];
    }
    
    NSCountedSet *set = [[NSCountedSet alloc] initWithArray:temp];
    NSMutableArray *countedArr = [[NSMutableArray alloc] init];
    int i = 0;
    for (id item in set) {
        NSLog(@"Name=%@, Count=%lu", item, (unsigned long)[set countForObject:item]);
        [countedArr insertObject:item atIndex:i];
        i++;
    }
    NSLog(@"Inset object: %@",countedArr);
    
    
    for (int i = 0; i < downloadedProduct.count; i++) {
        Product *proObj = [downloadedProduct objectAtIndex:i];
        for (int j = 0; j< productArray.count; j++) {
            CustomProductView *view = [productArray objectAtIndex:j];
            if ([[NSNumber numberWithInt:proObj.productId] isEqualToNumber:[NSNumber numberWithInt:view.productID]]) {
                view.productObject.productName = proObj.productName;
                [productArray replaceObjectAtIndex:j withObject:view];
            }
        }
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return productArray.count+2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"PriceTableCell";
    
    ShowPriceTableViewCell *cell = (ShowPriceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (showPriceTableCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShowPriceTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row == 0) {
        cell.productName.text = @"Product Name";
        cell.quantityxPrice.text = @"Quantity x Price";
        cell.totalPrice.text = @"Price";
        
        cell.discountTextField.text = @"Percentage Discount (%)";
        cell.discountPriceTextField.text = @"Price Discount ($)";
        
        cell.discountTextField.borderStyle = UITextBorderStyleNone;
        cell.discountPriceTextField.borderStyle = UITextBorderStyleNone;
        
        [cell.productName setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        

        [cell.discountTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.discountTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.discountPriceTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.discountPriceTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == productArray.count+1){
        cell.productName.text = @"";
        cell.quantityxPrice.text = @"Total";
        cell.discountTextField.hidden = YES;
        cell.discountPriceTextField.hidden = YES;
        int sum = 0;
        for (int j = 0; j< productArray.count; j++) {
            CustomProductView *view = [productArray objectAtIndex:j];
            sum = sum + view.productObject.productPrice;
        }
        cell.totalPrice.text = [NSString stringWithFormat:@"%d",sum];
    } else{
        CustomProductView *view = [productArray objectAtIndex:indexPath.row-1];
        cell.productName.textAlignment = NSTextAlignmentCenter;

        cell.productName.text = view.productObject.productName;
        cell.quantityxPrice.text = [NSString stringWithFormat:@"1 %@ x $ %.2f",view.productObject.unitType,view.productObject.productPrice];
        if ([view.productObject.unitType isEqualToString:@"piece"]) {
            cell.discountTextField.text = [NSString stringWithFormat:@"%.2f",view.productObject.discount];
        }
        cell.totalPrice.text = [NSString stringWithFormat:@"$ %.2f",view.productObject.productPrice];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    label.textColor = [UIColor whiteColor];
    NSString *string =@"Price Summary";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:UIColorFromRGB(0x0A5A78)]; //your background color...
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"PriceTableFooterView"
                                                      owner:self
                                                    options:nil];
    
    PriceTableFooterView *view = [ nibViews objectAtIndex:0];
    return view;
}
@end
