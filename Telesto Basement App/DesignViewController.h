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
#import <DRColorPicker/DRColorPickerViewController.h>

@class  TemplatePopOverViewController;

@interface DesignViewController : UIViewController <UIGestureRecognizerDelegate, SPUserResizableViewDelegate,UIPopoverPresentationControllerDelegate,UIAlertViewDelegate> {
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
}
@property (weak, nonatomic) IBOutlet UIView *productSliderView;
@property (weak, nonatomic) IBOutlet UIView *basementDesignView;

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
@end
