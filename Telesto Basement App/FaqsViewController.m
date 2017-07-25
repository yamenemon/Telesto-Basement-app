//
//  FaqsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//
#import "FaqsViewControllerStep2.h"
#import "FaqsViewController.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface FaqsViewController ()<IQDropDownTextFieldDelegate,IQDropDownTextFieldDataSource>{

    float basicFAQViewHeight;
    __weak IBOutlet UITextField *currentDate;
}

@end

@implementation FaqsViewController
@synthesize scroller;
@synthesize basicFAQView;
@synthesize currentOutsideConditionTextField,heatTextField,airTextField,basementDehumidifier;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FAQs";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d MMMM, yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];

    currentDate.text = [NSString stringWithFormat:@"%@",string];
    [self registerForKeyboardNotifications];

    [currentOutsideConditionTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Sunny", nil]];
    [heatTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Hot Water", nil]];
    [airTextField setItemList:[NSArray arrayWithObjects:@"Select One",@"Central", nil]];
    [basementDehumidifier setItemList:[NSArray arrayWithObjects:@"Select One",@"Yes 40 Pint", nil]];
    
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
        NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
}
    
-(IQProposedSelection)textField:(nonnull IQDropDownTextField*)textField proposedSelectionModeForItem:(NSString*)item{
        NSLog(@"%@: %@",NSStringFromSelector(_cmd),item);
        return IQProposedSelectionBoth;
}
    
-(void)doneClicked:(UIBarButtonItem*)button{
        [self.view endEditing:YES];
}
- (IBAction)pushNextFAQsController:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FaqsViewControllerStep2 *vc = [sb instantiateViewControllerWithIdentifier:@"FaqsViewControllerStep2"];
    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
