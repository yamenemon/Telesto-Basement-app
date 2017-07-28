//
//  ShowPriceViewController.h
//  Telesto Basement App
//
//  Created by CSM on 2/2/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPriceTableViewCell.h"
#import "PriceTableFooterView.h"
@class DesignViewController;
@interface ShowPriceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *priceTable;
@property (strong, nonatomic) DesignViewController* baseController;
@property (strong, nonatomic) NSMutableArray* productArray;
@property (strong, nonatomic) ShowPriceTableViewCell *showPriceTableCell;
@property (strong, nonatomic) NSMutableArray *downloadedProduct;
@end
