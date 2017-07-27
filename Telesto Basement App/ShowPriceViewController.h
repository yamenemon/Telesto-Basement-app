//
//  ShowPriceViewController.h
//  Telesto Basement App
//
//  Created by CSM on 2/2/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPriceTableViewCell.h"
@class DesignViewController;
@class CustomProductView;
@interface ShowPriceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) DesignViewController* baseController;
@property (strong, nonatomic) CustomProductView* customProductView;
@property (strong, nonatomic) ShowPriceTableViewCell *showPriceTableCell;
@end
