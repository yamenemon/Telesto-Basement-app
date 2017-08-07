//
//  ProposalViewController.h
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProposalViewController : UIViewController
@property (strong,nonatomic) NSString*screenShotImagePath;
@property (weak, nonatomic) IBOutlet UITextView *agreementTextView;
@property (weak, nonatomic) IBOutlet UIImageView *floorPlanImageView;
@end
