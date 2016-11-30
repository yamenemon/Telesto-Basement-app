//
//  PageContentViewController.h
//  PageViewDemo
//
//  Created by Simon on 24/11/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DrawingViewController;

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *templateScroller;
@property (strong, nonatomic) DrawingViewController *drawingVC;
@end
