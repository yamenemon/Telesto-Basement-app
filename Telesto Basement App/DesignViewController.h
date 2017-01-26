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
}
@property (weak, nonatomic) IBOutlet UIView *productSliderView;
@property (weak, nonatomic) IBOutlet UIView *basementDesignView;

-(void)setSavedTemplateNumber:(int)number;
- (void)wallPopOverBtnAction:(id)sender;
-(void)backButtonAction;
@end
