//
//  TemplatePopOverViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/28/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "TemplatePopOverViewController.h"
#import "Utility.h"

@interface TemplatePopOverViewController ()

@end

@implementation TemplatePopOverViewController
@synthesize parentClass;

- (id)initWithBaseController:(DesignViewController*)baseController {
    if ((self = [super init])) {
        // Clear background to ensure the content view shows through.
        parentClass = baseController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{

    int x = 0;
    CGRect frame;
    for (int i = 0; i < 8; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (i == 0) {
            frame = CGRectMake(10, 10, _templateScroller.frame.size.width - 20, _templateScroller.frame.size.height - 20);
        } else {
            frame = CGRectMake((i * (_templateScroller.frame.size.width - 20)) + (i*20) + 10, 10, _templateScroller.frame.size.width - 20, _templateScroller.frame.size.height - 20);
        }
        
        button.frame = frame;
        [button setTag:i];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"temp%d",i+1]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(templateClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_templateScroller addSubview:button];
        button.backgroundColor = [Utility colorWithHexString:@"0xCEDEE4"];
        
        if (i == 7) {
            x = CGRectGetMaxX(button.frame);
        }
    }
    
    _templateScroller.contentSize = CGSizeMake(x, _templateScroller.frame.size.height);

}
-(void)templateClicked:(id)sender{
    
    UIButton *btn = (UIButton*)sender;
    NSLog(@"Sender.tag %ld",btn.tag);
    [parentClass setSavedTemplateNumber:(int)btn.tag];

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
