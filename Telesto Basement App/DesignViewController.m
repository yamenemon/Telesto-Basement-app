//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"
#import "DRColorPicker.h"
#import "CustomerProposalObject.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define TOKEN_STRING @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH"
#define NON_PRODUCT_ID 999999
@interface DesignViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;
@end

@implementation DesignViewController
@synthesize productSliderView;
@synthesize basementDesignView;
@synthesize savedDesignArray;
@synthesize customTemplateNameView;
@synthesize productArray;
@synthesize infoBtnArray;
@synthesize downloadedProduct;
@synthesize productSliderCustomView;
@synthesize isFromNewProposals,userSelectedDataDictionary,currentActiveTemplateID,currentDefaultTemplateIndex,downloadedCustomTemplateProposalInfo;
@synthesize templateNameLabel;

#pragma mark - ViewControllers Super Methods

- (void)viewDidLoad{
    [super viewDidLoad];   
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Drawing Window";
    [self.navigationItem setHidesBackButton:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [basementDesignView addGestureRecognizer:gestureRecognizer];
    isShown = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setNeedsDisplay];
    });
    
    productArray = [[NSMutableArray alloc] init];
    self.color = [[DRColorPickerColor alloc] initWithColor:UIColor.blueColor];
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomTemplateNameView"
                                                      owner:self
                                                    options:nil];
    
    customTemplateNameView = [ nibViews objectAtIndex:0];
    customTemplateNameView.designViewController = self;
    templateNameLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    currentDefaultTemplateIndex = 10000;

    if (isFromNewProposals == YES) {
        [self setCustomTemplateName];
        NSLog(@"%@",userSelectedDataDictionary);
    }
}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated{

    leftNavBtnBar = [[[NSBundle mainBundle] loadNibNamed:@"LeftNavDrawingToolsView" owner:self options:nil] objectAtIndex:0];
    [self.navigationController.navigationBar addSubview:leftNavBtnBar];
    leftNavBtnBar.baseClass = self;
    
    rightNavBtnBar = [[[NSBundle mainBundle] loadNibNamed:@"RightNavDrwaingToolsView" owner:self options:nil] objectAtIndex:0];
    rightNavBtnBar.frame = CGRectMake(self.view.frame.size.width - rightNavBtnBar.frame.size.width, 0, rightNavBtnBar.frame.size.width, rightNavBtnBar.frame.size.height);
    [self.navigationController.navigationBar addSubview:rightNavBtnBar];
    rightNavBtnBar.baseClass = self;
    if (isFromNewProposals == NO) {
     [self reloadTheViewForEditing];
    }
}

