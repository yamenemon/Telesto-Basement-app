//
//  ShowPriceViewController.h
//  Telesto Basement App
//
//  Created by CSM on 2/2/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowPriceTableViewCell.h"
#import <CNPPopupController.h>
@class DesignViewController;
@class PricePopOver;
@class ProductObject;

@interface ShowPriceViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,CNPPopupControllerDelegate>{
    float summation;
    CNPPopupController *popupController;
    PricePopOver *pricePopOver;
}
@property (strong,nonatomic) NSMutableArray *priceListArray;
@property (strong,nonatomic) NSMutableArray*nonProductArray;
@property (weak, nonatomic) IBOutlet UITableView *priceTable;
@property (strong, nonatomic) DesignViewController* baseController;
@property (strong, nonatomic) NSMutableArray* productArray;
@property (strong, nonatomic) ShowPriceTableViewCell *showPriceTableCell;
@property (strong, nonatomic) NSMutableArray *downloadedProduct;
-(void)updateProductObjectWithObject:(ProductObject*)obj withSelectedRow:(int)selectedRow;
@end
