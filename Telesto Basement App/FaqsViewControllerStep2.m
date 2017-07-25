//
//  FaqsViewControllerStep2.m
//  Telesto Basement App
//
//  Created by CSM on 7/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "FaqsViewControllerStep2.h"
#import "FaqsViewControllerStep3.h"
#import "CustomTextField.h"

@interface FaqsViewControllerStep2 ()

@end

@implementation FaqsViewControllerStep2
    @synthesize groundWaterTextField,ironBacteriaTextField,condensationTextField,wallCracksTextField,floorCracksTextField,existingSumpPumpTextField,RandomSystemTextField,foundationTypeTextField,otherComments,groundWaterRatingField,ironWaterRatingField,condensationRatingField,wallCracksRatingField,floorCracksRatingField,existingDranageSystemTextField,drayerVentTextField,vulkHeadTextField,scroller;
    
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    NSArray *boolearArray = [NSArray arrayWithObjects:@"YES",@"NO",nil];
    NSArray *ratingArray = [NSArray arrayWithObjects:@"-",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
    
    [groundWaterTextField setItemList:boolearArray];
    [ironBacteriaTextField setItemList:boolearArray];
    [condensationTextField setItemList:boolearArray];
    [wallCracksTextField setItemList:boolearArray];
    [floorCracksTextField setItemList:boolearArray];
    [existingSumpPumpTextField setItemList:boolearArray];
    [RandomSystemTextField setItemList:boolearArray];
    [existingDranageSystemTextField setItemList:boolearArray];
    [vulkHeadTextField setItemList:boolearArray];
    [drayerVentTextField setItemList:boolearArray];
    
    [groundWaterRatingField setItemList:ratingArray];
    [ironWaterRatingField setItemList:ratingArray];
    [condensationRatingField setItemList:ratingArray];
    [wallCracksRatingField setItemList:ratingArray];
    [floorCracksRatingField setItemList:ratingArray];
    
    [foundationTypeTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Poured", nil]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if (!CGRectContainsPoint(aRect, otherComments.frame.origin) ) {
                CGPoint scrollPoint = CGPointMake(0.0, otherComments.frame.origin.y-kbSize.height+210);
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
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
}
    
-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(NSString*)item{
    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
    return IQProposedSelectionBoth;
}
    
-(void)doneClicked:(UIBarButtonItem*)button{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pushNextFAQVC:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FaqsViewControllerStep3 *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewControllerStep3"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
