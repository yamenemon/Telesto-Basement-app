//
//  BaseViewController.m
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "BaseViewController.h"
#import "CNPPopupController.h"
#import "iCarousel.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface BaseViewController () <CNPPopupControllerDelegate,iCarouselDelegate,iCarouselDataSource>{

}
@property (strong, nonatomic) UIActivityIndicatorView *aSpinner;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;

@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

}
-(void)viewDidAppear:(BOOL)animated{
    [self showingTermsAndConditionScreen];
}
-(void)showingTermsAndConditionScreen{
    
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"First_Logged_in"];
    if(isLoggedIn == YES) {
        NSLog(@"Show loginWindow");
        [self playBackgroundVideo];
//        [self performSelectorOnMainThread:@selector(loadDefaulImagesAndProductImages) withObject:nil waitUntilDone:2.0];
//        [self performSelector:@selector(loadDefaulImagesAndProductImages) withObject:nil afterDelay:2.0];
        [self loadDefaulImagesAndProductImages];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First_Logged_in"];
        [self displayTermsAndCondition];
    }
}
-(void)viewWillAppear:(BOOL)animated{
}
-(void)loadDefaulImagesAndProductImages{

    dispatch_async(dispatch_get_main_queue(), ^{
        //Update the progress view
        [hud removeFromSuperview];
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.center = self.view.center;
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString *strloadingText = [NSString stringWithFormat:@"Initializing Application..."];
        NSString *strloadingText2 = [NSString stringWithFormat:@" Please wait some moments..."];
        
        hud.label.text = strloadingText;
        hud.detailsLabel.text=strloadingText2;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    });
    CustomerDataManager *dataManager = [CustomerDataManager sharedManager];
    [dataManager loadingProductImagesWithBaseController:self withCompletionBlock:^(BOOL succeeded){
        if (succeeded == YES) {
            NSLog(@"Product Images loaded");
            [dataManager loadingDefaultTemplatesWithBaseController:self withCompletionBlock:^(BOOL success){\
                NSLog(@"default template loaded");
                [hud hideAnimated:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }];
        }
    }];

}
-(void)playBackgroundVideo{
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 11; i++)
    {
        [self.items addObject:@(i)];
    }
    self.iCarouselView.delegate = self;
    self.iCarouselView.dataSource = self;
    self.iCarouselView.type = iCarouselTypeCylinder;
//    [self.iCarouselView scrollByNumberOfItems:self.items.count duration:10];

}
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600.0, 300.0)];
        NSString *imageName = [NSString stringWithFormat:@"carousel_%ld",(long)index+1];
        ((UIImageView *)view).image = [UIImage imageNamed:imageName];
        view.contentMode = UIViewContentModeScaleToFill;
        view.layer.borderColor = UIColorFromRGB(0x145C79).CGColor;
        view.layer.borderWidth = 5.0f;
        view.layer.cornerRadius = 1.0f;
    }
    
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0, 200.0)];
        NSString *imageName = [NSString stringWithFormat:@"carousel_%ld",(long)index+1];
        ((UIImageView *)view).image = [UIImage imageNamed:imageName];
        view.contentMode = UIViewContentModeScaleToFill;
    }
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.iCarouselView.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.iCarouselView.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

- (void)viewDidLayoutSubviews{


    _loginButton.layer.cornerRadius = 5;
    _tutorialButton.layer.cornerRadius = 5;
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"loginView"
                                                      owner:self
                                                    options:nil];
    
    _customLoginView = [ nibViews objectAtIndex:0];
    _customLoginView.loginBtn.layer.cornerRadius = 5;
    _customLoginView.loginBtn.layer.borderColor = [Utility colorWithHexString:@"0x0A5A78"].CGColor;
    
    _customLoginView.loginView.backgroundColor = [UIColor clearColor];
    _customLoginView.forgetView.backgroundColor = [UIColor clearColor];
    _customLoginView.forgetView.alpha = 0.0;
    _customLoginView.termsView.alpha = 0.0;
    
    
    _customLoginView.errorMessageLabel.hidden = YES;
    _customLoginView.loadingIndicator.hidden = YES;
    _customLoginView.forgetLoadingIndicator.hidden = YES;
    
    _customLoginView.loginBtn.enabled = NO;
    _customLoginView.loginBtn.alpha = 0.25;
    _customLoginView.activeStatusSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    
    [Utility checkForCookie];
    
    NSString *oldEmailAddress = [self getOldLoginEmailAddress];
    if (oldEmailAddress &&
        ![oldEmailAddress isEqualToString:@""]) {
        self.customLoginView.emailField.text = oldEmailAddress;
    }
}
- (NSString*)getOldLoginEmailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(oldEmailSettings) {
        return [oldEmailSettings objectForKey:@"EmailAddress"];
    }
    return @"";
}
- (void)displayTermsAndCondition{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"termsAndCondition"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];
}
- (void)addSpinner {
    [self.view endEditing:YES];
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}
- (IBAction)loginButtonClicked:(id)sender {
    BOOL isReachable = [MTReachabilityManager isReachable];
    if (isReachable) {
    [self showPopupWithStyle:CNPPopupStyleCentered];
    }
    else{
    NSLog(@"Not Reachable");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Internet Problem" message:@"You are out of network.Prese check your network settings." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
    self.popupController = [[CNPPopupController alloc] initWithContents:@[/*titleLabel, lineOneLabel, imageView, lineTwoLabel, */_customLoginView]];
    self.popupController.theme = [self defaultTheme];
    self.popupController.theme.popupStyle = popupStyle;
    self.popupController.delegate = self;
    [self.popupController presentPopupControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
