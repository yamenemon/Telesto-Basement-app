//
//  DrawingViewController.m
//  Telesto Basement App
//
//  Created by CSM on 11/29/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DrawingViewController.h"

@interface DrawingViewController (){

    UIPopoverController *popover;
}
@end

@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savedTemplateButtonPressed:(id)sender {
    UIButton *anchor = (UIButton*)sender;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PageContentViewController *viewControllerForPopover = [storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    viewControllerForPopover.drawingVC = self;
    
    popover = [[UIPopoverController alloc]
               initWithContentViewController:viewControllerForPopover];
    [popover setPopoverContentSize:CGSizeMake(1000,700)]; // here see if you can get expected size
    [popover presentPopoverFromRect:anchor.frame
                             inView:anchor.superview
           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
-(void)selectedTemplate:(id)sender{
    [popover dismissPopoverAnimated:NO];
    UIButton *btn = (UIButton*)sender;
    NSLog(@"template index:%ld",(long)btn.tag);
    _drawingTemplateImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Temp%ld",(long)btn.tag+1]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
