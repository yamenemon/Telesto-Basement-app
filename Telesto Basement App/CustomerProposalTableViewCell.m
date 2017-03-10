//
//  CustomerProposalTableViewCell.m
//  Telesto Basement App
//
//  Created by CSM on 3/10/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomerProposalTableViewCell.h"

@implementation CustomerProposalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.cellImage.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.cellImage.layer setBorderWidth: 1.0];
    [self.cellImage.layer setCornerRadius:8.0];
    [self.infoView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.infoView.layer setBorderWidth: 1.0];
    self.infoView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
