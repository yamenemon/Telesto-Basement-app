//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"
#import "WYPopoverController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface DesignViewController ()<WYPopoverControllerDelegate>

@end

@implementation DesignViewController
@synthesize productSliderView;
@synthesize basementDesignView;
CGFloat firstX;
CGFloat firstY;
CGFloat lastRotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    lastRotation = 0.0;
   
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Drawing Window";
    [self.navigationItem setHidesBackButton:YES];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [basementDesignView addGestureRecognizer:gestureRecognizer];
    isShown = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view setNeedsDisplay];
    });

}
-(BOOL)prefersStatusBarHidden{
    return NO;
}
-(void)viewWillAppear:(BOOL)animated{

    LeftNavDrawingToolsView *leftNavBtnBar = [[[NSBundle mainBundle] loadNibNamed:@"LeftNavDrawingToolsView" owner:self options:nil] objectAtIndex:0];
    [self.navigationController.navigationBar addSubview:leftNavBtnBar];
    leftNavBtnBar.baseClass = self;
    
    RightNavDrwaingToolsView *rightNavBtnBar = [[[NSBundle mainBundle] loadNibNamed:@"RightNavDrwaingToolsView" owner:self options:nil] objectAtIndex:0];
    rightNavBtnBar.frame = CGRectMake(self.view.frame.size.width - rightNavBtnBar.frame.size.width, 0, rightNavBtnBar.frame.size.width, rightNavBtnBar.frame.size.height);
    [self.navigationController.navigationBar addSubview:rightNavBtnBar];
    rightNavBtnBar.baseClass = self;
}
-(void)viewDidLayoutSubviews:(BOOL)animated{
    /*Scrolling window*/
    [super viewWillLayoutSubviews];
    CGRect frame = productSliderView.frame;
    frame.origin.x = -frame.size.width+100;
    productSliderView.frame = frame;
}
-(void)viewDidAppear:(BOOL)animated{
    [self createProductScroller];
}
-(void)createProductScroller{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,150, productSliderView.frame.size.height)];
    
    int y = 0;
    CGRect frame;
    for (int i = 0; i < 10; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        if (i == 0) {
            frame = CGRectMake(10, 10, 80, 80);
        } else {
            frame = CGRectMake(10, (i * 80) + (i*20) + 10, 80, 80);
        }
        
        button.frame = frame;
        [button setTag:i];
        [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]]]];
        [button addTarget:self action:@selector(productBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        if (i == 9) {
            y = CGRectGetMaxY(button.frame);
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width,y);
    scrollView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [productSliderView addSubview:scrollView];

}
-(void)productBtnClicked:(id)sender{
    UIButton *productBtn = (UIButton*)sender;
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(100, 10, 150, 150);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",productBtn.tag]]];
    contentView.frame = gripFrame;
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [basementDesignView addSubview:userResizableView];
    [self productSliderCalled:nil];
}
- (void)userResizableViewDidEndEditing:(SPUserResizableView *)userResizableView {
    lastEditedView = userResizableView;
}
-(void)backButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([currentlyEditingView hitTest:[touch locationInView:currentlyEditingView] withEvent:nil]) {
        return NO;
    }
    return YES;
}

- (void)hideEditingHandles {
    // We only want the gesture recognizer to end the editing session on the last
    // edited view. We wouldn't want to dismiss an editing session in progress.
    [lastEditedView hideEditingHandles];
}
- (IBAction)productSliderCalled:(id)sender {
    
    if (isShown==NO) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = productSliderView.frame;
                             frame.origin.x = 0;
                             productSliderView.frame = frame;
                         } completion:nil];
        isShown = YES;
    }
    else{
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect frame = productSliderView.frame;
                             frame.origin.x = - frame.size.width+30;
                             productSliderView.frame = frame;
                         } completion:nil];
        isShown = NO;
    }
}
- (IBAction)removeBtnClicked:(id)sender {
    [lastEditedView removeFromSuperview];
}


/*Button View button's Actions*/
- (void)savedTemplateButtonAction:(id)sender {
    UIButton*button = (UIButton*)sender;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    templateController = [sb instantiateViewControllerWithIdentifier:@"TemplatePopOverViewController"];
    templateController.parentClass = self;
    templateController.preferredContentSize = CGSizeMake(600, 500);
    
    templateController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPC = templateController.popoverPresentationController;
    templateController.popoverPresentationController.sourceRect = button.bounds;
    templateController.popoverPresentationController.sourceView = button;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.delegate = self;
    [self presentViewController:templateController animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationPopover;
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController;
}
-(void)setSavedTemplateNumber:(int)number{
    
    if (drawingImageView) {
        [drawingImageView removeFromSuperview];
    }
    drawingImageView = [[UIImageView alloc] init];
    
    [templateController dismissViewControllerAnimated:YES completion:^{
        drawingImageView.frame = CGRectMake(0, 0, basementDesignView.frame.size.width, basementDesignView.frame.size.height);
        [drawingImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"temp%d",number]]];
        [basementDesignView addSubview:drawingImageView];
    }];
}


- (void)wallPopOverBtnAction:(id)sender {
    
    UIButton *wallBtn = (UIButton*)sender;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil
                                                            message: nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *horizentalAction =  [UIAlertAction actionWithTitle: @"Horizental" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(30, 0, 100, 30);
        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        
    }];
    [horizentalAction setValue:[[UIImage imageNamed:@"Horizontal_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [horizentalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];

    [alertController addAction:horizentalAction];

    
    UIAlertAction *verticalAction =  [UIAlertAction actionWithTitle: @"Vertical" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        CGRect gripFrame = CGRectMake(0, 0, 30, 100);
        SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
        UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
        [contentView setBackgroundColor:[UIColor lightGrayColor]];
        userResizableView.contentView = contentView;
        userResizableView.delegate = self;
        [userResizableView showEditingHandles];
        currentlyEditingView = userResizableView;
        lastEditedView = userResizableView;
        [basementDesignView addSubview:userResizableView];
        
    }];
    [verticalAction setValue:[[UIImage imageNamed:@"Vertical_wall"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [verticalAction setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
    [alertController addAction:verticalAction];
    
    alertController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController * popover = alertController.popoverPresentationController;
    popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popover.sourceView = wallBtn;
    popover.sourceRect = wallBtn.bounds;
    
    [self presentViewController: alertController animated: YES completion: nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
