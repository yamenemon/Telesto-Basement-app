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
@synthesize snapContainer;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Customer Records";
     mediaSelectionPopUp = [[[NSBundle mainBundle] loadNibNamed:@"MediaPopUp" owner:self options:nil] objectAtIndex:0];
    _galleryItems = [[NSMutableArray alloc] init];
    [self registerForKeyboardNotifications];
    [self loadSanpMediaContainer];
}
-(void)loadSanpMediaContainer{
    UICollectionViewFlowLayout *flo = [[UICollectionViewFlowLayout alloc] init];
    
    snapShotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, snapContainer.frame.size.width, snapContainer.frame.size.height) collectionViewLayout:flo];
    snapShotCollectionView.delegate = self;
    snapShotCollectionView.dataSource = self;
    snapShotCollectionView.backgroundColor = [UIColor clearColor];
    [snapShotCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewcell"];
    [snapContainer addSubview:snapShotCollectionView];
    
    [snapShotCollectionView reloadData];
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
    self.customerImageView.layer.borderColor = UIColorFromRGB(0x0A5571).CGColor;
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

- (IBAction)customerRecordPage:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)editProfilePicture:(id)sender {
    mediaSelectionPopUp.isFromBuildingMedia = NO;
    [self mediaPopUP];
}
-(void)mediaPopUP{
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
    else if (mode == ProfilePicFromGallery){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(mode == PictureForBuildingMediaFromGallery){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if(mode == PictureForBuildingMediaFromCamera){
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    cameraMode = mode;
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
    if (cameraMode == ProfilePicFromCamera || cameraMode == ProfilePicFromGallery) {
        _customerImageView.image = image;
        _customerImageView.contentMode = UIViewContentModeScaleToFill;
    }
    else{
        [_galleryItems addObject:image];
        [snapShotCollectionView reloadData];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//- (IBAction)PlayVideo:(id)sender {
//    [self startMediaBrowserFromViewController: self usingDelegate: self];
//}
//
//- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
//                               usingDelegate: (id <UIImagePickerControllerDelegate,
//                                               UINavigationControllerDelegate>) delegate{
//    
//    if (([UIImagePickerController isSourceTypeAvailable:
//          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
//        || (delegate == nil)
//        || (controller == nil))
//        return NO;
//    
//    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
//    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//    
//    // Hides the controls for moving & scaling pictures, or for
//    // trimming movies. To instead show the controls, use YES.
//    mediaUI.allowsEditing = YES;
//    
//    mediaUI.delegate = delegate;
//    
//    [controller presentModalViewController: mediaUI animated: YES];
//    return YES;
//    
//}
//// For responding to the user tapping Cancel.
//- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
//    
//    [self dismissModalViewControllerAnimated: YES];
//}
//
//// For responding to the user accepting a newly-captured picture or movie
//- (void) imagePickerController: (UIImagePickerController *) picker
// didFinishPickingMediaWithInfo: (NSDictionary *) info {
//    
//    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
//    
//    [self dismissModalViewControllerAnimated:NO];
//    
//    // Handle a movie capture
//    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0)
//        == kCFCompareEqualTo) {
//        
//        NSString *moviePath = [[info objectForKey:
//                                UIImagePickerControllerMediaURL] path];
//        MPMoviePlayerViewController* theMovie =
//        [[MPMoviePlayerViewController alloc] initWithContentURL: [info objectForKey:
//                                                                  UIImagePickerControllerMediaURL]];
//        [self presentMoviePlayerViewControllerAnimated:theMovie];
//        
//        // Register for the playback finished notification
//        [[NSNotificationCenter defaultCenter]
//         addObserver: self
//         selector: @selector(myMovieFinishedCallback:)
//         name: MPMoviePlayerPlaybackDidFinishNotification
//         object: theMovie];
//        
//        
//    }
//}
//// When the movie is done, release the controller.
//-(void) myMovieFinishedCallback: (NSNotification*) aNotification
//{
//    [self dismissMoviePlayerViewControllerAnimated];
//    
//    avmovi* theMovie = [aNotification object];
//    
//    [[NSNotificationCenter defaultCenter]
//     removeObserver: self
//     name: MPMoviePlayerPlaybackDidFinishNotification
//     object: theMovie];
//    // Release the movie instance created in playMovieAtURL:
//}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_galleryItems count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewcell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor greenColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
    if (indexPath.row==0) {
        imageView.image = [UIImage imageNamed:@"cameraThumb"];
    }
    else{
        imageView.image = [_galleryItems objectAtIndex:indexPath.row-1];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        mediaSelectionPopUp.isFromBuildingMedia = YES;
        [self mediaPopUP];
        [mediaSelectionPopUp.mediaPopUpTable reloadData];
    }
    else{
//        _bigScreenImageView.image = [_galleryItems objectAtIndex:indexPath.row-1];
    }
}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = snapContainer.frame.size.width / 5.5f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.5, 0.5, 0.5, 0.5);
}


-(BOOL)shouldAutorotate{
    return NO;
}
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}
#pragma mark -
#pragma mark CREATE CUSTOMER

- (IBAction)saveBtnAction:(id)sender {

    if ([MTReachabilityManager isReachable]) {

//        [self createCustomer];
        NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
        for (int i= 0; i<=_galleryItems.count; i++) {
            UIImage *img = [_galleryItems objectAtIndex:i];
            [imageDic setObject:img forKey:@"1"];
        }
        [imageDic setObject:self.customerImageView.image forKey:@"2"];

        CustomerDataManager *manager = [CustomerDataManager sharedManager];
        CustomerDetailInfoObject *detailInfoObject = [[CustomerDetailInfoObject alloc] init];
        detailInfoObject.customerId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue];
        detailInfoObject.customerFirstName = self.firstNameTextField.text;
        detailInfoObject.customerLastName = self.lastNameTextField.text;
        detailInfoObject.customerStreetAddress = self.streetAddressTextField.text;
        detailInfoObject.customerCityName = self.cityTextField.text;
        detailInfoObject.customerStateName = self.stateNameTextField.text;
        detailInfoObject.customerZipName = self.zipCodeTextField.text;
        detailInfoObject.customerCountryName = self.countryTextField.text;
        detailInfoObject.emailNotification = self.emailNotificationSwitch.state;
        detailInfoObject.customerEmailAddress = self.emailTextField.text;
        detailInfoObject.smsReminder = self.phoneNotifySwitch.state;
        detailInfoObject.customerPhoneNumber = self.phoneNumberTextField.text;
        detailInfoObject.customerNotes = self.notesTextView.text;
        detailInfoObject.customerOtherImageDic = imageDic;
        [manager validateObjects:detailInfoObject withRootController:self];

    }
    else{

    }

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

@end
