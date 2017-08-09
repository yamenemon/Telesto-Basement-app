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
@synthesize userSelectedDataDictionary,downloadedCustomTemplateProposalInfo;
    
    
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
-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"%@",userSelectedDataDictionary);
    if (userSelectedDataDictionary.count>0) {

        groundWaterTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"groundWaterTextField"] intValue];
        ironBacteriaTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"ironBacteriaTextField"] intValue];
        condensationTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"condensationTextField"] intValue];
        wallCracksTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"wallCracksTextField"] intValue];
        floorCracksTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"floorCracksTextField"] intValue];
        existingSumpPumpTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"existingSumpPumpTextField"] intValue];
        RandomSystemTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"RandomSystemTextField"] intValue];
        foundationTypeTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"foundationTypeTextField"] intValue];
        
        groundWaterRatingField.selectedRow = [[userSelectedDataDictionary valueForKey:@"groundWaterRatingField"] intValue];
        ironWaterRatingField.selectedRow = [[userSelectedDataDictionary valueForKey:@"ironWaterRatingField"] intValue];
        condensationRatingField.selectedRow = [[userSelectedDataDictionary valueForKey:@"condensationRatingField"] intValue];
        wallCracksRatingField.selectedRow = [[userSelectedDataDictionary valueForKey:@"wallCracksRatingField"] intValue];
        floorCracksRatingField.selectedRow = [[userSelectedDataDictionary valueForKey:@"floorCracksRatingField"] intValue];
        existingDranageSystemTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"existingDranageSystemTextField"] intValue];
        drayerVentTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"drayerVentTextField"] intValue];
        vulkHeadTextField.selectedRow = [[userSelectedDataDictionary valueForKey:@"vulkHeadTextField"] intValue];
        otherComments.text = [userSelectedDataDictionary valueForKey:@"faq2CommentsField"];
    }
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
        else if ([activeField isKindOfClass:[UITextView class]]){
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
//    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
}
    
-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(NSString*)item{
//    NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
    return IQProposedSelectionBoth;
}
    
-(void)doneClicked:(UIBarButtonItem*)button{
    [self.view endEditing:YES];
}
-(void)storingUserSelectedDataWithCompletionBlock:(void (^)(BOOL success))completionBlock{

    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[groundWaterTextField selectedRow]] forKey:@"groundWaterTextField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[groundWaterRatingField selectedRow]] forKey:@"groundWaterRatingField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[ironBacteriaTextField selectedRow]] forKey:@"ironBacteriaTextField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[ironWaterRatingField selectedRow]] forKey:@"ironWaterRatingField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[condensationTextField selectedRow]] forKey:@"condensationTextField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[condensationRatingField selectedRow]] forKey:@"condensationRatingField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[foundationTypeTextField selectedRow]] forKey:@"foundationTypeTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[wallCracksTextField selectedRow]] forKey:@"wallCracksTextField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[wallCracksRatingField selectedRow]] forKey:@"wallCracksRatingField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[floorCracksTextField selectedRow]] forKey:@"floorCracksTextField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[floorCracksRatingField selectedRow]] forKey:@"floorCracksRatingField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[existingSumpPumpTextField selectedRow]] forKey:@"existingSumpPumpTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[RandomSystemTextField selectedRow]] forKey:@"RandomSystemTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[existingDranageSystemTextField selectedRow]] forKey:@"existingDranageSystemTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[drayerVentTextField selectedRow]] forKey:@"drayerVentTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[vulkHeadTextField selectedRow]] forKey:@"vulkHeadTextField"];
    [userSelectedDataDictionary setObject:otherComments.text forKey:@"faq2CommentsField"];

    [self takingScreenShot];
    
    completionBlock(YES);
    
}
-(void)takingScreenShot{
    Utility *utility = [Utility sharedManager];
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
- (IBAction)pushNextFAQVC:(id)sender {
    [self storingUserSelectedDataWithCompletionBlock:^(BOOL success){
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FaqsViewControllerStep3 *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewControllerStep3"];
            vc.userSelectedDataDictionary = userSelectedDataDictionary;
            vc.downloadedCustomTemplateProposalInfo = downloadedCustomTemplateProposalInfo;
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
@end
