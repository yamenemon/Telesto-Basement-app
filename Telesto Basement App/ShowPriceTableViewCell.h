//
//  ShowPriceTableViewCell.h
//  Telesto Basement App
//
//  Created by CSM on 7/27/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *quantityxPrice;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@end
