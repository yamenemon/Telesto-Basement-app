//
//  ProposalPdfView.h
//  Telesto Basement App
//
//  Created by CSM on 8/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignaturePopUpView;
@interface ProposalPdfView : UIView
@property (strong, nonatomic) SignaturePopUpView *baseView;
@property (weak, nonatomic) IBOutlet UIWebView *pdfViewer;
-(void)showPdfInView:(NSString*)filePath;
@end
