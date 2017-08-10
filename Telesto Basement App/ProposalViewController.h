//
//  ProposalViewController.h
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CNPPopupController.h>
#import "AgreementPopUp.h"
#import "SignaturePopUpView.h"
#import <MessageUI/MessageUI.h>

@class DesignViewController;
@class ShowPriceTableViewCell;
@interface ProposalViewController : UIViewController <UITextViewDelegate,UIGestureRecognizerDelegate,CNPPopupControllerDelegate,MFMailComposeViewControllerDelegate>{

    CNPPopupController *popupController;
}
@property (strong,nonatomic) NSMutableArray *priceListArray;
@property (strong,nonatomic) NSMutableArray *downloadedProduct;
@property (strong,nonatomic) NSMutableArray *productArr;
@property (strong,nonatomic) DesignViewController *baseController;
@property (strong,nonatomic) NSString*screenShotImagePath;
@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;
@property (strong, nonatomic) ShowPriceTableViewCell *showPriceTableCell;
@property (weak, nonatomic) IBOutlet UIImageView *floorPlanImageView;
@property (weak, nonatomic) IBOutlet UITableView *priceTable;
-(void)removePopUpView;
-(void)showEmailComposerWithPdfPath:(NSString*)composerString;
@end
