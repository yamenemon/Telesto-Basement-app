//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"
#import "WYPopoverController.h"
#import "DRColorPicker.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DesignViewController ()<WYPopoverControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) DRColorPickerColor* color;
@property (nonatomic, weak) DRColorPickerViewController* colorPickerVC;
@end

@implementation DesignViewController
@synthesize productSliderView;
@synthesize basementDesignView;
CGFloat firstX;
CGFloat firstY;
CGFloat lastRotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    lastRotation = 0.0;
   
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
-(void)viewDidLayoutSubviews:(BOOL)animated{
    /*Scrolling window*/
    [super viewWillLayoutSubviews];
    CGRect frame = productSliderView.frame;
    frame.origin.x = -frame.size.width+100;
    productSliderView.frame = frame;
}
-(void)viewDidAppear:(BOOL)animated{
    [self createProductScroller];
}
-(void)viewWillDisappear:(BOOL)animated{
    leftNavBtnBar.hidden = YES;
    rightNavBtnBar.hidden = YES;
}
-(void)createProductScroller{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,150, productSliderView.frame.size.height)];
    
    int y = 0;
    CGRect frame;
    for (int i = 0; i < 10; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if (i == 0) {
            frame = CGRectMake(10, 10, 80, 80);
        } else {
            frame = CGRectMake(10, (i * 80) + (i*20) + 10, 80, 80);
        }
        
        button.frame = frame;
        [button setTag:i];
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]]];
        [button addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i == 9) {
            y = CGRectGetMaxY(button.frame);
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,y);
    scrollView.backgroundColor = [UIColorFromRGB(0x0A5A78) colorWithAlphaComponent:0.3]; ;
//    productSliderView.alpha = 0.5;
    [productSliderView addSubview:scrollView];

}
-(void)productBtnClicked:(id)sender{
    UIButton *productBtn = (UIButton*)sender;
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(100, 10, 150, 150);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",productBtn.tag]]];
    contentView.frame = gripFrame;
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [basementDesignView addSubview:userResizableView];
    [self productSliderCalled:nil];
}
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    lastEditedView = userResizableView;
}
- (void)flipTheObject{
    lastEditedView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [lastEditedView setNeedsDisplay];
}
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)removeBtnClicked{
    [lastEditedView removeFromSuperview];
}


/*Button View button's Actions*/
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

- (void)revealButtonItemClicked:(id)sender{

    UIButton *menuBtn = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *newTemplate =  [UIAlertAction actionWithTitle: @"New Template" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
//    [newTemplate setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [newTemplate setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:newTemplate];
    
    
    UIAlertAction *savedTemplate =  [UIAlertAction actionWithTitle: @"Saved Template" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self savedTemplateButtonAction:sender];

    }];
//    [savedTemplate setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [savedTemplate setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:savedTemplate];
    
    UIAlertAction *checkList =  [UIAlertAction actionWithTitle: @"CheckList" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        DRColorPickerViewController *colorPicker = [[DRColorPickerViewController alloc] init];
        [self.navigationController presentViewController:colorPicker animated:YES completion:nil];
    }];
//    [checkList setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [checkList setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    
    [alertController addAction:checkList];
    
    
    UIAlertAction *showPrice =  [UIAlertAction actionWithTitle: @"Show Price" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
//    [showPrice setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
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
    
    UIAlertAction *horizentalAction =  [UIAlertAction actionWithTitle: @"Horizental" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(30, 0, 100, 30);
        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        
    }];
    [horizentalAction setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [horizentalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];

    [alertController addAction:horizentalAction];

    
    UIAlertAction *verticalAction =  [UIAlertAction actionWithTitle: @"Vertical" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(0, 0, 30, 100);
        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark Color Picker Methods -

- (void)showColorPickerButtonTapped:(id)sender
{
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

- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // get the image
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // tell the color picker to finish importing
    [self.colorPickerVC.rootViewController finishImport:img];
    
    // dismiss the image picker
    [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // image picker cancel, just dismiss it
    [self.colorPickerVC dismissViewControllerAnimated:YES completion:nil];
}


@end
