//
//  CustomTemplateNameView.h
//  Telesto Basement App
//
//  Created by CSM on 3/20/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DesignViewController;

@interface CustomTemplateNameView : UIView

@property (weak, nonatomic) IBOutlet UITextField *templateNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveBtnForSavingTemplate;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong,nonatomic) DesignViewController *designViewController;
@end
