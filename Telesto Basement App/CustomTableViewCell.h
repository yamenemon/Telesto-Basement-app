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

@property (weak, nonatomic) IBOutlet UIView *infoBaseView;
@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;

    @property (weak, nonatomic) IBOutlet UILabel *streetAddress;
    @property (weak, nonatomic) IBOutlet UILabel *citZip;
    @property (weak, nonatomic) IBOutlet UILabel *salesAppointment;

@property (weak, nonatomic) IBOutlet UIButton *MapItBtn;
@property (weak, nonatomic) IBOutlet UIButton *customProfileBtn;

@end
