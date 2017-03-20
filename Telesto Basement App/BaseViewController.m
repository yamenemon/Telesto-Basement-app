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

@interface BaseViewController () <CNPPopupControllerDelegate,iCarouselDelegate,iCarouselDataSource>{

    AVPlayer *avPlayer;
    AVPlayerLayer *layer;
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
    
    [self playBackgroundVideo];
}
-(void)playBackgroundVideo{

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"demoVideo" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    avPlayer = [AVPlayer playerWithURL:fileURL];
    
    layer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    layer.frame = self.view.bounds;
//    [self.view.layer addSublayer: layer];
    [avPlayer play];
    
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
-(void)viewDidAppear:(BOOL)animated{
    [self showingTermsAndConditionScreen];
}
-(void)showingTermsAndConditionScreen{

    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"First_Logged_in"];
    if(isLoggedIn == YES) {
        NSLog(@"Show loginWindow");
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First_Logged_in"];
        [self displayTermsAndCondition];
    }
}
- (void)viewDidLayoutSubviews{

    [self.view.layer insertSublayer:_tutorialButton.layer above:layer];
    [self.view.layer insertSublayer:_loginButton.layer above:layer];
    [self.view.layer insertSublayer:_taglineLabel.layer above:layer];

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
    [self showPopupWithStyle:CNPPopupStyleCentered];
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