-(void)saveTemplateName:(NSString*)templateName{
    _templateNameString = templateName;
    templateNameLabel.text = _templateNameString;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_templateNameString]];
    NSLog(@"Template path: %@",dataPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update the UI
        [customTemplateNameView dismissKeyboardFromCustomTemplateNameWindow];
        [self downloadProduct];

        [self.view endEditing:YES];
        isShown = YES;
        productSliderView.hidden = YES;
        [self productSliderCalled:nil];
        [self createProductScroller];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    });
    [self performSelector:@selector(initializeDesignWindow) withObject:nil afterDelay:1.0];

}
-(void)initializeDesignWindow{

    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager saveUserTemplateName:_templateNameString withUserFAQs:userSelectedDataDictionary withRootController:self withCompletionBlock:^(BOOL success){
        if (success == YES) {
            [customTemplateNameView.activityIndicator stopAnimating];
                [popupController dismissPopupControllerAnimated:YES];
        }
        else{
            NSLog(@"product not loaded");
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}
-(void)dismissController{
    [popupController dismissPopupControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    leftNavBtnBar.hidden = YES;
    rightNavBtnBar.hidden = YES;
}
#pragma mark -
#pragma mark - Popup Methods
-(void)openCameraWindow{

    [popupController dismissPopupControllerAnimated:YES];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)saveImage:(UIImage*)selectedImage {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d/%@.png",_templateNameString,lastClickedProductInfoBtn,selectedImage]];
    NSLog(@"Saving folder directory: %@",savedImagePath);
    NSData *imageData = UIImagePNGRepresentation(selectedImage);
    dispatch_async(dispatch_get_main_queue(), ^{
        [imageData writeToFile:savedImagePath atomically:YES];
    });
}
- (void)showVideoPopupWithStyle:(CNPPopupStyle)popupStyle withSender:(UIButton*)sender{
    
    NSLog(@"sender tag: %ld", (long)sender.tag);
    for (int i = 1; i<productArray.count; i++) {
        UIView *view = [productArray objectAtIndex:i];
        BOOL isCustomProductClass = [view isKindOfClass:[CustomProductView class]];
        if (isCustomProductClass == YES) {
            CustomProductView*view = [productArray objectAtIndex:i];
            if (sender.tag == view.infoBtn.tag) {
                NSLog(@"Same tag");
            }
        }
    }
    customVideoPopUpView = [[[NSBundle mainBundle] loadNibNamed:@"CustomVideoPopUpView" owner:self options:nil] objectAtIndex:0];
    customVideoPopUpView.baseView = self;
    lastClickedProductInfoBtn = (int)sender.tag;
    customVideoPopUpView.selectedVideoPopUpBtnTag = (int)sender.tag;
    customVideoPopUpView.userCapturedImageUrl = _templateNameString;
    [customVideoPopUpView initGalleryItems];
    isFromProduct = YES;
    popupController = [[CNPPopupController alloc] initWithContents:@[customVideoPopUpView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    popupController = [[CNPPopupController alloc] initWithContents:@[customTemplateNameView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.delegate = self;
    popupController.theme.shouldDismissOnBackgroundTouch = NO;
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
#pragma mark -
#pragma mark - Product Slider Methods
-(void)downloadProduct{

    // DOWNLOAD PRODUCT HERE
    //-----------------------
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    downloadedProduct = [[NSMutableArray alloc] init];
    downloadedProduct = [[manager getProductObjectArray] objectAtIndex:0];
//    NSLog(@"%@",downloadedProduct);
}
-(void)createProductScroller{
    int y = 0;
    CGRect frame;
    productNameArray = [[NSMutableArray alloc] init];
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    for (int i = 0; i < downloadedProduct.count-1; i++) {
        
        Product *proObj = [downloadedProduct objectAtIndex:i];
        
        NSArray*customSliderButtonView = [[NSBundle mainBundle] loadNibNamed:@"ProductSliderCustomView" owner:self options:nil];
        productSliderCustomView = [customSliderButtonView objectAtIndex:0];
        productSliderCustomView.designViewController = self;
        productSliderCustomView.backgroundColor = [UIColor clearColor];

        if (i == 0) {
            frame = CGRectMake(0,
                               5,
                               self.productSliderScrollView.frame.size.width,
                               self.productSliderCustomView.frame.size.height);
        } else {
            frame = CGRectMake(0,
                               (i * productSliderCustomView.frame.size.height) + 10,
                               self.productSliderScrollView.frame.size.width,
                               productSliderCustomView.frame.size.height);
        }
    
        productSliderCustomView.frame = frame;
        [productSliderCustomView setNeedsLayout];
        [productSliderCustomView.productBtn setTag:i+1];
        NSString *imageUrl = [manager loadProductImageWithImageName:proObj.productName];
//        NSLog(@"Product image url: %@",imageUrl);

        [productSliderCustomView.productBtn setBackgroundImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
        [productSliderCustomView.productBtn addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.productSliderScrollView addSubview:productSliderCustomView];
        
        if (i == downloadedProduct.count-2) {
            y = CGRectGetMaxY(productSliderCustomView.frame);
        }
        productSliderCustomView.productName.text = [NSString stringWithFormat:@"%@",proObj.productName];
        [productNameArray addObject:proObj.productName];
    }
    
    self.productSliderScrollView.contentSize = CGSizeMake(self.productSliderScrollView.frame.size.width,y);
    self.productSliderScrollView.backgroundColor = [UIColorFromRGB(0x0A5A78) colorWithAlphaComponent:0.3]; ;
    [productSliderView addSubview:self.productSliderScrollView];
    productSliderView.hidden = NO;
    
    _productInWindowArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< downloadedProduct.count; i++) {
        Product *product = (Product*)[downloadedProduct objectAtIndex:i];
        [_productInWindowArray addObject:[NSNumber numberWithInt:product.productId]];
    }
}
-(void)showProductDetailsPopUp:(int)btnTag{
    
    Product *product = [downloadedProduct objectAtIndex:btnTag];
    
    NSArray*ProductInfoDetailsPopupView = [[NSBundle mainBundle] loadNibNamed:@"ProductInfoDetailsPopupView" owner:self options:nil];
    self.productInfoDetails = [ProductInfoDetailsPopupView objectAtIndex:0];
    self.productInfoDetails.designViewController = self;
    self.productInfoDetails.productName.text = product.productName;
    self.productInfoDetails.productPrice.text = [NSString stringWithFormat:@"%f",product.productPrice];
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    NSString *imageUrl = [manager loadProductImageWithImageName:product.productName];
//    NSLog(@"Product image url: %@",imageUrl);
    self.productInfoDetails.productDetailImage.image = [UIImage imageNamed:imageUrl];
    self.productInfoDetails.productDescriptions.text = product.productDescription;
    
    popupController = [[CNPPopupController alloc] initWithContents:@[self.productInfoDetails]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
-(void)clickOnProduct:(int)btnTag{
    NSString *productCurrentId = [NSString stringWithFormat:@"%@",[_productInWindowArray objectAtIndex:btnTag]];
    
    NSString *newFolderId = [NSString stringWithFormat:@"%@%d",productCurrentId,btnTag];
    [self saveUserSelectedProductInfo:newFolderId];
    for (int i=0; i<_productInWindowArray.count; i++) {
        if (i == btnTag) {
            [_productInWindowArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",newFolderId]];
        }
    }
    Product *product = [downloadedProduct objectAtIndex:btnTag];
    
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    NSString *imageUrl = [manager loadProductImageWithImageName:product.productName];
//    NSLog(@"Product image url: %@",imageUrl);
    
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(100, 10, 90, 90);

    CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
    userResizableView.infoBtn.tag = [newFolderId intValue];
    
    
    NSLog(@"sender tag: %ld",(long)userResizableView.infoBtn.tag);
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageUrl]];
    contentView.frame = gripFrame;
    userResizableView.contentView = contentView;
    
    userResizableView.productID = product.productId;
    userResizableView.productObject.productId = product.productId;
    userResizableView.productObject.productName = imageUrl;
    userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
    userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
    userResizableView.productObject.productWidth = contentView.frame.size.width;
    userResizableView.productObject.productHeight = contentView.frame.size.height;
    userResizableView.productObject.productPrice = product.productPrice;
    userResizableView.productObject.unitType = product.unitType;
    userResizableView.productObject.discount = product.discount;
    
    userResizableView.baseVC = self;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [basementDesignView addSubview:userResizableView];
    [userResizableView bringSubviewToFront:userResizableView.infoBtn];
    [self productSliderCalled:nil];
    
    [productArray addObject:lastEditedView];
    NSLog(@"Array after Adding: %@",productArray);
}
-(void)productBtnClicked:(id)sender{
    UIButton *productBtn = (UIButton*)sender;
    [self clickOnProduct:(int)productBtn.tag - 1];
}
#pragma mark -
#pragma mark Save User Design
#pragma mark -
-(void)saveUserDesignToServer{
    NSLog(@"Product Array: %@",productArray);
    if (productArray.count>0) {
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        for (int i=0; i<productArray.count; i++) {
            CustomProductView *view = [productArray objectAtIndex:i];
            NSMutableArray *imagePath = [self listFileAtPath:_templateNameString withTag:(int)view.infoBtn.tag];
            view.productObject.storedMediaArray = imagePath;
            view.productObject.imageCount = (int)imagePath.count;
            [productArray replaceObjectAtIndex:i withObject:view];
            NSLog(@"Product object: %@ %f %f %f %f %f %d %@",
                  view.productObject.productName,
                  view.productObject.productPrice,
                  view.productObject.productXcoordinate,
                  view.productObject.productYcoordinate,
                  view.productObject.productWidth,
                  view.productObject.productHeight,
                  view.productObject.imageCount,
                  view.productObject.storedMediaArray);
        }
        
        
        CustomerDataManager *manager = [CustomerDataManager sharedManager];
        [manager saveUserDesignWithBaseController:self withCustomTemplateID:currentActiveTemplateID withCustomTemplateName:_templateNameString withProductArray:productArray withCompletionBlock:^(BOOL success){
            if (success == YES) {
                
                [manager saveCustomTemplatewithCustomTemplateID:currentActiveTemplateID withCustomTemplateName:_templateNameString withScreenShot:[[Utility sharedManager] loadScreenShotImageWithImageName:_templateNameString] withDefaultTemplateId:currentDefaultTemplateIndex withCompletionBlock:^(BOOL success){
                    if (success == YES) {
                        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ProposalViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProposalViewController"];
                        vc.screenShotImagePath = screenShotImagePath;
                        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else{
                        NSLog(@"Not uploaded show the alert");
                    }
                }];
            }
            else{
                NSLog(@"Not uploaded show the alert");
            }
        }];
    }
    else{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error!!!"
                                      message:@"Add Some Products in Drawing Window."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [hud removeFromSuperview];
                             }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
    
}
-(NSMutableArray *)listFileAtPath:(NSString *)path withTag:(int)tag
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    NSLog(@"Path of the image: %@",path);
    int count;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%d",path,tag]];
    NSLog(@"product folder path: %@",dataPath);
    
    NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",dataPath,[directoryContent objectAtIndex:count]];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [imagePathArray addObject:thumbNail];
    }
    return imagePathArray;
}
-(void)saveUserSelectedProductInfo:(NSString*)folderName{

    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%@",_templateNameString,folderName]];
    NSLog(@"product folder path: %@",dataPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    NSInteger index = [productArray indexOfObject:lastEditedView];
    CustomProductView *productView = (CustomProductView*)[productArray objectAtIndex:index];

    productView.productObject = [self updateProductObject:productView.productObject withObject:userResizableView];
    
    [productArray replaceObjectAtIndex:index withObject:productView];
    lastEditedView = userResizableView;
}
-(ProductObject*)updateProductObject:(ProductObject*)oldObject withObject:(SPUserResizableView*)newObject {
    oldObject.productId = oldObject.productId;
    oldObject.productXcoordinate = newObject.frame.origin.x;
    oldObject.productYcoordinate = newObject.frame.origin.y;
    oldObject.productWidth = newObject.frame.size.width;
    oldObject.productHeight = newObject.frame.size.height;
    return oldObject;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    return YES;
}
- (void)hideEditingHandles {
    // We only want the gesture recognizer to end the editing session on the last
    // edited view. We wouldn't want to dismiss an editing session in progress.
    [lastEditedView hideEditingHandles];
}
- (IBAction)productSliderCalled:(id)sender {
    
    if (isShown==NO) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = productSliderView.frame;
                             frame.origin.x = 0;
                             productSliderView.frame = frame;
                         } completion:nil];
        isShown = YES;
    }
    else{
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = productSliderView.frame;
                             frame.origin.x = - frame.size.width+30;
                             productSliderView.frame = frame;
                         } completion:nil];
        isShown = NO;
    }
}
#pragma mark - Navigation Tools Actions Methods

- (void)revealButtonItemClicked:(id)sender{

    UIButton *menuBtn = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *newTemplate =  [UIAlertAction actionWithTitle: @"New Template" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"New Template"
                                      message:@"Do you want to take new template?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 for (UIView *subview in [basementDesignView subviews]) {
                                         [subview removeFromSuperview];
                                 }
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"NO"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    [newTemplate setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:newTemplate];
    
    
    UIAlertAction *savedTemplate =  [UIAlertAction actionWithTitle: @"Saved Template" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self savedTemplateButtonAction:sender];

    }];
//    [savedTemplate setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [savedTemplate setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:savedTemplate];
    
    UIAlertAction *checkList =  [UIAlertAction actionWithTitle: @"CheckList" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewController"];
        vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
//    [checkList setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [checkList setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:checkList];
    
    
    UIAlertAction *showPrice =  [UIAlertAction actionWithTitle: @"Show Price" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (productArray.count>0) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ShowPriceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ShowPriceViewController"];
            vc.preferredContentSize = CGSizeMake(910, 750);
            vc.baseController = self;
            vc.productArray = productArray;
            vc.downloadedProduct = downloadedProduct;
//            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            [self.navigationController pushViewController:vc animated:YES];
            
            vc.modalPresentationStyle = UIModalPresentationPopover;
            UIPopoverPresentationController *popPC = vc.popoverPresentationController;
            vc.popoverPresentationController.sourceRect = menuBtn.bounds;
            vc.popoverPresentationController.sourceView = menuBtn;
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.delegate = self;
            [self presentViewController:vc animated:YES completion:nil];
            
//            popupController = [[CNPPopupController alloc] initWithContents:@[vc]];
//            popupController.theme = [self defaultTheme];
//            popupController.theme.popupStyle = CNPPopupStyleCentered;
////            popupController.delegate = self;
//            [popupController presentPopupControllerAnimated:YES];
        }
        else{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Error!!!"
                                          message:@"Add Some Products in Drawing Window."
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
    }];
    [showPrice setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:showPrice];
    
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = menuBtn;
    popover.sourceRect = menuBtn.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];

}
- (void)wallPopOverBtnAction:(id)sender {
    
    UIButton *wallBtn = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                            message: nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *horizentalAction =  [UIAlertAction actionWithTitle: @"Horizental Line" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(30, 0, 100, 30);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        
        UIGraphicsBeginImageContext(contentView.frame.size);
        [[UIImage imageNamed:@"horizentalWall"] drawInRect:contentView.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [contentView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"horizentalWall";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [horizentalAction setValue:[[UIImage imageNamed:@"horizentalWall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [horizentalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];

    [alertController addAction:horizentalAction];

    
    UIAlertAction *verticalAction =  [UIAlertAction actionWithTitle: @"Vertical Line" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(0, 0, 30, 100);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        UIGraphicsBeginImageContext(contentView.frame.size);
        [[UIImage imageNamed:@"verticalWall"] drawInRect:contentView.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [contentView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"verticalWall";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [verticalAction setValue:[[UIImage imageNamed:@"verticalWall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [verticalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [alertController addAction:verticalAction];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = wallBtn;
    popover.sourceRect = wallBtn.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)stairButtonAction:(id)sender{

    UIButton *stairBtn = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *upStair =  [UIAlertAction actionWithTitle: @"Up Stair" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 70, 100);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"stairUp"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"stairUp";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [upStair setValue:[[UIImage imageNamed:@"stairUp"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [upStair setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:upStair];
    
    
    UIAlertAction *leftStair =  [UIAlertAction actionWithTitle: @"Left Stair" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 100, 70);

        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"stairLeft"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"stairLeft";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [leftStair setValue:[[UIImage imageNamed:@"stairLeft"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [leftStair setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [alertController addAction:leftStair];
    
    
    UIAlertAction *rightStair =  [UIAlertAction actionWithTitle: @"Right Stair" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 100, 70);

        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"stairRight"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"stairRight";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [rightStair setValue:[[UIImage imageNamed:@"stairRight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [rightStair setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [alertController addAction:rightStair];
    
    
    UIAlertAction *downStair =  [UIAlertAction actionWithTitle: @"Down Stair" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 70, 100);

        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"stairBottom"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"stairBottom";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [downStair setValue:[[UIImage imageNamed:@"stairBottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [downStair setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [alertController addAction:downStair];
    
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = stairBtn;
    popover.sourceRect = stairBtn.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];

}
- (void)doorButtonAction:(id)sender{
    
    UIButton *doorButton = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *flipTop =  [UIAlertAction actionWithTitle: @"Top Side Door" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 50, 50);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"flipTop"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"flipTop";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [flipTop setValue:[[UIImage imageNamed:@"flipTop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [flipTop setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:flipTop];
    
    
    UIAlertAction *flipLeft =  [UIAlertAction actionWithTitle: @"Left Side Door" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 50, 50);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"flipLeft"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"flipLeft";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [flipLeft setValue:[[UIImage imageNamed:@"flipLeft"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [flipLeft setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:flipLeft];
    
    UIAlertAction *flipRight =  [UIAlertAction actionWithTitle: @"Right Side Door" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 50, 50);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"flipRight"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"flipRight";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [flipRight setValue:[[UIImage imageNamed:@"flipRight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [flipRight setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:flipRight];
    
    UIAlertAction *flipBottom =  [UIAlertAction actionWithTitle: @"Bottom Side Door" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 50, 50);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"flipBottom"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"flipBottom";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [flipBottom setValue:[[UIImage imageNamed:@"flipBottom"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [flipBottom setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:flipBottom];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = doorButton;
    popover.sourceRect = doorButton.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)windowSliderButtonAction:(id)sender{
    
    UIButton *windowSliderButton = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *HorizontalWindow =  [UIAlertAction actionWithTitle: @"Horizontal Window" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 100, 30);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"sliderWindowHorizontal_big"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"sliderWindowHorizontal_big";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [HorizontalWindow setValue:[[UIImage imageNamed:@"sliderWindowHorizontal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [HorizontalWindow setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:HorizontalWindow];
    
    
    UIAlertAction *verticalWindow =  [UIAlertAction actionWithTitle: @"Vertical Window" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CGRect gripFrame = CGRectMake(30, 0, 30, 100);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"sliderWindowVertical_Big"]]];
        userResizableView.contentView = contentView;
        
        userResizableView.productID = NON_PRODUCT_ID;
        userResizableView.productObject.productId = NON_PRODUCT_ID;
        userResizableView.productObject.productName = @"sliderWindowVertical_Big";
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = NON_PRODUCT_ID;
        userResizableView.productObject.unitType = @"NOT A PRODUCT";
        userResizableView.productObject.discount = NON_PRODUCT_ID;
        
        
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];
    }];
    [verticalWindow setValue:[[UIImage imageNamed:@"sliderWindowVertical"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [verticalWindow setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:verticalWindow];
    

    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = windowSliderButton;
    popover.sourceRect = windowSliderButton.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)flipTheObject{
//    lastEditedView.transform = CGAffineTransformMakeRotation(M_PI_2);
//    [lastEditedView setNeedsDisplay];
}
- (void)saveButtonAction:(id)sender{

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Save Only!!!"
                                  message:@"What do you want to do?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Save & Continue"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self savedTemplateViewForScreenShot:_templateNameString withCompletionBlock:^(BOOL success){
                                     if (success) {
                                         [self saveUserDesignToServer];
                                     }
                                 }];
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];

}
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)removeBtnClicked{
    NSInteger removeObjectIndex =[productArray indexOfObject:lastEditedView];
    CustomProductView *productView = (CustomProductView*)[productArray objectAtIndex:removeObjectIndex];
    int lastSelectedProduct = productView.productID;
    NSLog(@"\nNew Array after removing: %@",productArray);
    
    //Remove folder from document directory
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Remove!!!"
                                  message:@"Do you want to delete?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yes = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [lastEditedView removeFromSuperview];
                             [productArray removeObjectAtIndex:removeObjectIndex];

                             NSFileManager *fileManager = [NSFileManager defaultManager];
                             
                             NSError *error;
                             NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                             NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
                             NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%d",_templateNameString,lastSelectedProduct]];
                             NSLog(@"product folder path: %@",dataPath);

                             BOOL success = [fileManager removeItemAtPath:dataPath error:&error];
                             if (success) {
                                 NSLog(@"Successfylly Deleted");
                             }
                             else {
                                 NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                             }

                         }];
    UIAlertAction* No = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    [alert addAction:yes];
    [alert addAction:No];
    
    [self presentViewController:alert animated:YES completion:nil];
    

}
-(void)saveDesignView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCustomTemplateName];
    });
}

-(void)savedTemplateViewForScreenShot:(NSString*)templateName withCompletionBlock:(void(^)(BOOL success))completionBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [basementDesignView bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [basementDesignView.layer renderInContext:context];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@%@.jpg",_templateNameString,_templateNameString,@"ScreenShot"]];
        screenShotImagePath = savedImagePath;
        [UIImageJPEGRepresentation(capturedImage, 0.95) writeToFile:savedImagePath atomically:YES];
        [popupController dismissPopupControllerAnimated:YES];
        completionBlock(YES);
    });
}
- (void)setCustomTemplateName{
    [self showPopupWithStyle:CNPPopupStyleCentered];
}

-(void)setSavedTemplateNumber:(NSString*)path withTemplateIndex:(int)defaultTemplateIndex{
    
    if (drawingImageView) {
        [drawingImageView removeFromSuperview];
    }
    drawingImageView = [[UIImageView alloc] init];
    currentDefaultTemplateIndex = defaultTemplateIndex;
    NSLog(@"Path %@ and default template index: %d",path,currentDefaultTemplateIndex);
    [templateController dismissViewControllerAnimated:YES completion:^{
        drawingImageView.frame = CGRectMake(0, 0, basementDesignView.frame.size.width, basementDesignView.frame.size.height);
        [drawingImageView setImage:[UIImage imageNamed:path]];
        [basementDesignView addSubview:drawingImageView];
    }];
}
- (void)savedTemplateButtonAction:(id)sender {
    UIButton*button = (UIButton*)sender;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    templateController = [sb instantiateViewControllerWithIdentifier:@"TemplatePopOverViewController"];
    templateController.parentClass = self;
    templateController.preferredContentSize = CGSizeMake(600, 500);
    
    templateController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPC = templateController.popoverPresentationController;
    templateController.popoverPresentationController.sourceRect = button.bounds;
    templateController.popoverPresentationController.sourceView = button;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.delegate = self;
    [self presentViewController:templateController animated:YES completion:nil];
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationPopover;
}
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}
#pragma mark -
#pragma mark Color Picker Methods -
- (void)showColorPickerButtonTapped:(id)sender{
    // Setup the color picker - this only has to be done once, but can be called again and again if the values need to change while the app runs
    //    DRColorPickerThumbnailSizeInPointsPhone = 44.0f; // default is 42
    //    DRColorPickerThumbnailSizeInPointsPad = 44.0f; // default is 54
    
    // REQUIRED SETUP....................
    // background color of each view
    DRColorPickerBackgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // border color of the color thumbnails
    DRColorPickerBorderColor = [UIColor blackColor];
    
    // font for any labels in the color picker
    DRColorPickerFont = [UIFont systemFontOfSize:16.0f];
    
    // font color for labels in the color picker
    DRColorPickerLabelColor = [UIColor blackColor];
    // END REQUIRED SETUP
    
    // OPTIONAL SETUP....................
    // max number of colors in the recent and favorites - default is 200
    DRColorPickerStoreMaxColors = 200;
    
    // show a saturation bar in the color wheel view - default is NO
    DRColorPickerShowSaturationBar = YES;
    
    // highlight the last hue in the hue view - default is NO
    DRColorPickerHighlightLastHue = YES;
    
    // use JPEG2000, not PNG which is the default
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerUsePNG = NO;
    
    // JPEG2000 quality default is 0.9, which really reduces the file size but still keeps a nice looking image
    // *** WARNING - NEVER CHANGE THIS ONCE YOU RELEASE YOUR APP!!! ***
    DRColorPickerJPEG2000Quality = 0.9f;
    
    // set to your shared app group to use the same color picker settings with multiple apps and extensions
    DRColorPickerSharedAppGroup = nil;
    // END OPTIONAL SETUP
    
    // create the color picker
    DRColorPickerViewController* vc = [DRColorPickerViewController newColorPickerWithColor:self.color];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.rootViewController.showAlphaSlider = YES; // default is YES, set to NO to hide the alpha slider
    
    NSInteger theme = 2; // 0 = default, 1 = dark, 2 = light
    
    // in addition to the default images, you can set the images for a light or dark navigation bar / toolbar theme, these are built-in to the color picker bundle
    if (theme == 0)
    {
        // setting these to nil (the default) tells it to use the built-in default images
        vc.rootViewController.addToFavoritesImage = nil;
        vc.rootViewController.favoritesImage = nil;
        vc.rootViewController.hueImage = nil;
        vc.rootViewController.wheelImage = nil;
        vc.rootViewController.importImage = nil;
    }
    else if (theme == 1)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-addtofavorites-dark.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/dark/drcolorpicker-favorites-dark.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/dark/drcolorpicker-hue-v3-dark.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/dark/drcolorpicker-wheel-dark.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/dark/drcolorpicker-import-dark.png");
    }
    else if (theme == 2)
    {
        vc.rootViewController.addToFavoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-addtofavorites-light.png");
        vc.rootViewController.favoritesImage = DRColorPickerImage(@"images/light/drcolorpicker-favorites-light.png");
        vc.rootViewController.hueImage = DRColorPickerImage(@"images/light/drcolorpicker-hue-v3-light.png");
        vc.rootViewController.wheelImage = DRColorPickerImage(@"images/light/drcolorpicker-wheel-light.png");
        vc.rootViewController.importImage = DRColorPickerImage(@"images/light/drcolorpicker-import-light.png");
    }
    
    // assign a weak reference to the color picker, need this for UIImagePickerController delegate
    self.colorPickerVC = vc;
    
    // make an import block, this allows using images as colors, this import block uses the UIImagePickerController,
    // but in You Doodle for iOS, I have a more complex import that allows importing from many different sources
    // *** Leave this as nil to not allowing import of textures ***
    vc.rootViewController.importBlock = ^(UINavigationController* navVC, DRColorPickerHomeViewController* rootVC, NSString* title)
    {
        UIImagePickerController* p = [[UIImagePickerController alloc] init];
        p.delegate = self;
        p.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.colorPickerVC presentViewController:p animated:YES completion:nil];
    };
    
    // dismiss the color picker
    vc.rootViewController.dismissBlock = ^(BOOL cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    // a color was selected, do something with it, but do NOT dismiss the color picker, that happens in the dismissBlock
    vc.rootViewController.colorSelectedBlock = ^(DRColorPickerColor* color, DRColorPickerBaseViewController* vc)
    {
        self.color = color;
        if (color.rgbColor == nil)
        {
            lastEditedView.contentView.backgroundColor = [UIColor colorWithPatternImage:color.image];

        }
        else
        {
            lastEditedView.contentView.backgroundColor = color.rgbColor;
        }
    };
    
    // finally, present the color picker
    [self presentViewController:vc animated:YES completion:nil];
}
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    // get the image
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (isFromProduct == YES) {
        [self saveImage:img];
        [picker dismissViewControllerAnimated:YES completion:nil];
        isFromProduct = NO;
    }
    else{
        // tell the color picker to finish importing
        [self.colorPickerVC.rootViewController finishImport:img];
        
        // dismiss the image picker
        [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    // image picker cancel, just dismiss it
    [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Editing Design View -

-(void)initializePreviousDataWithCompletionBlock:(void (^)(BOOL success))completionBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self downloadProduct];
        isShown = YES;
        productSliderView.hidden = YES;
        [self productSliderCalled:nil];
        [self createProductScroller];
        completionBlock (YES);
    });
}

-(void)reloadTheViewForEditing{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    // Add a task to the group
    dispatch_group_async(group, queue, ^{
        // Some asynchronous work
        
        [self initializePreviousDataWithCompletionBlock:^(BOOL success){
            if (success) {
                NSLog(@"%@",downloadedCustomTemplateProposalInfo);
                
                CustomerProposalObject *editingProposalObject = [downloadedCustomTemplateProposalInfo objectAtIndex:0];
                _templateNameString = editingProposalObject.templateName;
                templateNameLabel.text = _templateNameString;
                CustomerDataManager *manager = [CustomerDataManager sharedManager];
                if ((int)editingProposalObject.defaultTemplateID<[manager getTemplateObjectArray].count) {
                    [self setSavedTemplateNumber:[[manager getTemplateObjectArray] objectAtIndex:editingProposalObject.defaultTemplateID] withTemplateIndex:(int)editingProposalObject.defaultTemplateID];
                }
                for (CustomProductView *view in editingProposalObject.productArray) {
                    [self reloadProduct:view];
                }
                [self.view setNeedsDisplay];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        }];
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}
-(void)createFolderForEditing:(NSString*)templateName{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_templateNameString]];
    NSLog(@"Template path: %@",dataPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
}
-(void)reloadProduct:(CustomProductView*)productObject{
    if (productObject.productObject.productId<NON_PRODUCT_ID) {
            NSString *productCurrentId = [NSString stringWithFormat:@"%@",[_productInWindowArray objectAtIndex:productObject.productObject.productId]];
            
            NSString *newFolderId = [NSString stringWithFormat:@"%@%d",productCurrentId,productObject.productObject.productId];
            [self saveUserSelectedProductInfo:newFolderId];
            for (int i=0; i<_productInWindowArray.count; i++) {
                if (i == productObject.productObject.productId) {
                    [_productInWindowArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",newFolderId]];
                }
            }
            //    Product *product = [downloadedProduct objectAtIndex:productObject.productObject.productId]; // Don't uncomment it.
            
            CustomerDataManager *manager = [CustomerDataManager sharedManager];
            NSArray *arr = [productObject.productObject.productName componentsSeparatedByString:@"/"];
            NSString *newString = [arr lastObject];
            NSString *imageUrl = [manager loadProductImageWithImageName:newString];
            NSLog(@"Product image url: %@",imageUrl);
            
            // (1) Create a user resizable view with a simple red background content view.
            CGRect gripFrame = CGRectMake(productObject.productObject.productXcoordinate, productObject.productObject.productYcoordinate, productObject.productObject.productWidth,productObject.productObject.productHeight);
            NSLog(@"Product object: %f %f %f %f",productObject.productObject.productXcoordinate, productObject.productObject.productYcoordinate, productObject.productObject.productWidth,productObject.productObject.productHeight);
            CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
            userResizableView.infoBtn.tag = [newFolderId intValue];
            
            
            NSLog(@"sender tag: %ld",(long)userResizableView.infoBtn.tag);
            
            UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageUrl]];
            contentView.frame = gripFrame;
            userResizableView.contentView = contentView;
            
            userResizableView.productID = productObject.productObject.productId;
            userResizableView.productObject.productId = productObject.productObject.productId;
            userResizableView.productObject.productName = imageUrl;
            userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
            userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
            userResizableView.productObject.productWidth = contentView.frame.size.width;
            userResizableView.productObject.productHeight = contentView.frame.size.height;
            userResizableView.productObject.productPrice = productObject.productObject.productPrice;
            userResizableView.productObject.unitType = productObject.productObject.unitType;
            userResizableView.productObject.discount = productObject.productObject.discount;
            
            userResizableView.baseVC = self;
            userResizableView.delegate = self;
            [userResizableView showEditingHandles];
            currentlyEditingView = userResizableView;
            lastEditedView = userResizableView;
            [basementDesignView addSubview:userResizableView];
            [userResizableView bringSubviewToFront:userResizableView.infoBtn];
            [self productSliderCalled:nil];
            [self createFolderForEditing:newString];
            if (![productObject.productObject.storedMediaArray isKindOfClass:[NSNull class]]) {
                NSLog(@"productObject.productObject.storedMediaArray: %@",productObject.productObject.storedMediaArray);
                NSLog(@"Media count: %lu",(unsigned long)productObject.productObject.storedMediaArray.count);
                for (int i = 0; i<productObject.productObject.storedMediaArray.count; i++) {
                    [self saveImageWithBtnInfoTag:(int)userResizableView.infoBtn.tag withPath:_templateNameString withMediaImageUrl:productObject.productObject.storedMediaArray[i]];
                }
            }
            
            
            [productArray addObject:lastEditedView];
            NSLog(@"Array after Adding: %@",productArray);
        
    }
    else{
        // (1) Create a user resizable view with a simple red background content view.
        CGRect gripFrame = CGRectMake(productObject.productObject.productXcoordinate, productObject.productObject.productYcoordinate, productObject.productObject.productWidth,productObject.productObject.productHeight);
        NSLog(@"Product object: %f %f %f %f",productObject.productObject.productXcoordinate, productObject.productObject.productYcoordinate, productObject.productObject.productWidth,productObject.productObject.productHeight);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        
        
        UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",productObject.productObject.productName]]];
        contentView.frame = gripFrame;
        
        

        userResizableView.productID = productObject.productObject.productId;
        userResizableView.productObject.productId = productObject.productObject.productId;
        userResizableView.productObject.productName = [NSString stringWithFormat:@"%@",productObject.productObject.productName];
        userResizableView.productObject.productXcoordinate = contentView.frame.origin.x;
        userResizableView.productObject.productYcoordinate = contentView.frame.origin.y;
        userResizableView.productObject.productWidth = contentView.frame.size.width;
        userResizableView.productObject.productHeight = contentView.frame.size.height;
        userResizableView.productObject.productPrice = productObject.productObject.productPrice;
        userResizableView.productObject.unitType = productObject.productObject.unitType;
        userResizableView.productObject.discount = productObject.productObject.discount;
        
        UIGraphicsBeginImageContext(contentView.frame.size);
        [[UIImage imageNamed:[NSString stringWithFormat:@"%@",productObject.productObject.productName]] drawInRect:contentView.bounds];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [contentView setBackgroundColor:[UIColor colorWithPatternImage:image]];
        userResizableView.contentView = contentView;
        
        userResizableView.baseVC = self;
        userResizableView.delegate = self;
        [userResizableView showEditingHandles];
        userResizableView.infoBtn.hidden = YES;
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [userResizableView bringSubviewToFront:userResizableView.infoBtn];
        
        
        [productArray addObject:lastEditedView];
        NSLog(@"Array after Adding: %@",productArray);
    }

}
- (void)saveImageWithBtnInfoTag:(int)btnTag withPath:(NSString*)path withMediaImageUrl:(id)imageUrlArr {
    
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager loadingStoredMediaWithFolderTag:btnTag withPath:_templateNameString withMediaURL:imageUrlArr withCompletionBlock:^(BOOL success){
        if (success) {
            NSLog(@"DownloadStoredMediaImage");
        }
    }];
    
    
}
#pragma mark Memory Warning -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
