//
//  SignaturePopUpView.m
//  Telesto Basement App
//
//  Created by CSM on 8/10/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "SignaturePopUpView.h"
#import "ProposalViewController.h"
@implementation SignaturePopUpView
@synthesize baseController;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)pdfCreation:(NSMutableArray*)array{
    
    
    imageArr = [[NSMutableArray alloc] initWithArray:array];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"d MMMM, yyyy";
    NSString *string = [formatter stringFromDate:[NSDate date]];

    _DatePickerTextField.text = [NSString stringWithFormat:@"%@",string];
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 3;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSString *newString = [formatter stringFromDate:nextDate];

    _cancellationTextField.text = [NSString stringWithFormat:@"%@",newString];
    
    
    SignatureView *signView= [[ SignatureView alloc] initWithFrame: CGRectMake(0, 0, _signatureView.frame.size.width, _signatureView.frame.size.height)];
    [signView setBackgroundColor:[UIColor whiteColor]];
    signView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    signView.layer.borderWidth = 1.0;
    [_signatureView addSubview:signView];
}
- (NSString *)createPdfWithName: (NSString *)name array:(NSArray*)images {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docspath = [paths objectAtIndex:0];
    NSString *pdfFileName = [docspath stringByAppendingPathComponent:[NSString stringWithFormat:@"/pdf/%@.pdf",name]];
    NSLog(@"pdf file name: %@",pdfFileName);
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    for (int index = 0; index <[images count] ; index++) {
        UIImage *pngImage=[images objectAtIndex:index];;
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, (pngImage.size.height), (pngImage.size.height)), nil);
        [pngImage drawInRect:CGRectMake(0, 0, (pngImage.size.height), (pngImage.size.height))];
    }
    UIGraphicsEndPDFContext();
    return pdfFileName;
}

- (void)loadPdf:(NSString*)fileName {
    //DO SOMTHING
    [popupController dismissPopupControllerAnimated:YES];

    ProposalPdfView *pdfViewer = [[[NSBundle mainBundle] loadNibNamed:@"ProposalPdfView" owner:self options:nil] objectAtIndex:0];
    pdfViewer.baseView = self;
    [pdfViewer showPdfInView:fileName];
    popupController = [[CNPPopupController alloc] initWithContents:@[pdfViewer]];
    popupController.theme = [self defaultTheme];
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
-(void)removePopOver{
    [popupController dismissPopupControllerAnimated:YES];
    NSLog(@"%@",pdfFileNamePaths);
    [baseController showEmailComposerWithPdfPath:pdfFileNamePaths];
    
}
- (CNPPopupTheme *)defaultTheme {
    CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 5.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = YES;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = self.frame.size.width;
    defaultTheme.animationDuration = 0.65f;
    return defaultTheme;
}
- (IBAction)acceptBtnClicked:(id)sender {
    [baseController removePopUpView];
    [imageArr addObject:[self takingScreenShot]];
    pdfFileNamePaths = [self createPdfWithName:@"FaqImageScreenShot" array:imageArr];
    baseController.pdfPath = pdfFileNamePaths;
    baseController.screenShotArray = imageArr;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadPdf:pdfFileNamePaths];
    });
}
-(UIImage*)takingScreenShot{
    CGRect rect = [_signatureView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_signatureView.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}
@end
