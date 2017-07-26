//
//  FaqsViewControllerStep3.m
//  Telesto Basement App
//
//  Created by CSM on 7/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "FaqsViewControllerStep3.h"
#import "DesignViewController.h"
#import "CustomTextField.h"
@interface FaqsViewControllerStep3 ()
@end

@implementation FaqsViewControllerStep3
@synthesize scroller,userSelectedDataDictionary;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
}
-(void)viewWillAppear:(BOOL)animated{
    [self initializeTextFieldSet];
    NSLog(@"%@",userSelectedDataDictionary);
}
-(void)initializeTextFieldSet{

    NSMutableArray *booleanArray = [NSMutableArray arrayWithObjects:@"YES",@"NO", nil];
    [_questionOneBoolField setItemList:booleanArray];
    [_questionTwoBoolField setItemList:booleanArray];
    [_question3BoolField setItemList:[NSMutableArray arrayWithObjects:@"Every Other day",@"Sometime",@"Never",@"Everyday", nil]];
    [_question4BoolField setItemList:booleanArray];
    [_question5BoolField setItemList:booleanArray];
    [_question6BoolField setItemList:booleanArray];
    [_question7BoolField setItemList:booleanArray];
    [_question8BoolField setItemList:booleanArray];
    [_question10BoolField setItemList:booleanArray];
    [_question11BoolField setItemList:booleanArray];
    [_question12BoolField setItemList:[NSArray arrayWithObjects:@"2 years or more",@"3 years or more",@"5 years or more",@"10 years or more", nil]];
    [_question12BoolField2 setItemList:booleanArray];
    [_question14BoolField setItemList:booleanArray];
    [_question15BoolField setItemList:[NSArray arrayWithObjects:@"Rarely",@"Often",@"Never",@"Sometime", nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        if (!CGRectContainsPoint(aRect, _commentTextView.frame.origin) ) {
            CGPoint scrollPoint = CGPointMake(0.0, _commentTextView.frame.origin.y-kbSize.height+210);
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
-(void)storingUserSelectedDataWithCompletionBlock:(void (^)(BOOL success))completionBlock{
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_questionOneBoolField selectedRow]] forKey:@"uestionOneBoolField"];
    [userSelectedDataDictionary setObject:_questionOneTextField.text forKey:@"uestionOneTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_questionTwoBoolField selectedRow]] forKey:@"uestionTwoBoolField"];
    [userSelectedDataDictionary setObject:_questionTwoTextField.text forKey:@"uestionTwoTextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question3BoolField selectedRow]] forKey:@"uestion3BoolField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question4BoolField selectedRow]] forKey:@"uestion4BoolField"];
    [userSelectedDataDictionary setObject:_question4TextField.text forKey:@"uestion4TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question5BoolField selectedRow]] forKey:@"uestion5BoolField"];
    [userSelectedDataDictionary setObject:_question5TextField.text forKey:@"uestion5TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question6BoolField selectedRow]] forKey:@"uestion6BoolField"];
    [userSelectedDataDictionary setObject:_question6TextField.text forKey:@"uestion6TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question7BoolField selectedRow]] forKey:@"uestion7BoolField"];
    [userSelectedDataDictionary setObject:_question7TextField.text forKey:@"uestion7TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question8BoolField selectedRow]] forKey:@"uestion8BoolField"];
    [userSelectedDataDictionary setObject:_question8TextField.text forKey:@"uestion8TextField"];
    
    [userSelectedDataDictionary setObject:_question9TextField.text forKey:@"uestion9TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question10BoolField selectedRow]] forKey:@"uestion10BoolField"];
    [userSelectedDataDictionary setObject:_question10TextField.text forKey:@"uestion10TextField"];

    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question11BoolField selectedRow]] forKey:@"uestion11BoolField"];
    [userSelectedDataDictionary setObject:_question11TextField.text forKey:@"uestion11TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question12BoolField selectedRow]] forKey:@"uestion12BoolField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question12BoolField2 selectedRow]] forKey:@"uestion12BoolField2"];

    [userSelectedDataDictionary setObject:_question13TextField.text forKey:@"uestion13TextField"];

    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question14BoolField selectedRow]] forKey:@"uestion14BoolField"];
    [userSelectedDataDictionary setObject:_question14TextField.text forKey:@"uestion14TextField"];
    
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question15BoolField selectedRow]] forKey:@"uestion15BoolField"];
    [userSelectedDataDictionary setObject:[NSNumber numberWithInteger:[_question15BoolField2 selectedRow]] forKey:@"uestion15BoolField2"];
    
    [userSelectedDataDictionary setObject:_commentTextView.text forKey:@"commentTextView"];
    NSLog(@"%@",userSelectedDataDictionary);
    completionBlock(YES);
    
}
- (IBAction)saveBtnAction:(id)sender {
    [self storingUserSelectedDataWithCompletionBlock:^(BOOL success){
        if (success) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DesignViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DesignViewController"];
            vc.isFromNewProposals = YES;
            vc.userSelectedDataDictionary = userSelectedDataDictionary;
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    
}

@end
