//
//  DesignViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/19/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "DesignViewController.h"

@interface DesignViewController ()

@end

@implementation DesignViewController
@synthesize productSliderView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect appFrame = [[UIScreen mainScreen] bounds];
//    self.view = [[UIView alloc] initWithFrame:appFrame];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Drawing Window";
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:button];
//    button.frame = CGRectMake(20, 45, 80, 80);
//    [button setImage:[UIImage imageNamed:@"milky_way.jpg"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(placeBarImage:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *product = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:product];
//    product.frame = CGRectMake(120, 45, 80, 80);
//    [product setImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
//    [product addTarget:self action:@selector(productImage:) forControlEvents:UIControlEventTouchUpInside];
    
//    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 250, 20, 250, 50)];
//    [self.view addSubview:priceLabel];
//    priceLabel.text = @"Total Price: ";
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideEditingHandles)];
    [gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:gestureRecognizer];
    isShown = NO;
}
-(void)viewWillLayoutSubviews{

    
    /*Scrolling window*/
    
    CGRect frame = productSliderView.frame;
    frame.origin.x = - frame.size.width+30;
    productSliderView.frame = frame;
}
-(void)placeBarImage:(UIButton*)sender{
    
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(30, 30, 100, 100);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    [contentView setBackgroundColor:[UIColor blackColor]];
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [self.view addSubview:userResizableView];
    
}
-(void)productImage:(UIButton*)sender{
    
    // (1) Create a user resizable view with a simple red background content view.
    CGRect gripFrame = CGRectMake(30, 30, 200, 200);
    SPUserResizableView *userResizableView = [[SPUserResizableView alloc] initWithFrame:gripFrame];
    //    UIView *contentView = [[UIView alloc] initWithFrame:gripFrame];
    //    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grate-sump-plus-2.png"]]];
    NSInteger randomNumber = arc4random() % 16;
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",randomNumber]]];
    
    contentView.frame = gripFrame;
    userResizableView.contentView = contentView;
    userResizableView.delegate = self;
    [userResizableView showEditingHandles];
    currentlyEditingView = userResizableView;
    lastEditedView = userResizableView;
    [self.view addSubview:userResizableView];
    
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
