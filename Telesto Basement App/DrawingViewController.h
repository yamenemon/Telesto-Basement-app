//
//  DrawingViewController.h
//  Telesto Basement App
//
//  Created by CSM on 11/29/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
@interface DrawingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *drawingTemplateImageView;
-(void)selectedTemplate:(id)sender;
@end
