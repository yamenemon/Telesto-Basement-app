//
//  CustomerProposalsViewController.h
//  Telesto Basement App
//
//  Created by CSM on 3/9/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerInfoObject.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomerProposalsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) CustomerInfoObject *customInfoObject;
@property (weak, nonatomic) IBOutlet UIImageView *customerProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *proposalBtn;
@property (weak, nonatomic) IBOutlet UIButton *editProfileBTn;
@property (weak, nonatomic) IBOutlet UILabel *streetLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@end
