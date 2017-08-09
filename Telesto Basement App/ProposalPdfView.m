//
//  ProposalPdfView.m
//  Telesto Basement App
//
//  Created by CSM on 8/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProposalPdfView.h"

@implementation ProposalPdfView
@synthesize pdfViewer;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)showPdfInView:(NSString*)filePath{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.pdfViewer loadRequest:request];
    self.pdfViewer.backgroundColor = [UIColor whiteColor];
}
@end
