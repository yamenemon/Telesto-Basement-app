//
//  CustomerRecordViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerRecordViewController.h"
#define BaseURL  @"http://telesto.centralstationmarketing.com/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerRecordViewController ()

@end

@implementation CustomerRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Customer Records";
     mediaSelectionPopUp = [[[NSBundle mainBundle] loadNibNamed:@"MediaPopUp" owner:self options:nil] objectAtIndex:0];
    
    [self registerForKeyboardNotifications];
    
//    [self changeTextfieldStyle:_firstNameTextField];
//    [self changeTextfieldStyle:_lastNameTextField];
//    [self changeTextfieldStyle:_streetAddressTextField];
//    [self changeTextfieldStyle:_cityTextField];
//    [self changeTextfieldStyle:_zipCodeTextField];
//    [self changeTextfieldStyle:_countryTextField];
//    [self changeTextfieldStyle:_emailTextField];
//    [self changeTextfieldStyle:_areaTextField];
//    [self changeTextfieldStyle:_phoneNumberTextField];
//    [self changeTextfieldStyle:_stateNameTextField];
    
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
-(void)viewWillAppear:(BOOL)animated{
    [self.view endEditing:YES];
}
-(void)viewDidLayoutSubviews{
    self.customerImageView.layer.cornerRadius = self.customerImageView.frame.size.width / 2;
    self.customerImageView.layer.borderWidth = 3.0f;
    self.customerImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.customerImageView.clipsToBounds = YES;
    _emailNotificationSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    _phoneNotifySwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);

}
-(UITextField*)changeTextfieldStyle:(UITextField*)textField{
    
    UITextField *tempTextField = textField;
    tempTextField.frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y, textField.frame.size.width, textField.frame.size.height+30);
    tempTextField.layer.borderWidth = 1.0f;
    tempTextField.layer.borderColor = UIColorFromRGB(0xC5C6C5).CGColor;
    tempTextField.layer.cornerRadius = 5;
    tempTextField.clipsToBounds      = YES;
    return tempTextField;
    
}
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if ([activeField isKindOfClass:[UITextField class]]) {
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _customerRecordScrollView.contentInset = contentInsets;
        _customerRecordScrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+180);
            [_customerRecordScrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        _customerRecordScrollView.contentInset = contentInsets;
        _customerRecordScrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, _notesTextView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _notesTextView.frame.origin.y-kbSize.height+210);
            [_customerRecordScrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    activeField = textField;
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    activeField = nil;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _customerRecordScrollView.contentInset = contentInsets;
    _customerRecordScrollView.scrollIndicatorInsets = contentInsets;
}
-(void)createCustomer{

//    tokenAsString = @"telesto9NRd7GR11I41Y20P0jKN146SYnzX5uMH";
    NSString *endPoint = @"create_customer";
//    fName, lName, address, city, state, zip, countryId, email, phone, userId
    NSString *post = [NSString stringWithFormat:@"fName=%@&lName=%@&address=%@&city=%@&state=%@&zip=%@&countryId=%@&email=%@&phone=%@&userId=%@", _firstNameTextField.text, _lastNameTextField.text, _streetAddressTextField.text,_cityTextField.text,_stateNameTextField.text,_zipCodeTextField.text,_countryTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,endPoint]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [self sendRequest:request];

}
-(void)sendRequest:(NSURLRequest*)urlRequest{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           
                                                           if(error == nil)
                                                           {
                                                               NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data = %@",text);
                                                               if (data) {
                                                                   [self parseJOSNLoginStatus:data];
                                                               }
                                                               else{
                                                                   
                                                               }
                                                           }
                                                       }];
    [dataTask resume];
}
- (BOOL)parseJOSNLoginStatus:(NSData *)data {
    NSError *e = nil;
    NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error: &e];
    long loginStatus = [[jsonArray objectForKey:@"success"] longValue];
    return loginStatus;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)customerRecordPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editProfilePicture:(id)sender {
    mediaSelectionPopUp.customerRecordVC = self;
    [mediaSelectionPopUp initialize];
    popupController = [[CNPPopupController alloc] initWithContents:@[mediaSelectionPopUp]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
    
}
-(void)loadImageFromViaMedia:(CameraMode)mode{
    [popupController dismissPopupControllerAnimated:YES];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if (mode == ProfilePicFromCamera) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    _customerImageView.image = image;
    _customerImageView.contentMode = UIViewContentModeScaleToFill;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
