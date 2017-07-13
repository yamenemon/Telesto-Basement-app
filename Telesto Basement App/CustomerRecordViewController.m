//
//  CustomerRecordViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "CustomerRecordViewController.h"
#import "CustomerInfoObject.h"
#import "CountryListObject.h"
#define BASE_URL  @"http://telesto.centralstationmarketing.com/"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CustomerRecordViewController ()

@end

@implementation CustomerRecordViewController
@synthesize customerInfoObjects;
@synthesize isFromCustomProfile;
@synthesize snapContainer;
@synthesize snapShotCollectionView;
@synthesize addBuildingMediaBtn;
@synthesize popupController;
@synthesize hud;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Customer Records";
    mediaSelectionPopUp = [[[NSBundle mainBundle] loadNibNamed:@"MediaPopUp" owner:self options:nil] objectAtIndex:0];
    _galleryItems = [[NSMutableArray alloc] init];
    [self loadCountryList];
    [self registerForKeyboardNotifications];
    [self getCurrentLocation];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view endEditing:YES];
    if (isFromCustomProfile == YES) {
        self.firstNameTextField.text = customerInfoObjects.customerFirstName;
        self.lastNameTextField.text = customerInfoObjects.customerLastName;
        self.streetAddressTextField.text = customerInfoObjects.customerAddress;
        self.cityTextField.text = customerInfoObjects.customerCityName;
        self.stateNameTextField.text = customerInfoObjects.customerStateName;
        self.zipCodeTextField.text = customerInfoObjects.customerZipName;
        self.countryTextField.text = customerInfoObjects.customerCountryName;
        self.emailTextField.text = customerInfoObjects.customerEmailAddress;
        self.phoneNumberTextField.text = customerInfoObjects.customerPhoneNumber;
        self.areaTextField.text = @"";
        [self.emailNotificationSwitch setOn:customerInfoObjects.emailNotification animated:YES];
        [self.phoneNotifySwitch setOn:customerInfoObjects.smsReminder animated:YES];
        self.notesTextView.text = customerInfoObjects.customerNotes;
        NSString *imageUrl = [NSString stringWithFormat:@"%@images/customer/profile/%@",BASE_URL,customerInfoObjects.customerOtherImageDic];
        NSLog(@"%@",imageUrl);
        self.customerImageView.contentMode = UIViewContentModeScaleToFill;
        [self.customerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userName"]];
        
        [self loadCustomerBuildingImages:customerInfoObjects];
    }
}
-(void)viewDidLayoutSubviews{
    [self loadSanpMediaContainer];
    
    self.customerImageView.layer.cornerRadius = self.customerImageView.frame.size.width / 2;
    self.customerImageView.layer.borderWidth = 3.0f;
    self.customerImageView.layer.borderColor = UIColorFromRGB(0x0A5571).CGColor;
    self.customerImageView.clipsToBounds = YES;
    _emailNotificationSwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    _phoneNotifySwitch.transform = CGAffineTransformMakeScale(0.65, 0.65);
    _notesTextView.layer.borderColor = UIColorFromRGB(0xC4C6C9).CGColor;
    _notesTextView.layer.borderWidth = 0.8f;
    _notesTextView.layer.cornerRadius = 3.0f;
}
-(void)loadCustomerBuildingImages:(CustomerInfoObject*)customerInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update the progress view
        [hud removeFromSuperview];
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.center = self.view.center;
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString *strloadingText = [NSString stringWithFormat:@"Loading Building Medias..."];
        hud.label.text = strloadingText;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    });
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager loadCustomerBuildingImagesWithCustomerId:customerInfo.customerId withCompletionBlock:^{
        [hud hideAnimated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self reloadBuildingImageCollectionView];
    }];
}
-(void)reloadBuildingImageCollectionView{
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    _galleryItems = [manager getDownloadedBuildingMediaArray];
    [snapShotCollectionView reloadData];
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
- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)     name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
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
- (IBAction)countryPickerBtnAction:(id)sender {
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    countryList = [manager getCountryListArray];
    UIPickerView *myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
    [self.view addSubview:myPickerView];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    myPickerView.backgroundColor = UIColorFromRGB(0x00FFFFFF);
}
// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = countryList.count;
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [fromButton setText:[NSString stringWithFormat:@"%@",[array_from objectAtIndex:[pickerView selectedRowInComponent:0]]]];
    CountryListObject *countryListObject = [countryList objectAtIndex:row];

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CountryListObject *countryListObject = [countryList objectAtIndex:row];
    NSString *countryName = [NSString stringWithFormat:@"%@",countryListObject.countryName];
    return countryName;
}
// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat componentWidth = 0.0;
    componentWidth = 135.0;
    
    return componentWidth;
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_galleryItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewcell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
    if (isFromCustomProfile == YES) {
        NSURL *imageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_galleryItems objectAtIndex:indexPath.row]]];
        NSLog(@"building image url: %@",imageUrl);
        [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"userName"]];
    }
    else{
        imageView.image = [_galleryItems objectAtIndex:indexPath.row];
    }
    return cell;
}
-(void)deletePicture:(UIButton*)btn{
    int index = (int)btn.tag;
    [_galleryItems removeObjectAtIndex:index];
    [snapShotCollectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
    buidingMediaPopUp = [[[NSBundle mainBundle] loadNibNamed:@"BuidingMediaPopUp" owner:self options:nil] objectAtIndex:0];
    [buidingMediaPopUp initWithBaseController:self withImageArray:_galleryItems];

    popupController = [[CNPPopupController alloc] initWithContents:@[buidingMediaPopUp]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    popupController.theme.shouldDismissOnBackgroundTouch = NO;
    [popupController presentPopupControllerAnimated:YES];
    });
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

#pragma mark -
#pragma mark CREATE CUSTOMER
- (IBAction)saveBtnAction:(id)sender {
    [self createCustomer];
}
-(void)createCustomer{
    if ([MTReachabilityManager isReachable]) {
        if ([[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count == _galleryItems.count) {

        dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.center = self.view.center;
            hud.mode = MBProgressHUDModeIndeterminate;
            NSString *strloadingText = [NSString stringWithFormat:@"Uploading User Information."];
            NSString *strloadingText2 = [NSString stringWithFormat:@" Please wait some moments..."];
            
            hud.label.text = strloadingText;
            hud.detailsLabel.text=strloadingText2;
            [hud showAnimated:YES];
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        });
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
        detailInfoObject.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
        detailInfoObject.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
        detailInfoObject.emailNotification = [self.emailNotificationSwitch isOn]?YES:NO;
        detailInfoObject.smsReminder = [self.phoneNotifySwitch isOn]?YES:NO;
        detailInfoObject.buildingImages = [[CustomerDataManager sharedManager] uploadedBuildingMediaArray];
        [manager validateObjects:detailInfoObject withRootController:self withCompletionBlock:^{
            [snapShotCollectionView reloadData];
        }];
        }
        else{
            NSLog(@"Media image not uploaded yet");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uploading Error" message:@"Upload Media file first!!!" preferredStyle:UIAlertControllerStyleAlert];
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
    else{
    }
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
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
- (IBAction)uploadMediaFiles:(id)sender {
    if (_galleryItems.count>0) {
        BOOL isReachable = [MTReachabilityManager isReachable];
        if (isReachable) {
            [self uploadBuildingMediaImages:_galleryItems];
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
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Media Error" message:@"No Media to upload" preferredStyle:UIAlertControllerStyleAlert];
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
-(void)uploadBuildingMediaImages:(NSMutableArray*)mediaArray{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Update the progress view
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.center = self.view.center;
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString *strloadingText = [NSString stringWithFormat:@"Uploading Building Images"];
        NSString *strloadingText2 = [NSString stringWithFormat:@" Please wait some moments..."];
        
        hud.label.text = strloadingText;
        hud.detailsLabel.text=strloadingText2;
        [hud showAnimated:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    });
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager uploadBuildingMediaImagesArray:mediaArray withController:self withCompletion:^{
        [snapShotCollectionView reloadData];
        [hud hideAnimated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    }];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadCountryList{

    dispatch_async(dispatch_get_main_queue(), ^{
        //Update the progress view
        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.center = self.view.center;
        hud.mode = MBProgressHUDModeIndeterminate;
        NSString *strloadingText = [NSString stringWithFormat:@"Loading Country Lists"];
        hud.label.text = strloadingText;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
    });
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    [manager loadCountryListWithCompletionBlock:^{
        [hud hideAnimated:YES];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];

}
-(void)rootControllerBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
