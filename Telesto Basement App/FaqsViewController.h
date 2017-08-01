//
//  FaqsViewController.h
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "CustomTextField.h"
#import "IQDropDownTextField.h"

@class FaqsViewControllerStep2;
@class BasicFAQTableViewCell;
@class CustomerProposalObject;

@interface FaqsViewController : UIViewController <UITextViewDelegate,IQDropDownTextFieldDataSource,IQDropDownTextFieldDataSource,UITextFieldDelegate>{
    UITextField *activeField;
}
@property (strong,nonatomic) NSMutableArray *downloadedCustomTemplateProposalInfo;
@property (strong,nonatomic) NSMutableDictionary *userSelectedDataDictionary;

@property (strong,nonatomic) UIScrollView *faqScroller;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (strong,nonatomic) BasicFAQTableViewCell *basicFAQView;
@property (weak, nonatomic) IBOutlet CustomTextField *heatTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *airTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *currentOutsideConditionTextField;
@property (weak, nonatomic) IBOutlet UITextField *outsideRelativeHumidity;
@property (weak, nonatomic) IBOutlet UITextField *outsideTemperature;
@property (weak, nonatomic) IBOutlet UITextField *firstFloorRelativeHumidity;
@property (weak, nonatomic) IBOutlet UITextField *firstFloorTemperature;

@property (weak, nonatomic) IBOutlet UITextField *basementRelativeHumidity;
@property (weak, nonatomic) IBOutlet UITextField *basementTemperature;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *basementDehumidifier;
@property (weak, nonatomic) IBOutlet UITextView *otherCommentsTextView;
@end
