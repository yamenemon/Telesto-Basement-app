//
//  ProposalViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProposalViewController.h"
#import "DesignViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ProposalViewController (){
    float summation;
}
@property (weak, nonatomic) IBOutlet UITableView *pricingTable;

@end

@implementation ProposalViewController
@synthesize agreementTextView,floorPlanImageView,screenShotImagePath,baseController,productArr,downloadedProduct,priceListArray,showPriceTableCell,pdfPath,screenShotArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationItem.hidesBackButton = YES;
    [self initializeController];
    _priceTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _priceTable.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(textViewTapped:)];
    tap.delegate = self;
    tap.numberOfTapsRequired = 1;
    [agreementTextView addGestureRecognizer:tap];
}
- (void)textViewTapped:(UITapGestureRecognizer *)tap {
    //DO SOMTHING
    AgreementPopUp *agreementView = [[[NSBundle mainBundle] loadNibNamed:@"AgreementPopUp" owner:self options:nil] objectAtIndex:0];
    popupController = [[CNPPopupController alloc] initWithContents:@[agreementView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
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
    defaultTheme.shouldDismissOnBackgroundTouch = YES;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = self.view.frame.size.width/2;
    defaultTheme.animationDuration = 0.65f;
    return defaultTheme;
}
#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)initializeController{
    if (screenShotImagePath.length>0) {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:screenShotImagePath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        floorPlanImageView.image = thumbNail;
    }
    summation = 0;
    
    for (int i = 0; i < downloadedProduct.count; i++) {
        Product *proObj = [downloadedProduct objectAtIndex:i];
        for (int j = 0; j< productArr.count; j++) {
            CustomProductView *view = [productArr objectAtIndex:j];
            if ([[NSNumber numberWithInt:proObj.productId] isEqualToNumber:[NSNumber numberWithInt:view.productID]]) {
                view.productObject.productName = proObj.productName;
                view.productObject.unitType = proObj.unitType;
                [productArr replaceObjectAtIndex:j withObject:view];
            }
        }
    }
    priceListArray = [[NSMutableArray alloc] initWithArray:productArr];
    
    NSMutableArray *toDelete = [NSMutableArray array];
    for (CustomProductView *view in priceListArray) {
        if (view.productObject.productId == 999999) {
            [toDelete addObject:view];
        }
    }
    // Remove them
    [priceListArray removeObjectsInArray:toDelete];
    
    NSLog(@"%@",priceListArray);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return priceListArray.count+2;
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
        cell.quantityxPrice.text = @"Price";
        cell.totalPrice.text = @"Price";
        
        cell.discountTextField.text = @"(%) Discount";
        cell.discountPriceTextField.text = @"($) Discount";
        cell.editBtn.hidden = YES;
        
        cell.discountTextField.borderStyle = UITextBorderStyleNone;
        cell.discountPriceTextField.borderStyle = UITextBorderStyleNone;
        
        [cell.productName setFont:[UIFont fontWithName:@"Roboto-Bold" size:12]];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        
        
        [cell.discountTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:12]];
        cell.discountTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.discountPriceTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:12]];
        cell.discountPriceTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:12]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:12]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
    }
    else if (indexPath.row == priceListArray.count+1){
        cell.productName.text = @"";
        cell.quantityxPrice.text = @"Total";
        cell.discountTextField.hidden = YES;
        cell.discountPriceTextField.hidden = YES;
        cell.editBtn.hidden = YES;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:15]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:15]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        cell.totalPrice.text = [NSString stringWithFormat:@"$ %d",summation];
        summation = 0;
    } else{
        [cell.productName setFont:[UIFont fontWithName:@"Roboto-Bold" size:10]];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        
        
        [cell.discountTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:10]];
        cell.discountTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.discountPriceTextField setFont:[UIFont fontWithName:@"Roboto-Bold" size:10]];
        cell.discountPriceTextField.textAlignment = NSTextAlignmentCenter;
        
        [cell.quantityxPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:10]];
        cell.quantityxPrice.textAlignment = NSTextAlignmentCenter;
        
        [cell.totalPrice setFont:[UIFont fontWithName:@"Roboto-Bold" size:10]];
        cell.totalPrice.textAlignment = NSTextAlignmentCenter;
        
        
        CustomProductView *view = [priceListArray objectAtIndex:indexPath.row-1];
        cell.productName.textAlignment = NSTextAlignmentCenter;
        cell.productName.text = view.productObject.productName;
        cell.discountTextField.tag = indexPath.row-1;
        cell.discountPriceTextField.tag = indexPath.row-1;
        cell.editBtn.tag = indexPath.row-1;
        cell.editBtn.hidden = YES;
        cell.quantityxPrice.text = [NSString stringWithFormat:@"$ %.2f",view.productObject.productPrice];
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
    
    return view;
}
-(UIImage*)takingScreenShot{
    CGRect rect = [_priceTable bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_priceTable.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}
- (IBAction)FaqListBtnAction:(id)sender {
}
- (IBAction)emailToCustomerAction:(id)sender {
    
    NSMutableArray *totalArray = [[NSMutableArray alloc] init];
    
    UIImage *agreementImage = [UIImage imageNamed:@"agreement"];
    [totalArray addObject:agreementImage];
    
    for (id obj in [Utility sharedManager].faqImageArray) {
        [totalArray addObject:obj];
    }
    
    NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:screenShotImagePath]];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    [totalArray addObject:thumbNail];
    
    UIImage*priceImage = [self takingScreenShot];
    [totalArray addObject:priceImage];
    
    SignaturePopUpView *signaturePopUpView = [[[NSBundle mainBundle] loadNibNamed:@"SignaturePopUpView" owner:self options:nil] objectAtIndex:0];
    [signaturePopUpView pdfCreation:totalArray];
    signaturePopUpView.baseController = self;
    popupController = [[CNPPopupController alloc] initWithContents:@[signaturePopUpView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
    
    
}
-(void)removePopUpView{
    [popupController dismissPopupControllerAnimated:YES];
}
-(void)showEmailComposerWithPdfPath:(NSString*)pathString{

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"Email From Telestho Application"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"emon.ioscsm@gmail.com", nil];
        [mailer setToRecipients:toRecipients];
        
        
        NSData *pdfData = [NSData dataWithContentsOfFile: pathString];
        
        [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"Proposal.pdf"];

        
        NSString *messageBody = @"Hi ! \n Below I send you the proposal pdf.";
        
        [mailer setMessageBody:messageBody isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:NULL];
        
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error!!!"
                                      message:@"Mailbox is not configured."
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

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%ld",(long)result);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSLog(@"%d", baseController.currentActiveTemplateID);
        NSLog(@"%@", baseController.templateNameString);
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfPath];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        if (screenShotArray.count>0) {
            NSMutableDictionary *templateDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:baseController.currentActiveTemplateID],@"templateId",
                                                baseController.templateNameString,@"templateName",
                                                [screenShotArray lastObject],@"signature",
                                                pdfData,@"pdfFile",nil];
            
            CustomerDataManager *manager = [CustomerDataManager sharedManager];
            [manager savingUserPDFWithBaseController:self withObjects:templateDic withCompletionBlock:^(BOOL success){
                if (success) {
                    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    CustomerListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerListViewController"];
                    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                    [self.navigationController pushViewController:vc animated:YES];
                    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                }
                else{
                    NSLog(@"Not saved");
                }
                
            }];
        }
        
    }];
}
- (IBAction)sendToOffice:(id)sender {
}
@end
