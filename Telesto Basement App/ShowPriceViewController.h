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
@interface ShowPriceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) DesignViewController* baseController;
@property (strong, nonatomic) NSMutableArray* productArray;
@property (strong, nonatomic) ShowPriceTableViewCell *showPriceTableCell;
@property (strong, nonatomic) NSMutableArray *downloadedProduct;
@end
