//
//  CustomerListViewController.h
//  Telesto Basement App
//
//  Created by CSM on 12/4/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "SWRevealViewController.h"
@interface CustomerListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UITableView *sliderTableView;
@property (weak, nonatomic) IBOutlet UITableView *customerListTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *customerSearchBar;
@property (assign,nonatomic) BOOL isShown;
@end
