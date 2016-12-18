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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
}


#pragma mark state preservation / restoration

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    
    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
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
    viewControllerForPopover.preferredContentSize = CGSizeMake(1000,700);
    
    
    
    viewControllerForPopover.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:viewControllerForPopover animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [viewControllerForPopover popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    
    // in case we don't have a bar button as reference
    popController.sourceView = anchor.superview;
    popController.sourceRect =  anchor.frame;
}
-(void)selectedTemplate:(id)sender{
    [popover dismissPopoverAnimated:NO];
    UIButton *btn = (UIButton*)sender;
    NSLog(@"template index:%ld",(long)btn.tag);
//    _drawingTemplateImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Temp%ld",(long)btn.tag+1]];
}
# pragma mark - Popover Presentation Controller Delegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{

    return UIModalPresentationNone;

}
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
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
