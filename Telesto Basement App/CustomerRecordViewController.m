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
    [self getCurrentLocation];
}
- (void)getCurrentLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}
-(void)loadSanpMediaContainer{
    UICollectionViewFlowLayout *flo = [[UICollectionViewFlowLayout alloc] init];
    
    snapShotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, snapContainer.frame.size.width-20, snapContainer.frame.size.height-20) collectionViewLayout:flo];
    snapShotCollectionView.delegate = self;
    snapShotCollectionView.dataSource = self;
    snapShotCollectionView.backgroundColor = [UIColor clearColor];
    [snapShotCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewcell"];
    [snapContainer addSubview:snapShotCollectionView];
    [snapShotCollectionView reloadData];
//    UILongPressGestureRecognizer *lpgr
//    = [[UILongPressGestureRecognizer alloc]
//       initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = .3; // To detect after how many seconds you want shake the cells
//    lpgr.delegate = self;
//    [snapContainer addGestureRecognizer:lpgr];
//    lpgr.delaysTouchesBegan = YES;
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
    [self loadSanpMediaContainer];

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
#pragma mark -
#pragma Edit Profile Picture
#pragma mark -

- (IBAction)editProfilePicture:(id)sender {
    mediaSelectionPopUp.isFromBuildingMedia = NO;
    [self mediaPopUP];
}
-(void)mediaPopUP{
    dispatch_async(dispatch_get_main_queue(), ^{
        mediaSelectionPopUp.customerRecordVC = self;
        [mediaSelectionPopUp initialize];
        popupController = [[CNPPopupController alloc] initWithContents:@[mediaSelectionPopUp]];
        popupController.theme = [self defaultTheme];
        popupController.theme.popupStyle = CNPPopupStyleCentered;
        popupController.delegate = self;
        [popupController presentPopupControllerAnimated:YES];
    });
}
-(void)loadImageFromViaMedia:(CameraMode)mode{
    [popupController dismissPopupControllerAnimated:YES];
    if (mediaSelectionPopUp.isFromBuildingMedia == NO) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        if (mode == ProfilePicFromCamera) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else if (mode == ProfilePicFromGallery){
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        cameraMode = mode;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }
    else{
        if(mode == PictureForBuildingMediaFromGallery){
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
            elcPicker.imagePickerDelegate = self;
            cameraMode = mode;
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
        else if(mode == PictureForBuildingMediaFromCamera){
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            cameraMode = mode;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        
    }
    
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
        _customerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else{
        [_galleryItems addObject:image];
        [snapShotCollectionView reloadData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_galleryItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewcell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
    imageView.image = [_galleryItems objectAtIndex:indexPath.row];
//    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"longPressed"] isEqualToString:@"yes"])
//    {
//        CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        [anim setToValue:[NSNumber numberWithFloat:0.0f]];
//        [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
//        [anim setDuration:0.1];
//        [anim setRepeatCount:NSUIntegerMax];
//        [anim setAutoreverses:YES];
//        cell.layer.shouldRasterize = YES;
//        [cell.layer addAnimation:anim forKey:@"SpringboardShake"];
//        CGFloat delButtonSize = 20;
//        
//        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, delButtonSize, delButtonSize)];
//        _deleteButton.center = CGPointMake(imageView.frame.size.width-10, 10);
//        _deleteButton.backgroundColor = [UIColor clearColor];
//        _deleteButton.tag = indexPath.row;
//        [_deleteButton setImage: [UIImage imageNamed:@"Delete.png"] forState:UIControlStateNormal];
//        [cell addSubview:_deleteButton];
//        
//        [_deleteButton addTarget:self action:@selector(deletePicture:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    else if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"singleTap"] isEqualToString:@"yes"])
//    {
//        
//        for(UIView *subview in [cell subviews]) {
//            if([subview isKindOfClass:[UIButton class]]) {
//                [subview removeFromSuperview];
//            } else {
//            }
//        }
//        [cell.layer removeAllAnimations];
//    }
    

    return cell;
}
-(void)deletePicture:(UIButton*)btn{
    int index = (int)btn.tag;
    [_galleryItems removeObjectAtIndex:index];
    [snapShotCollectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
//-(void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"singleTap");
//    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
//    point = [gestureRecognizer locationInView:snapShotCollectionView];
//    
//    NSIndexPath *indexPath = [snapShotCollectionView indexPathForItemAtPoint:point];
//    if (indexPath == nil){
//        NSLog(@"couldn't find index path");
//        [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"longPressed"];
//        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"singleTap"];
//        [snapShotCollectionView reloadData];
//        
//    } else {
//        
//    }
//    
//}
//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
//    point = [gestureRecognizer locationInView:snapShotCollectionView];
//    
//    NSIndexPath *indexPath = [snapShotCollectionView indexPathForItemAtPoint:point];
//    if (indexPath == nil){
//        NSLog(@"couldn't find index path");
//    } else {
//        
//        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"longPressed"];
//        [snapShotCollectionView reloadData];
//        
//    }
//}
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

        NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
        for (int i= 0; i<_galleryItems.count; i++) {
            UIImage *img = [_galleryItems objectAtIndex:i];
            [imageDic setObject:img forKey:[NSString stringWithFormat:@"%d",i]];
            
        }
        [imageDic setObject:self.customerImageView.image forKey:@"pp"];

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
        detailInfoObject.latitude = currentLocation.coordinate.latitude;
        detailInfoObject.longitude = currentLocation.coordinate.longitude;
        detailInfoObject.emailNotification = [self.emailNotificationSwitch isOn]?YES:NO;
        detailInfoObject.smsReminder = [self.phoneNotifySwitch isOn]?YES:NO;
        [manager validateObjects:detailInfoObject withRootController:self];
    }
    else{

    }

}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
//    [Utility showLocationError:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Edit Button Actions
- (IBAction)buildingMediaEditing:(id)sender {
    mediaSelectionPopUp.isFromBuildingMedia = YES;
    [self mediaPopUP];
}
#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    if (info.count>0) {
        NSMutableArray *images = [[NSMutableArray alloc] init];
        [self dismissViewControllerAnimated:YES completion:nil];
        for (NSMutableDictionary *dict in info) {
            [images addObject:[dict valueForKey:@"UIImagePickerControllerOriginalImage"]];
        }
        if (cameraMode == ProfilePicFromCamera || cameraMode == ProfilePicFromGallery) {
            _customerImageView.image = [images objectAtIndex:0]; //temp code need to delete
            _customerImageView.contentMode = UIViewContentModeScaleToFill;
        }
        else{
            if (images.count>0) {
                [_galleryItems addObjectsFromArray:images];
                [snapShotCollectionView reloadData];
            }
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
