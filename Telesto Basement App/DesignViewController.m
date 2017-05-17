//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"
#import "DRColorPicker.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
    
}
-(void)viewDidLayoutSubviews{
    /*Scrolling window*/
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CustomTemplateNameView"
                                                      owner:self
                                                    options:nil];
    
    customTemplateNameView = [ nibViews objectAtIndex:0];
    customTemplateNameView.designViewController = self;
    
    [self setCustomTemplateName];
}
-(void)viewDidAppear:(BOOL)animated{
    
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
//        //Background Thread
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            //Run UI Updates
//            isShown = YES;
//            productSliderView.hidden = YES;
//            [self productSliderCalled:nil];
//            [self createProductScroller];
//            
//        });
//    });
    dispatch_queue_t _serialQueue = dispatch_queue_create("com.example.name", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(_serialQueue, ^{
        [self downloadProduct];
    });
    dispatch_sync(_serialQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            isShown = YES;
            productSliderView.hidden = YES;
            [self productSliderCalled:nil];
            [self createProductScroller];
            
        });
    });
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
//    NSError *error;
//    [imageData writeToFile:savedImagePath options:NSDataWritingFileProtectionNone error:&error];
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
    popupController = [[CNPPopupController alloc] initWithContents:@[/*titleLabel, lineOneLabel, imageView, lineTwoLabel, */customVideoPopUpView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = popupStyle;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    popupController = [[CNPPopupController alloc] initWithContents:@[/*titleLabel, lineOneLabel, imageView, lineTwoLabel, */customTemplateNameView]];
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

    /* DOWNLOAD PRODUCT HERE
    -----------------------
    */
    //STORE DOWNLOADED PRODUCT
    downloadedProduct = [[NSMutableArray alloc] init];
    Product *product = [[Product alloc] init];
    product.productId = 908;
    product.productImageName = @"Pro Series Sump Pumps";
    product.productPrice = 200.0f;
    [downloadedProduct addObject:product];
    
    Product *product2 = [[Product alloc] init];
    product2.productId = 909;
    product2.productImageName = @"Dehumidification";
    product2.productPrice = 500.0f;
    [downloadedProduct addObject:product2];
    
    Product *product3 = [[Product alloc] init];
    product3.productId = 910;
    product3.productImageName = @"Grate Drain";
    product3.productPrice = 100.0f;
    [downloadedProduct addObject:product3];
    
    Product *product4 = [[Product alloc] init];
    product4.productId = 911;
    product4.productImageName = @"Fast Drain";
    product4.productPrice = 20.0f;
    [downloadedProduct addObject:product4];
    
    Product *product5 = [[Product alloc] init];
    product5.productId = 912;
    product5.productImageName = @"Grate Trench";
    product5.productPrice = 150.0f;
    [downloadedProduct addObject:product5];
    
    Product *product6 = [[Product alloc] init];
    product6.productId = 913;
    product6.productImageName = @"FastSump Pump";
    product6.productPrice = 185.0f;
    [downloadedProduct addObject:product6];
    
    Product *product7 = [[Product alloc] init];
    product7.productId = 983;
    product7.productImageName = @"High Water Sump Alarm";
    product7.productPrice = 185.0f;
    [downloadedProduct addObject:product7];
    
    Product *product8 = [[Product alloc] init];
    product8.productId = 983;
    product8.productImageName = @"GrateSump Plus";
    product8.productPrice = 185.0f;
    [downloadedProduct addObject:product8];
    
    Product *product9 = [[Product alloc] init];
    product9.productId = 935;
    product9.productImageName = @"GrateSump Plus ||";
    product9.productPrice = 185.0f;
    [downloadedProduct addObject:product9];
}
-(void)createProductScroller{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,150, productSliderView.frame.size.height)];
    
    int y = 0;
    CGRect frame;
    for (int i = 0; i < downloadedProduct.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if (i == 0) {
            frame = CGRectMake(30, 10, 90, 90);
        } else {
            frame = CGRectMake(30, (i * 90) + (i*20) + 10, 90, 90);
        }
        
        button.frame = frame;
        
        [button setTag:i];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i == downloadedProduct.count-1) {
            y = CGRectGetMaxY(button.frame);
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,y);
    scrollView.backgroundColor = [UIColorFromRGB(0x0A5A78) colorWithAlphaComponent:0.3]; ;
    [productSliderView addSubview:scrollView];
    productSliderView.hidden = NO;
    
    _productInWindowArray = [[NSMutableArray alloc] init];
    for (int i = 0; i< downloadedProduct.count; i++) {
        Product *product = (Product*)[downloadedProduct objectAtIndex:i];
        [_productInWindowArray addObject:[NSNumber numberWithInt:product.productId]];
    }
    
}
-(void)productBtnClicked:(id)sender{
    UIButton *productBtn = (UIButton*)sender;
    
    NSString *productCurrentId = [NSString stringWithFormat:@"%@",[_productInWindowArray objectAtIndex:productBtn.tag]];
    
    NSString *newFolderId = [NSString stringWithFormat:@"%@%ld",productCurrentId,productBtn.tag];
    [self saveUserSelectedProductInfo:newFolderId];
    for (int i=0; i<_productInWindowArray.count; i++) {
        if (i == productBtn.tag) {
            [_productInWindowArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",newFolderId]];
        }
    }
    
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(100, 10, 90, 90);
    CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
    userResizableView.infoBtn.tag = [newFolderId intValue];
    userResizableView.productID = [newFolderId intValue];
    NSLog(@"sender tag: %ld",(long)userResizableView.infoBtn.tag);
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",(long)productBtn.tag]]];
    contentView.frame = gripFrame;
    userResizableView.contentView = contentView;
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
    lastEditedView = userResizableView;
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
    
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ShowPriceViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ShowPriceViewController"];
        vc.preferredContentSize = CGSizeMake(600, 500);
        
        vc.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popPC = vc.popoverPresentationController;
        vc.popoverPresentationController.sourceRect = menuBtn.bounds;
        vc.popoverPresentationController.sourceView = menuBtn;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
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
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [horizentalAction setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [horizentalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];

    [alertController addAction:horizentalAction];

    
    UIAlertAction *verticalAction =  [UIAlertAction actionWithTitle: @"Vertical Line" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(0, 0, 30, 100);
        CustomProductView *userResizableView = [[CustomProductView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        userResizableView.infoBtn.hidden = YES;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        [productArray addObject:lastEditedView];

        
    }];
    [verticalAction setValue:[[UIImage imageNamed:@"Vertical_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
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
                         actionWithTitle:@"Save"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             savedDesignArray = [[basementDesignView subviews] mutableCopy];
                             [self saveDesignView];
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Save & Continue"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                 UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ProposalViewController"];
                                 vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                                 [self.navigationController pushViewController:vc animated:YES];
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
-(void)saveTemplateName:(NSString*)templateName{
    _templateNameString = templateName;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",_templateNameString]];
    NSLog(@"Template path: %@",dataPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
    [popupController dismissPopupControllerAnimated:YES];

}
-(void)savedTemplateViewForScreenShot:(NSString*)templateName{

    CGRect rect = [basementDesignView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [basementDesignView.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.jpg",templateName]];
    [UIImageJPEGRepresentation(capturedImage, 0.95) writeToFile:imagePath atomically:YES];
    [popupController dismissPopupControllerAnimated:YES];
}
- (void)setCustomTemplateName{
    [self showPopupWithStyle:CNPPopupStyleCentered];
}

-(void)setSavedTemplateNumber:(int)number{
    
    if (drawingImageView) {
        [drawingImageView removeFromSuperview];
    }
    drawingImageView = [[UIImageView alloc] init];
    
    [templateController dismissViewControllerAnimated:YES completion:^{
        drawingImageView.frame = CGRectMake(0, 0, basementDesignView.frame.size.width, basementDesignView.frame.size.height);
        [drawingImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"temp%d",number]]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
