//
//  CustomTableViewCell.m
//  Telesto Basement App
//
//  Created by CSM on 3/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cellImageView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.cellImageView.layer setBorderWidth: 1.0];
    [self.cellImageView.layer setCornerRadius:5.0];
    [self.infoBaseView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.infoBaseView.layer setBorderWidth: 1.0];
    self.infoBaseView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
