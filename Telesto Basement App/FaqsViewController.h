//
//  FaqsViewController.h
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@class BasicFAQTableViewCell;

@interface FaqsViewController : UIViewController <UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UIScrollView *faqScroller;

@property (strong,nonatomic) BasicFAQTableViewCell *basicFAQView;
@property (weak, nonatomic) IBOutlet UITableView *inspectionTableView;

@end
