//
//  CustomTableViewCell.h
//  Telesto Basement App
//
//  Created by CSM on 3/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginLabel;

@property (weak, nonatomic) IBOutlet UIView *infoBaseView;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastLoginTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *proposalsBtn;
@end
