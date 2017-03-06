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
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Utility checkForCookie];
    
    NSString *oldEmailAddress = [self getOldLoginEmailAddress];
    if (oldEmailAddress &&
        ![oldEmailAddress isEqualToString:@""]) {
        self.useNameTextField.text = oldEmailAddress;
    }
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
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
        NSLog(@"Hide loginWindow");
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"First_Logged_in"];
        [self displayTermsAndCondition];
    }
}
-(void)viewDidLayoutSubviews{

    [self.view.layer insertSublayer:_tutorialButton.layer above:layer];
    [self.view.layer insertSublayer:_loginButton.layer above:layer];
    [self.view.layer insertSublayer:_taglineLabel.layer above:layer];
    [self.view.layer insertSublayer:_backgroundView.layer above:layer];
    _loginButton.layer.cornerRadius = 5;
    _tutorialButton.layer.cornerRadius = 5;
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"loginView"
                                                      owner:self
                                                    options:nil];
    
    _customLoginView = [ nibViews objectAtIndex:0];
    _customLoginView.loginBtn.layer.cornerRadius = 5;
    _customLoginView.loginBtn.layer.borderColor = [Utility colorWithHexString:@"0x0A5A78"].CGColor;
    _customLoginView.errorMessageLabel.hidden = YES;
    _customLoginView.loadingIndicator.hidden = YES;
    _customLoginView.activeStatusSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);

}
-(void)displayTermsAndCondition{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"termsAndCondition"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:NULL];

}
-(void)hideButton {
    self.loginBtn.hidden = TRUE;
}


-(void)showButton {
    self.loginBtn.hidden = FALSE;
}


-(void)addSpinner {
    [self.view endEditing:YES];
    [self.view addSubview:self.aSpinner];
    [self.aSpinner startAnimating];
}

- (IBAction)loginButtonPressed:(id)sender {
    
    [self hideButton];
    [self addSpinner];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString* tokenAsString = [appDelegate deviceToken];
    
    HttpHelper *serviceHelper = [[HttpHelper alloc] init];
    
    NSString* userId = _useNameTextField.text;
    NSString* password = _passwordTextField.text;
    
    NSString *post = [NSString stringWithFormat:@"userid=%@&password=%@&device_token=%@&device_type=iOS", userId, password, tokenAsString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://jupiter.centralstationmarketing.com/api/ios/Login.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSData *data = [serviceHelper sendRequest:request];
    [self parseJOSNLoginStatus:data];
    
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                              options:NSJSONReadingMutableLeaves
                                                                error: &e];
    NSString *loginStatus = [jsonArray objectForKey:@"Login"];
    if([loginStatus isEqualToString:@"true"]) {
        NSLog(@"Login Successful");
        if([self.rememberSwitch isOn]) {
            [self updateLoginEmailAddress:self.useNameTextField.text];
        } else {
            [self clearOldLoginEmailAddress];
        }
        
        [Utility storeCookie];
        [Utility showCustomerListViewController];
        return YES;
    } else {
        [self showButton];
        NSString *message = @"Login Failed";
        NSLog(@"%@", message);
        [Utility showAlertWithTitle:@"Error"
                              withMessage:message];
        return NO;
    }
    return NO;
}
-(NSString*)getOldLoginEmailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(oldEmailSettings) {
        return [oldEmailSettings objectForKey:@"EmailAddress"];
    }
    return @"";
}


-(void)updateLoginEmailAddress:(NSString*)emailAddress {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldEmailSettings = [[defaults objectForKey:@"EmailSettings"] mutableCopy];
    if(!oldEmailSettings) {
        oldEmailSettings = [[NSMutableDictionary alloc] init];
    }
    
    [oldEmailSettings setValue:emailAddress
                        forKey:@"EmailAddress"];
    
    [[NSUserDefaults standardUserDefaults] setObject:oldEmailSettings
                                              forKey:@"EmailSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)clearOldLoginEmailAddress {
    [self updateLoginEmailAddress:@""];
}
#pragma mark UITextField Delegate

- (IBAction)editingChanged:(id)sender {
    if (_passwordTextField.text.length>0 && _useNameTextField.text.length>0) {
        [UIView animateWithDuration:0.25 animations:^{
            _loginBtn.enabled = YES;
            _loginBtn.alpha = 1.0;
        }];

    } else {
        [UIView animateWithDuration:0.25 animations:^{
            _loginBtn.enabled = NO;
            _loginBtn.alpha = 0.25;
        }];

    }
}
- (IBAction)loginButtonClicked:(id)sender {
    [self showPopupWithStyle:CNPPopupStyleCentered];

}
- (void)showPopupWithStyle:(CNPPopupStyle)popupStyle {
    
//    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"It's A Popup!" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:24], NSParagraphStyleAttributeName : paragraphStyle}];
//    NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"You can add text and images" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSParagraphStyleAttributeName : paragraphStyle}];
//    NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"With style, using NSAttributedString" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0], NSParagraphStyleAttributeName : paragraphStyle}];
    
//    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    [button setTitle:@"Close Me" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor colorWithRed:0.46 green:0.8 blue:1.0 alpha:1.0];
//    button.layer.cornerRadius = 4;
//    button.selectionHandler = ^(CNPPopupButton *button){
//        [self.popupController dismissPopupControllerAnimated:YES];
//        NSLog(@"Block for button: %@", button.titleLabel.text);
//    };
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.numberOfLines = 0;
//    titleLabel.attributedText = title;
//    
//    UILabel *lineOneLabel = [[UILabel alloc] init];
//    lineOneLabel.numberOfLines = 0;
//    lineOneLabel.attributedText = lineOne;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
//    
//    UILabel *lineTwoLabel = [[UILabel alloc] init];
//    lineTwoLabel.numberOfLines = 0;
//    lineTwoLabel.attributedText = lineTwo;
    
//    
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
//    customView.backgroundColor = [UIColor lightGrayColor];
//    
//    UITextField *textFied = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 35)];
//    textFied.borderStyle = UITextBorderStyleRoundedRect;
//    textFied.placeholder = @"Custom view!";
//    [customView addSubview:textFied];
    
    
    
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
    defaultTheme.cornerRadius = 4.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleSlideInFromBottom;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = YES;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = self.view.frame.size.width/2;
    defaultTheme.animationDuration = 0.3f;
    return defaultTheme;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
