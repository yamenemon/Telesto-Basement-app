//
//  CustomerRecordViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MediaPopUp.h"
#import "CNPPopupController.h"

typedef NS_ENUM(NSInteger, CameraMode) {
    ProfilePicFromGallery,
    ProfilePicFromCamera
};

@interface CustomerRecordViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CNPPopupControllerDelegate>{
    UITextField *activeField;
    MediaPopUp *mediaSelectionPopUp;
    CNPPopupController *popupController;
}

@property (weak, nonatomic) IBOutlet UIView *customerName;
@property (weak, nonatomic) IBOutlet UIImageView *customerImageView;

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

@property (weak, nonatomic) IBOutlet UIView *userCapturedImageView;

-(void)loadImageFromViaMedia:(CameraMode)mode;
@end
