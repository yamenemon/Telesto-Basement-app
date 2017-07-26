//
//  FaqsViewControllerStep3.h
//  Telesto Basement App
//
//  Created by CSM on 7/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@class DesignViewController;
@interface FaqsViewControllerStep3 : UIViewController<UITextFieldDelegate,UITextViewDelegate,IQDropDownTextFieldDataSource,IQDropDownTextFieldDelegate>{
    UITextField *activeField;
}
@property (strong,nonatomic) NSMutableDictionary *userSelectedDataDictionary;

@property (weak, nonatomic) IBOutlet CustomTextField *questionOneBoolField;
@property (weak, nonatomic) IBOutlet UITextField *questionOneTextField;

@property (weak, nonatomic) IBOutlet CustomTextField *questionTwoBoolField;
@property (weak, nonatomic) IBOutlet UITextField *questionTwoTextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question3BoolField;
@property (weak, nonatomic) IBOutlet CustomTextField *question4BoolField;

@property (weak, nonatomic) IBOutlet UITextField *question4TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question5BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question5TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question6BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question6TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question7BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question7TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question8BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question8TextField;

@property (weak, nonatomic) IBOutlet UITextField *question9TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question10BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question10TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question11BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question11TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question12BoolField;
@property (weak, nonatomic) IBOutlet CustomTextField *question12BoolField2;

@property (weak, nonatomic) IBOutlet UITextField *question13TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question14BoolField;
@property (weak, nonatomic) IBOutlet UITextField *question14TextField;

@property (weak, nonatomic) IBOutlet CustomTextField *question15BoolField;
@property (weak, nonatomic) IBOutlet CustomTextField *question15BoolField2;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@end
