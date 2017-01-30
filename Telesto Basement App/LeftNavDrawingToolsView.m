//
//  LeftNavDrawingToolsView.m
//  Telesto Basement App
//
//  Created by CSM on 1/25/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "LeftNavDrawingToolsView.h"
#import "DesignViewController.h"
@implementation LeftNavDrawingToolsView
@synthesize baseClass;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)menuBtnClicked:(id)sender {
    [baseClass revealButtonItemClicked:sender];
}
- (IBAction)wallBtnClicked:(id)sender {
    NSLog(@"Wall Button Clicked");
    [baseClass wallPopOverBtnAction:sender];
}
- (IBAction)stairBtnClicked:(id)sender {
    NSLog(@"Stair Button Clicked");
}
- (IBAction)doorBtnClicked:(id)sender {
    NSLog(@"Door Button Clicked");
}
- (IBAction)windowBtnClicked:(id)sender {
    NSLog(@"Window Button Clicked");
}
- (IBAction)moreBtnClicked:(id)sender {
    NSLog(@"More Button Clicked");
}
- (IBAction)deleteBtnPressed:(id)sender {
    [baseClass removeBtnClicked];
}

@end
