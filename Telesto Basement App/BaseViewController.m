//
//  BaseViewController.m
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "BaseViewController.h"
#import "CNPPopupController.h"


@interface BaseViewController () <CNPPopupControllerDelegate>{

    AVPlayer *avPlayer;
    AVPlayerLayer *layer;
}
@property (strong, nonatomic) UIActivityIndicatorView *aSpinner;
@property (nonatomic, strong) CNPPopupController *popupController;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;


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
    [self.view.layer addSublayer: layer];
    [avPlayer play];
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
-(void)viewDidLayoutSubviews{

    [self.view.layer insertSublayer:_tutorialButton.layer above:layer];
    [self.view.layer insertSublayer:_loginButton.layer above:layer];
    [self.view.layer insertSublayer:_taglineLabel.layer above:layer];
//    [self.view.layer insertSublayer:_tutorialView.layer above:layer];
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
-(NSString*)getOldLoginEmailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(oldEmailSettings) {
        return [oldEmailSettings objectForKey:@"EmailAddress"];
    }
    return @"";
}
-(void)displayTermsAndCondition{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"termsAndCondition"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}


-(void)addSpinner {
    [self.view endEditing:YES];
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}


- (IBAction)loginButtonClicked:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleCentered];

}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    UIImage *image = [UIImage imageNamed:@"telesto-logo"];
    float logoX = ((self.view.frame.size.width/2) - image.size.width)/2;
    UIImageView *telestoLogo = [[UIImageView alloc] initWithFrame:CGRectMake(logoX, 5, image.size.width,image.size.height)];
    telestoLogo.image = image;
    
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
