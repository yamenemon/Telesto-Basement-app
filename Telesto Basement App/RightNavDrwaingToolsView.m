
//
//  RightNavDrwaingToolsView.m
//  Telesto Basement App
//
//  Created by CSM on 1/26/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "RightNavDrwaingToolsView.h"
#import "DesignViewController.h"
@implementation RightNavDrwaingToolsView
@synthesize baseClass;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)saveButtonClicked:(id)sender {
    [baseClass saveButtonAction:sender];
}
- (IBAction)flipButtonClicked:(id)sender {
    [baseClass flipTheObject];
}
- (IBAction)exitButtonClicked:(id)sender {
    [baseClass backButtonAction];
}

@end
