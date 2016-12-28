//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"
#import "WYPopoverController.h"

@interface DesignViewController ()<WYPopoverControllerDelegate>

@end

@implementation DesignViewController
@synthesize productSliderView;
@synthesize buttonView;
@synthesize drawingView;
@synthesize wallContainerLabel;
@synthesize horizentalBtn;
@synthesize verticalBtn;
@synthesize basementDesignView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Drawing Window";
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [drawingView addGestureRecognizer:gestureRecognizer];
    isShown = NO;
}
-(void)viewWillLayoutSubviews{
    /*Scrolling window*/
    
    CGRect frame = productSliderView.frame;
    frame.origin.x = - frame.size.width+30;
    productSliderView.frame = frame;
    basementDesignView.layer.borderWidth = 2.0;
    basementDesignView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    basementDesignView.layer.cornerRadius = 2.0;
    
}
-(void)viewDidAppear:(BOOL)animated{

    [self createProductScroller];
}
-(void)createProductScroller{

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 150, productSliderView.frame.size.height)];
    
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
    scrollView.backgroundColor = [UIColor clearColor];
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
- (IBAction)horizentalLineBtn:(id)sender {
    CGRect gripFrame = CGRectMake(30, 0, 100, 30);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    [contentView setBackgroundColor:[UIColor blackColor]];
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [basementDesignView addSubview:userResizableView];
}
- (IBAction)verticalLineBtn:(id)sender {
    CGRect gripFrame = CGRectMake(0, 0, 30, 100);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    [contentView setBackgroundColor:[UIColor blackColor]];
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [basementDesignView addSubview:userResizableView];
}
- (IBAction)removeBtnClicked:(id)sender {
    [lastEditedView removeFromSuperview];
}


/*Button View button's Actions*/
- (IBAction)savedTemplateButtonAction:(id)sender {
    UIButton*button = (UIButton*)sender;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TemplatePopOverViewController *controller = [sb instantiateViewControllerWithIdentifier:@"TemplatePopOverViewController"];
    controller.parentClass = self;
    controller.preferredContentSize = CGSizeMake(600, 500);
    
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceRect = button.bounds;
    controller.popoverPresentationController.sourceView = button;
    popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popPC.delegate = self; //18
    [self presentViewController:controller animated:YES completion:nil];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
    return UIModalPresentationPopover; // 20
}

- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    return navController; // 21
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
