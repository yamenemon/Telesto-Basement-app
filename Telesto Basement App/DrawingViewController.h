//
//  DrawingViewController.h
//  Telesto Basement App
//
//  Created by CSM on 11/29/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
#import "SWRevealViewController.h"
@interface DrawingViewController : UIViewController<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
-(void)selectedTemplate:(id)sender;
@end
