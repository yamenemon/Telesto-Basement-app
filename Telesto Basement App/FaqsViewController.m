//
//  FaqsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//
#import "FaqsViewControllerStep2.h"
#import "FaqsViewController.h"
#import "CustomerProposalObject.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface FaqsViewController ()<IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource>{

    float basicFAQViewHeight;
    __weak IBOutlet UITextField *currentDate;
}

@end

@implementation FaqsViewController
@synthesize scroller;
@synthesize basicFAQView;
@synthesize userSelectedDataDictionary;
@synthesize currentOutsideConditionTextField,heatTextField,airTextField,basementDehumidifier;
@synthesize downloadedCustomTemplateProposalInfo;
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FAQs";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MMMM d, yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];

    currentDate.text = [NSString stringWithFormat:@"%@",string];
    [self registerForKeyboardNotifications];
    
    [currentOutsideConditionTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Sunny", nil]];
    [heatTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Hot Water", nil]];
    [airTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Central", nil]];
    [basementDehumidifier setItemList:[NSArray arrayWithObjects:@"Select One",@"Yes 40 Pint", nil]];
    [self assignData];
}
-(void)assignData{
    userSelectedDataDictionary = [[NSMutableDictionary alloc] init];
    if (downloadedCustomTemplateProposalInfo.count>0) {
//        NSLog(@"%@",downloadedCustomTemplateProposalInfo);
        CustomerProposalObject *proposalObject = [downloadedCustomTemplateProposalInfo objectAtIndex:0];
        userSelectedDataDictionary = [NSMutableDictionary dictionaryWithDictionary:proposalObject.faq];
//        NSLog(@"Total dic: %@",userSelectedDataDictionary);
        heatTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"heatTextField"] intValue];
        airTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"airTextField"] intValue];
        currentOutsideConditionTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"currentOutsideConditionTextField"] intValue];
        _outsideRelativeHumidity.text = [userSelectedDataDictionary valueForKey:@"outsideRelativeHumidity"];
        _outsideTemperature.text = [userSelectedDataDictionary valueForKey:@"outsideTemperature"];
        _firstFloorRelativeHumidity.text = [userSelectedDataDictionary valueForKey:@"firstFloorRelativeHumidity"];
        _firstFloorTemperature.text = [userSelectedDataDictionary valueForKey:@"firstFloorTemperature"];
        _basementRelativeHumidity.text = [userSelectedDataDictionary valueForKey:@"basementRelativeHumidity"];
        _basementTemperature.text = [userSelectedDataDictionary valueForKey:@"basementTemperature"];
        basementDehumidifier.selectedRow = [[userSelectedDataDictionary valueForKey:@"basementDehumidifier"] intValue];
        _otherCommentsTextView.text = [userSelectedDataDictionary valueForKey:@"faqOtherCommentsField"];
    }
}
-(void)viewWillAppear:(BOOL)animated{
}
#pragma mark - KeyboardNotificationDelegate
#pragma mark -
- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroller.contentInset = contentInsets;
    scroller.scrollIndicatorInsets = contentInsets;
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
        scroller.contentInset = contentInsets;
        scroller.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height+180);
            [scroller setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scroller.contentInset = contentInsets;
        scroller.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, _otherCommentsTextView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _otherCommentsTextView.frame.origin.y-kbSize.height+210);
            [scroller setContentOffset:scrollPoint animated:YES];
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
-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nullable NSString*)item{
//        NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);

}
    
-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(NSString*)item{
//        NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
        return IQProposedSelectionBoth;
}
    
-(void)doneClicked:(UIBarButtonItem*)button{
        [self.view endEditing:YES];
}
-(void)storingUserSelectedDataWithCompletionBlock:(void (^)(BOOL success))completionBlock{
    
    if (downloadedCustomTemplateProposalInfo.count>0) {
//        NSLog(@"%@",userSelectedDataDictionary);
        [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[currentOutsideConditionTextField selectedRow]] forKey:@"currentOutsideConditionTextField"];
        [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[heatTextField selectedRow]] forKey:@"heatTextField"];
        [userSelectedDataDictionary setObject:_outsideRelativeHumidity.text forKey:@"outsideRelativeHumidity"];
        [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[airTextField selectedRow]] forKey:@"airTextField"];
        [userSelectedDataDictionary setObject:_outsideTemperature.text forKey:@"outsideTemperature"];
        [userSelectedDataDictionary setObject:_basementRelativeHumidity.text forKey:@"basementRelativeHumidity"];
        [userSelectedDataDictionary setObject:_firstFloorRelativeHumidity.text forKey:@"firstFloorRelativeHumidity"];
        [userSelectedDataDictionary setObject:_basementTemperature.text forKey:@"basementTemperature"];
        [userSelectedDataDictionary setObject:_firstFloorTemperature.text forKey:@"firstFloorTemperature"];
        [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[basementDehumidifier selectedRow]] forKey:@"basementDehumidifier"];
        [userSelectedDataDictionary setObject:_otherCommentsTextView.text forKey:@"RelativeOtherCommentsField"];
    }
    else{
        userSelectedDataDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:[currentOutsideConditionTextField selectedRow]],@"currentOutsideConditionTextField",
                                      [NSNumber numberWithInteger:[heatTextField selectedRow]],@"heatTextField",
                                      _outsideRelativeHumidity.text,@"outsideRelativeHumidity",
                                      [NSNumber numberWithInteger:[airTextField selectedRow]],@"airTextField",
                                      _outsideTemperature.text,@"outsideTemperature",
                                      _basementRelativeHumidity.text,@"basementRelativeHumidity",
                                      _firstFloorRelativeHumidity.text,@"firstFloorRelativeHumidity",
                                      _basementTemperature.text,@"basementTemperature",
                                      _firstFloorTemperature.text,@"firstFloorTemperature",
                                      [NSNumber numberWithInteger:[basementDehumidifier selectedRow]],@"basementDehumidifier",
                                      _otherCommentsTextView.text,@"RelativeOtherCommentsField",
                                      nil];
    }
    [self takingScreenShot];
//    NSLog(@"%@",userSelectedDataDictionary);
    completionBlock(YES);
}
-(void)takingScreenShot{
    Utility *utility = [Utility sharedManager];
    utility.faqImageArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect rect = [_containerView bounds];
        UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_containerView.layer renderInContext:context];
        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [utility.faqImageArray addObject:capturedImage];
    });
}
- (IBAction)pushNextFAQsController:(id)sender {
    [self storingUserSelectedDataWithCompletionBlock:^(BOOL success){
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FaqsViewControllerStep2 *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewControllerStep2"];
            vc.userSelectedDataDictionary = userSelectedDataDictionary;
            vc.downloadedCustomTemplateProposalInfo = downloadedCustomTemplateProposalInfo;
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}
@end
