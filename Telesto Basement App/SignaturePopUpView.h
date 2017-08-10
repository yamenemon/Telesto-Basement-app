//
//  SignaturePopUpView.h
//  Telesto Basement App
//
//  Created by CSM on 8/10/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignatureView.h"
#import "ProposalPdfView.h"
#import <CNPPopupController.h>
#import <ActionSheetDatePicker.h>

@class ProposalViewController;
@interface SignaturePopUpView : UIView<CNPPopupControllerDelegate>{

    CNPPopupController* popupController;
    NSString *pdfFileNamePaths;
    NSMutableArray *imageArr;
}
@property (strong,nonatomic) ProposalViewController *baseController;
@property (weak, nonatomic) IBOutlet UITextField *DatePickerTextField;
@property (weak, nonatomic) IBOutlet UITextField *cancellationTextField;
@property (weak, nonatomic) IBOutlet UIView *signatureView;
-(void)pdfCreation:(NSMutableArray*)array;
-(void)removePopOver;
@end
