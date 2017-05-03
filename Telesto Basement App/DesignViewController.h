//
//  DesignViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
#import "TemplatePopOverViewController.h"
#import "LeftNavDrawingToolsView.h"
#import "RightNavDrwaingToolsView.h"
#import "ShowPriceViewController.h"
#import <DRColorPicker/DRColorPickerViewController.h>
#import "CustomProductView.h"
#import "CNPPopupController.h"
#import "CustomTemplateNameView.h"
#import "CustomVideoPopUpView.h"

@class  TemplatePopOverViewController;

@interface DesignViewController : UIViewController <UIGestureRecognizerDelegate, SPUserResizableViewDelegate,UIPopoverPresentationControllerDelegate,UIAlertViewDelegate,CNPPopupControllerDelegate,UIImagePickerControllerDelegate> {
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
    UILabel* priceLabel;
    BOOL isShown;
    TemplatePopOverViewController *templateController;
    UIImageView*drawingImageView;
    UIView *curvedView;
    SPUserResizableView *userResizableViewCurvedView;
    
    LeftNavDrawingToolsView *leftNavBtnBar;
    RightNavDrwaingToolsView *rightNavBtnBar;
    CNPPopupController *popupController;
    CustomVideoPopUpView *customVideoPopUpView;
}

@property (weak, nonatomic) IBOutlet UIView *productSliderView;
@property (weak, nonatomic) IBOutlet UIView *basementDesignView;
@property (strong, nonatomic) NSMutableArray *savedDesignArray;
@property (strong, nonatomic) CustomTemplateNameView *customTemplateNameView;
@property (strong, nonatomic) NSString *templateNameString;
@property (strong, nonatomic) NSMutableArray *productArray;
@property (strong, nonatomic) NSMutableArray *infoBtnArray;

- (void)setSavedTemplateNumber:(int)number;
- (void)wallPopOverBtnAction:(id)sender;
- (void)backButtonAction;
- (void)revealButtonItemClicked:(id)sender;
- (void)removeBtnClicked;
- (void)flipTheObject;
- (void)savedTemplateButtonAction:(id)sender;
- (void)showColorPickerButtonTapped:(id)sender;
- (void)stairButtonAction:(id)sender;
- (void)doorButtonAction:(id)sender;
- (void)windowSliderButtonAction:(id)sender;
- (void)saveButtonAction:(id)sender;
-(void)savedTemplateViewForScreenShot:(NSString*)templateName;
- (void)showVideoPopupWithStyle:(CNPPopupStyle)popupStyle withSender:(UIButton*)sender;
-(void)saveTemplateName:(NSString*)templateName;
-(void)openCameraWindow;
@end
