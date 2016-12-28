//
//  TemplatePopOverViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/28/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignViewController.h"

@class DesignViewController;
@interface TemplatePopOverViewController : UIViewController

@property (nonatomic,strong) DesignViewController *parentClass;
@property (weak, nonatomic) IBOutlet UIScrollView *templateScroller;
@end
