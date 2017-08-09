//
//  ProposalPdfView.h
//  Telesto Basement App
//
//  Created by CSM on 8/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProposalPdfView : UIView
@property (weak, nonatomic) IBOutlet UIWebView *pdfViewer;
-(void)showPdfInView:(NSString*)filePath;
@end
