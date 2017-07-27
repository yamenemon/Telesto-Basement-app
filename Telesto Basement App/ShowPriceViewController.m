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
    
    
}
-(void)viewWillAppear:(BOOL)animated{

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    NSMutableArray *totalArr = [[NSMutableArray alloc] init];
    
    NSMutableArray *twoDArr = [NSMutableArray arrayWithCapacity:productArray.count];
    for (int i = 0; i<productArray.count; i++) {
        [twoDArr addObject:[NSNumber numberWithInt:1]];
    }
    for (CustomProductView *view in productArray) {
        [temp addObject:[NSNumber numberWithInt:view.productObject.productId]];
    }
    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:temp];
    NSLog(@"%@", countedSet);
    for (int i = 0; i < downloadedProduct.count-1; i++) {
        Product *proObj = [downloadedProduct objectAtIndex:i];
        for (int j = 0; j< productArray.count-1; j++) {
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
    
    return productArray.count+1;
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
        cell.discount.text = @"Discount";
        cell.totalPrice.text = @"Price";
        [cell.productName setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.discount setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.discount.textAlignment = NSTextAlignmentCenter;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
        cell.totalPrice.textAlignment = NSTextAlignmentRight;
    }
    else{
        CustomProductView *view = [productArray objectAtIndex:indexPath.row-1];
        cell.productName.text = view.productObject.productName;
        cell.quantityxPrice.text = [NSString stringWithFormat:@"1 x $ %.2f",view.productObject.productPrice];
        cell.discount.text = [NSString stringWithFormat:@"%.2f%%",view.productObject.discount];
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

@end
