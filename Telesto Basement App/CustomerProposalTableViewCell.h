//
//  CustomerProposalTableViewCell.h
//  Telesto Basement App
//
//  Created by CSM on 3/10/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerProposalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *proposalName;
@property (weak, nonatomic) IBOutlet UILabel *proposalDescription;

@end
