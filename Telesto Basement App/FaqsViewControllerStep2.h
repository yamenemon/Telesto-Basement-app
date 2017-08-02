//
//  FaqsViewControllerStep2.h
//  Telesto Basement App
//
//  Created by CSM on 7/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"

@class CustomTextField;
@class FaqsViewControllerStep3;

@interface FaqsViewControllerStep2 : UIViewController<UITextFieldDelegate,UITextViewDelegate,IQDropDownTextFieldDataSource,IQDropDownTextFieldDelegate>{

    UITextField *activeField;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong,nonatomic) NSMutableDictionary *userSelectedDataDictionary;
@property (strong,nonatomic) NSMutableArray *downloadedCustomTemplateProposalInfo;

@property (weak, nonatomic) IBOutlet CustomTextField *groundWaterTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *ironBacteriaTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *condensationTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *wallCracksTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *floorCracksTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *existingSumpPumpTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *RandomSystemTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *foundationTypeTextField;
@property (weak, nonatomic) IBOutlet UITextView *otherComments;

@property (weak, nonatomic) IBOutlet CustomTextField *groundWaterRatingField;
@property (weak, nonatomic) IBOutlet CustomTextField *ironWaterRatingField;
@property (weak, nonatomic) IBOutlet CustomTextField *condensationRatingField;
@property (weak, nonatomic) IBOutlet CustomTextField *wallCracksRatingField;
@property (weak, nonatomic) IBOutlet CustomTextField *floorCracksRatingField;

@property (weak, nonatomic) IBOutlet CustomTextField *existingDranageSystemTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *drayerVentTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *vulkHeadTextField;
@end
