//
//  MediaPopUp.h
//  Telesto Basement App
//
//  Created by CSM on 6/7/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerRecordViewController;
@interface MediaPopUp : UIView <UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) CustomerRecordViewController *customerRecordVC;
@property (assign,nonatomic) BOOL isFromBuildingMedia;
@property (weak, nonatomic) IBOutlet UITableView *mediaPopUpTable;
-(void)initialize;
@end
