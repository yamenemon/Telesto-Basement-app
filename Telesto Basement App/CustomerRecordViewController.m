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
    self.title = @"Create New Customer";
    mediaSelectionPopUp = [[[NSBundle mainBundle] loadNibNamed:@"MediaPopUp" owner:self options:nil] objectAtIndex:0];
    _galleryItems = [[NSMutableArray alloc] init];
    [self loadCountryList];
    [self registerForKeyboardNotifications];
    [self getCurrentLocation];
    
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
        self.areaTextField.text = customerInfoObjects.customerAreaCode;
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
-(void)viewWillAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [snapShotCollectionView reloadData];

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
    _notesTextView.placeholderText = @"Notes on the house or customer.";
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.streetAddressTextField.delegate = self;
    self.cityTextField.delegate = self;
    self.stateNameTextField.delegate = self;
    self.zipCodeTextField.delegate = self;
    self.countryTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.areaTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.notesTextView.delegate = self;
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
        [snapShotCollectionView reloadData];

    }];
}
-(void)reloadBuildingImageCollectionView{
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    _galleryItems = [manager getDownloadedBuildingMediaArray];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_galleryItems];
    [_galleryItems removeAllObjects];
    __block MBProgressHUD* huds;
    dispatch_async(dispatch_get_main_queue(), ^{
            //Update the progress view
            huds =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            huds.center = self.view.center;
            huds.mode = MBProgressHUDModeIndeterminate;
            NSString *strloadingText = [NSString stringWithFormat:@"Loading Building Medias..."];
            huds.label.text = strloadingText;
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    });
    AFHTTPSessionManager *managers = [AFHTTPSessionManager manager];
    managers.requestSerializer = [AFHTTPRequestSerializer serializer];
    managers.responseSerializer = [AFHTTPResponseSerializer serializer];
    __block int count = (int)arr.count;
    for (int i=0; i<arr.count; i++) {
        NSString *customerBuildingImagesUrl = [NSString stringWithFormat:@"%@",arr[i]];
        NSLog(@"Customer Url: %@",customerBuildingImagesUrl);
        [managers GET:customerBuildingImagesUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject){
            NSData *data = [[NSData alloc] initWithData:responseObject];
            UIImage *image = [[UIImage alloc] initWithData:data];
            [_galleryItems addObject:image];
            [snapShotCollectionView reloadData];
            count--;
            if (count == 0) {
                [huds hideAnimated:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                [snapShotCollectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error: %@",error);
            _galleryItems = [NSMutableArray arrayWithArray:arr];
            [self reloadBuildingImageCollectionView];
        }];

//        [self loadImageInArray:arr[i] withCompletionBlock:^(BOOL success){
//            if (success == YES) {
//                [snapShotCollectionView reloadData];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//            }
//        }];
    }
    
}
- (void)getCurrentLocation {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationManager.distanceFilter=kCLDistanceFilterNone;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}
-(void)loadImageInArray:(NSString*)imageUrlString withCompletionBlock:(void (^)(BOOL succeeded))completionBlock{
    

    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrlString]];
    NSLog(@"image url: %@",imageUrl);
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:[NSURLRequest requestWithURL:imageUrl]
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           NSLog(@"Response:%@ %@\n", response, error);
                                                           if ( !error)
                                                           {
                                                               UIImage *image = [[UIImage alloc] initWithData:data];
                                                               [_galleryItems addObject:image];
                                                               [snapShotCollectionView reloadData];
                                                               completionBlock(YES);
                                                           } else{
                                                               completionBlock(NO);
                                                           }
                                                       }];
    [dataTask resume];
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
#pragma mark - KeyboardNotificationDelegate
#pragma mark -
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _customerRecordScrollView.contentInset = contentInsets;
    _customerRecordScrollView.scrollIndicatorInsets = contentInsets;
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
#pragma mark - UITextfieldDelegate
#pragma mark -
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    activeField = textField;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    activeField = nil;
}
- (IBAction)countryPickerBtnAction:(id)sender {
    [self.view endEditing:YES];
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    countryList = [manager getCountryListArray];
    NSMutableArray *tempCountryNameArr = [[NSMutableArray alloc] init];
    for (CountryListObject *obj in countryList) {
        [tempCountryNameArr addObject:obj.countryName];
    }
    NSArray *tempArr = [tempCountryNameArr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Country"
                                            rows:tempArr
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           NSLog(@"Picker: %@", picker);
                                           NSLog(@"Selected Index: %ld", (long)selectedIndex);
                                           NSLog(@"Selected Value: %@", selectedValue);
                                           self.countryTextField.text = [tempArr objectAtIndex:229];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    
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
    UIImage *originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    
    NSData *imgDatas= UIImageJPEGRepresentation(originalImage,1 /*compressionQuality*/);
    
    int imageSizes   = (int)imgDatas.length;
    NSLog(@"size of original image in KB: %f ", imageSizes/1024.0);
    
    
    NSData *imgData= UIImageJPEGRepresentation(originalImage,0.1 /*compressionQuality*/);
    
    int imageSize   = (int)imgData.length;
    NSLog(@"size of image in KB: %f ", imageSize/1024.0);
    
    
    UIImage *image=[UIImage imageWithData:imgData];

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

#pragma mark - UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_galleryItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewcell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
//    if (isFromCustomProfile == YES) {
//        NSURL *imageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_galleryItems objectAtIndex:indexPath.row]]];
//        NSLog(@"building image url: %@",imageUrl);
//        [imageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"userName"]];
//    }
//    else{
        imageView.image = [_galleryItems objectAtIndex:indexPath.row];
//    }
    return cell;
}
-(void)deletePicture:(UIButton*)btn{
    int index = (int)btn.tag;
    [_galleryItems removeObjectAtIndex:index];
    [snapShotCollectionView reloadData];
}
-(void)reloadCollectionView{
    [snapShotCollectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
    buidingMediaPopUp = [[[NSBundle mainBundle] loadNibNamed:@"BuidingMediaPopUp" owner:self options:nil] objectAtIndex:0];
    [buidingMediaPopUp initWithBaseController:self withImageArray:_galleryItems];
        if (isFromCustomProfile == YES) {
            buidingMediaPopUp.isFromCustomeProfile = YES;
        }
        else{
            buidingMediaPopUp.isFromCustomeProfile = NO;
        }
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
    [self.view endEditing:YES];
    if (isFromCustomProfile == YES) {
        [self createCustomerAfterEditing];

    }
    else{
        [self createCustomer];

    }
}
-(void)createCustomerAfterEditing{
    BOOL newtworkAvailable = [self IsInternet];
    if ( newtworkAvailable == YES) {
        if ([[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count == _galleryItems.count && [[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count>0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update the progress view
                hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.center = self.view.center;
                hud.mode = MBProgressHUDModeIndeterminate; //Change to "Creating Customer Record. <br /> This may take a minute or two..."
                NSString *strloadingText = [NSString stringWithFormat:@"Creating Customer Record."];
                NSString *strloadingText2 = [NSString stringWithFormat:@"This may take a minute or two..."];
                
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
            detailInfoObject.customerId = [customerInfoObjects.customerId longLongValue];
            NSLog(@"userId : %lld",[customerInfoObjects.customerId longLongValue]);

            detailInfoObject.customerFirstName = self.firstNameTextField.text;
            detailInfoObject.customerLastName = self.lastNameTextField.text;
            detailInfoObject.customerStreetAddress = self.streetAddressTextField.text;
            detailInfoObject.customerCityName = self.cityTextField.text;
            detailInfoObject.customerStateName = self.stateNameTextField.text;
            detailInfoObject.customerZipName = self.zipCodeTextField.text;
            detailInfoObject.customerCountryName = @"0";
            detailInfoObject.emailNotification = self.emailNotificationSwitch.state;
            detailInfoObject.customerEmailAddress = self.emailTextField.text;
            detailInfoObject.smsReminder = self.phoneNotifySwitch.state;
            detailInfoObject.customerAreaCode = self.areaTextField.text;
            detailInfoObject.customerPhoneNumber = self.phoneNumberTextField.text;
            detailInfoObject.customerNotes = self.notesTextView.text;
            detailInfoObject.customerOtherImageDic = imageDic;
            detailInfoObject.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
            detailInfoObject.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
            detailInfoObject.emailNotification = [self.emailNotificationSwitch isOn]?YES:NO;
            detailInfoObject.smsReminder = [self.phoneNotifySwitch isOn]?YES:NO;
            detailInfoObject.buildingImages = [[CustomerDataManager sharedManager] uploadedBuildingMediaArray];
            [manager validateObjects:detailInfoObject withRootController:self withAfterEditing:isFromCustomProfile withCompletionBlock:^(BOOL success){
                if (success == YES) {
                    [snapShotCollectionView reloadData];
                    [hud hideAnimated:YES];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
                else
                {
                    NSLog(@"NOT SAVE IN THE SERVER AFTER EDITING");
                }
                
            }];
        }
        else{
            [hud hideAnimated:YES];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
}
-(BOOL)IsInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(void)createCustomer{
    BOOL newtworkAvailable = [self IsInternet];
    if ( newtworkAvailable == YES) {
        if ([[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count == _galleryItems.count && [[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count>0) {
            if ([self.firstNameTextField.text length] == 0 ||
                [self.lastNameTextField.text length] == 0 ||
                [self.streetAddressTextField.text length] == 0 ||
                [self.cityTextField.text length] == 0 ||
                [self.stateNameTextField.text length] == 0 ||
                [self.zipCodeTextField.text length] == 0 ||
                [self.emailTextField.text length] == 0 ||
                [self.areaTextField.text length] == 0 ||
                [self.phoneNumberTextField.text length] == 0 ||
                [self.notesTextView.text length] == 0) {
                NSLog(@"Please fill up all field");
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uploading Error" message:@"Please fill all field!!!" preferredStyle:UIAlertControllerStyleAlert];
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
            else{
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
                UIImage *ppImage = [self fixOrientation:self.customerImageView.image];
                [imageDic setObject:ppImage forKey:@"pp"];
                
                CustomerDataManager *manager = [CustomerDataManager sharedManager];
                CustomerDetailInfoObject *detailInfoObject = [[CustomerDetailInfoObject alloc] init];
                detailInfoObject.customerId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue];
                NSLog(@"userId : %ld",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] longValue]);
                detailInfoObject.customerFirstName = self.firstNameTextField.text;
                detailInfoObject.customerLastName = self.lastNameTextField.text;
                detailInfoObject.customerStreetAddress = self.streetAddressTextField.text;
                detailInfoObject.customerCityName = self.cityTextField.text;
                detailInfoObject.customerStateName = self.stateNameTextField.text;
                detailInfoObject.customerZipName = self.zipCodeTextField.text;
                detailInfoObject.customerCountryName = @"0";
                detailInfoObject.emailNotification = self.emailNotificationSwitch.state;
                detailInfoObject.customerEmailAddress = self.emailTextField.text;
                detailInfoObject.smsReminder = self.phoneNotifySwitch.state;
                detailInfoObject.customerAreaCode = self.areaTextField.text;
                detailInfoObject.customerPhoneNumber = self.phoneNumberTextField.text;
                detailInfoObject.customerNotes = self.notesTextView.text;
                detailInfoObject.customerOtherImageDic = imageDic;
                detailInfoObject.latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
                detailInfoObject.longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
                detailInfoObject.emailNotification = [self.emailNotificationSwitch isOn]?YES:NO;
                detailInfoObject.smsReminder = [self.phoneNotifySwitch isOn]?YES:NO;
                detailInfoObject.buildingImages = [[CustomerDataManager sharedManager] uploadedBuildingMediaArray];
                [manager validateObjects:detailInfoObject withRootController:self withAfterEditing:isFromCustomProfile withCompletionBlock:^(BOOL success){
                    if (success == YES) {
                        [snapShotCollectionView reloadData];
                        [hud hideAnimated:YES];
                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                    }
                    else{
                        [hud hideAnimated:YES];
                        NSLog(@"NOT SAVE NEW CUSTOMER");
                    }
                }];
            }
        }
        else{
                [hud hideAnimated:YES];
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
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
}
- (UIImage *)fixOrientation:(UIImage*)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
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
#pragma mark -
// NOTE: This code assumes you have set the UITextField(s)'s delegate property to the object that will contain this code, because otherwise it would never be called.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // allow backspace
    if (!string.length)
    {
        return YES;
    }
    
    // Prevent invalid character input, if keyboard is numberpad
    if (textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        if ([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet].invertedSet].location != NSNotFound)
        {
            // BasicAlert(@"", @"This field accepts only numeric entries.");
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Character Error!!" message:@"This field accepts only numeric entries." preferredStyle:UIAlertControllerStyleAlert];
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
            return NO;
        }
    }
    
    // verify max length has not been exceeded
    NSString *proposedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (proposedText.length > 30) // 4 was chosen for SSN verification
    {
        // suppress the max length message only when the user is typing
        // easy: pasted data has a length greater than 1; who copy/pastes one character?
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Character Error!!" message:@"This field accepts a maximum of 30 characters." preferredStyle:UIAlertControllerStyleAlert];
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
        if (string.length > 1)
        {
            // BasicAlert(@"", @"This field accepts a maximum of 4 characters.");
            
        }
        
        return NO;
    }
    
    // only enable the OK/submit button if they have entered all numbers for the last four of their SSN (prevents early submissions/trips to authentication server)
//    self.answerButton.enabled = (proposedText.length == 4);
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Edit Button Actions
- (IBAction)buildingMediaEditing:(id)sender {
    [self.view endEditing:YES];

    mediaSelectionPopUp.isFromBuildingMedia = YES;
    [self mediaPopUP];
}
- (IBAction)uploadMediaFiles:(id)sender {
    [self.view endEditing:YES];
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
        NSString *strloadingText = [NSString stringWithFormat:@"Uploading Images"]; //Uploading Images <br /> This may take a minute or two...
        NSString *strloadingText2 = [NSString stringWithFormat:@"This may take a minute or two..."];
        
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
        if ([[CustomerDataManager sharedManager] uploadedBuildingMediaArray].count>0) { //Change to "Images Uploaded <br /> Now save the customer's information"
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Images Uploaded" message:@"Now save the customer's information" preferredStyle:UIAlertControllerStyleAlert];
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
    }];
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadCountryList{

//    dispatch_async(dispatch_get_main_queue(), ^{
//        //Update the progress view
//        hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.center = self.view.center;
//        hud.mode = MBProgressHUDModeIndeterminate;
//        NSString *strloadingText = [NSString stringWithFormat:@"Loading Country Lists"];
//        hud.label.text = strloadingText;
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//        
//    });
//    CustomerDataManager *manager = [CustomerDataManager sharedManager];
//    [manager loadCountryListWithCompletionBlock:^{
//        if (isFromCustomProfile == YES) {
////            CustomerDataManager *manager = [CustomerDataManager sharedManager];
////            countryList = [manager getCountryListArray];
////            CountryListObject *obj = [countryList objectAtIndex:[customerInfoObjects.customerCountryName intValue]];
//            self.countryTextField.text = @"United States";
//        }
//        [hud hideAnimated:YES];
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    }];

}
-(void)rootControllerBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
