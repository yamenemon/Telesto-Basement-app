//
//  PageContentViewController.m
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "PageContentViewController.h"
#import "DrawingViewController.h"
@interface PageContentViewController ()
{
    NSArray *pageImages;
}
@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillLayoutSubviews{
    
//    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Assets"];
//    NSString *filename = [NSString stringWithFormat:@"%@/%@", sourcePath, self.imageName];
//    
//    UIImage *image = [UIImage imageWithContentsOfFile:filename];
    
    pageImages = @[@"Temp1.png", @"Temp2.png", @"Temp3.png", @"Temp4.png", @"Temp5.png", @"Temp6.png", @"Temp7.png", @"Temp8.png"];
    CGSize templateScrollerSize = _templateScroller.frame.size;
    CGFloat contentWidth = 0.0;
    for (int imageNum = 0; imageNum< pageImages.count; imageNum++) {
        UIButton *scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (imageNum == 0) {
            scrollBtn.frame = CGRectMake(0, 0, templateScrollerSize.width, templateScrollerSize.height);
        }
        else{
            scrollBtn.frame = CGRectMake(templateScrollerSize.width*imageNum, 0, templateScrollerSize.width, templateScrollerSize.height);
        }
        if (imageNum == (pageImages.count-1)) {
            contentWidth = CGRectGetMaxX(scrollBtn.frame);
        }
        scrollBtn.tag = imageNum;
        [scrollBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[pageImages objectAtIndex:imageNum]]] forState:UIControlStateNormal];
        [scrollBtn addTarget:self action:@selector(onClickofTemplate:) forControlEvents:UIControlEventTouchUpInside];
        [_templateScroller addSubview:scrollBtn];
    }
    _templateScroller.contentSize = CGSizeMake(contentWidth, templateScrollerSize.height);
    
}
-(void)onClickofTemplate:(id)sender{

    [self.drawingVC selectedTemplate:sender];
    
}
- (IBAction)leftBtnClicked:(id)sender {
    if ( self.templateScroller.contentOffset.x >= self.templateScroller.frame.size.width ) {
        CGRect frame;
        frame.origin.x = self.templateScroller.contentOffset.x -self.templateScroller.frame.size.width;
        frame.origin.y = 0;
        frame.size = self.templateScroller.frame.size;
        [self.templateScroller scrollRectToVisible:frame animated:YES];
//        pageControlBeingUsed = YES;
    }
}
- (IBAction)rightBtnClicked:(id)sender {
    if ( self.templateScroller.contentOffset.x <= self.templateScroller.contentSize.width ) {
        CGRect frame;
        frame.origin.x = self.templateScroller.contentOffset.x +self.templateScroller.frame.size.width;
        frame.origin.y = 0;
        frame.size = self.templateScroller.frame.size;
        [self.templateScroller scrollRectToVisible:frame animated:YES];
//        pageControlBeingUsed = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
