//
//  CustomerRecordViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CustomerDataManager.h"
#import "MediaPopUp.h"
#import "CNPPopupController.h"
#import "MTReachabilityManager.h"
#import <CoreLocation/CoreLocation.h>
#import "ELCImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BuidingMediaPopUp.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class CustomerInfoObject;
@class CountryListObject;

typedef NS_ENUM(NSInteger, CameraMode) {
    ProfilePicFromGallery,
    ProfilePicFromCamera,
    PictureForBuildingMediaFromGallery,
    PictureForBuildingMediaFromCamera,
    VideoForBuildingMediaFromGallery,
    VideoForBuildingMediaFromCamera
};

@interface CustomerRecordViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CNPPopupControllerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,CLLocationManagerDelegate,ELCImagePickerControllerDelegate,UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField *activeField;
    MediaPopUp *mediaSelectionPopUp;
    CNPPopupController *popupController;
    CameraMode cameraMode;
    CLLocation *currentLocation;
    CGPoint point;
    UIButton *_deleteButton;
    BuidingMediaPopUp *buidingMediaPopUp;
    NSMutableArray *countryList;
}

@property (strong,nonatomic) CustomerInfoObject *customerInfoObjects;
@property (assign,nonatomic) BOOL isFromCustomProfile;
@property (nonatomic,strong) MBProgressHUD * hud;
@property (nonatomic,strong) CNPPopupController *popupController;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,strong) UICollectionView *snapShotCollectionView;
@property (strong,nonatomic) NSMutableArray *galleryItems;

@property (weak, nonatomic) IBOutlet UIView *customerName;
@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBuildingMediaBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *customerRecordScrollView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UISwitch *emailNotificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *phoneNotifySwitch;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UIView *snapContainer;


-(void)loadImageFromViaMedia:(CameraMode)mode;
-(void)mediaPopUP;
-(void)rootControllerBack;
@end
