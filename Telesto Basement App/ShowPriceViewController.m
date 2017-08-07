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
#import "PricePopOver.h"
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
    summation = 0;
    
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
        
        cell.discountTextField.text = @"(%) Discount";
        cell.discountPriceTextField.text = @"($) Discount";
        cell.editBtn.hidden = YES;
        
        cell.discountTextField.borderStyle = UITextBorderStyleNone;
        cell.discountPriceTextField.borderStyle = UITextBorderStyleNone;
        
        [cell.productName setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        

        [cell.discountTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
        cell.discountTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.discountPriceTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
        cell.discountPriceTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:16]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == productArray.count+1){
        cell.productName.text = @"";
        cell.quantityxPrice.text = @"Total";
        cell.discountTextField.hidden = YES;
        cell.discountPriceTextField.hidden = YES;
        cell.editBtn.hidden = YES;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        cell.totalPrice.text = [NSString stringWithFormat:@"$ %.2f",summation];
        summation = 0;
    } else{
        CustomProductView *view = [productArray objectAtIndex:indexPath.row-1];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        cell.productName.text = view.productObject.productName;
        
        
        cell.discountTextField.tag = indexPath.row-1;
        cell.discountPriceTextField.tag = indexPath.row-1;
        cell.editBtn.tag = indexPath.row-1;
        [cell.editBtn addTarget:self action:@selector(priceDiscountPopUP:) forControlEvents:UIControlEventTouchUpInside];
        cell.quantityxPrice.text = [NSString stringWithFormat:@"1 %@ x $ %.2f",view.productObject.unitType,view.productObject.productPrice];
        if ([view.productObject.unitType isEqualToString:@"piece"]) {
            cell.discountTextField.text = [NSString stringWithFormat:@"%.2f %%",view.productObject.discount];
        }
        float discountPrice = (view.productObject.discount * view.productObject.productPrice)/100;
        float totalPrice = view.productObject.productPrice -  discountPrice;
        cell.discountPriceTextField.text = [NSString stringWithFormat:@"$ %.2f",discountPrice];
        cell.totalPrice.text = [NSString stringWithFormat:@"$ %.2f",totalPrice];
        summation = summation +totalPrice;
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
    
//    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [saveButton addTarget:self
//               action:@selector(saveButtonAction:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
//    saveButton.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
//    saveButton.titleLabel.textColor = [UIColor whiteColor];
//    saveButton.frame = CGRectMake(tableView.frame.size.width - 160.0, 5, 150.0, 25.0);
//    saveButton.backgroundColor = [UIColor lightGrayColor];
//    saveButton.layer.cornerRadius = 5.0;
//    [view addSubview:saveButton];
    
//    UIButton *refreshbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [refreshbutton addTarget:self
//               action:@selector(refreshbuttonAction:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [refreshbutton setTitle:@"Refresh" forState:UIControlStateNormal];
//    refreshbutton.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
//    refreshbutton.titleLabel.textColor = [UIColor whiteColor];
//    refreshbutton.frame = CGRectMake(10, 5, 150.0, 25.0);
//    refreshbutton.backgroundColor = [UIColor grayColor];
//    refreshbutton.layer.cornerRadius = 5.0;
//    [view addSubview:refreshbutton];
    
    return view;
}
-(void)priceDiscountPopUP:(UIButton*)sender{
    int tag = (int)sender.tag;
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"PricePopOver" owner:self options:nil];
    pricePopOver = [ nibViews objectAtIndex:0];
    pricePopOver.showPriceVC = self;
    CustomProductView *view = [productArray objectAtIndex:tag];

    [pricePopOver editableWindowWithProductObject:view.productObject withSelectedItemTag:tag];
    [self showPopupWithStyle:CNPPopupStyleCentered];
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    popupController = [[CNPPopupController alloc] initWithContents:@[pricePopOver]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
- (CNPPopupTheme *)defaultTheme {
    CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 5.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = NO;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = self.view.frame.size.width/2;
    defaultTheme.animationDuration = 0.65f;
    return defaultTheme;
}
-(void)updateProductObjectWithObject:(ProductObject*)obj withSelectedRow:(int)selectedRow{
    [popupController dismissPopupControllerAnimated:YES];
    CustomProductView *view = [productArray objectAtIndex:selectedRow];
    view.productObject = obj;
    [productArray replaceObjectAtIndex:selectedRow withObject:view];
    [_priceTable reloadData];
}

-(void)refreshbuttonAction:(id)sender{
    [_priceTable reloadData];
}
@end
