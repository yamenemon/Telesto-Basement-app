//
//  DesignViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPUserResizableView.h"
#import "WYPopoverController.h"
#import "TemplatePopOverViewController.h"

@interface DesignViewController : UIViewController <UIGestureRecognizerDelegate, SPUserResizableViewDelegate,UIPopoverPresentationControllerDelegate> {
    SPUserResizableView *currentlyEditingView;
    SPUserResizableView *lastEditedView;
    UILabel* priceLabel;
    BOOL isShown;
    UIPopoverController *popoverController;
}
@property (weak, nonatomic) IBOutlet UIView *productSliderView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *drawingView;
@property (weak, nonatomic) IBOutlet UILabel *wallContainerLabel;
@property (weak, nonatomic) IBOutlet UIButton *horizentalBtn;
@property (weak, nonatomic) IBOutlet UIButton *verticalBtn;
@property (weak, nonatomic) IBOutlet UIView *basementDesignView;
@end
