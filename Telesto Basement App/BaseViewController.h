//
//  BaseViewController.h
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TermsAndConditionViewController.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "loginView.h"
#import <AVFoundation/AVFoundation.h>
#import "MTReachabilityManager.h"
#import "CustomerDataManager.h"
#import <MBProgressHUD.h>
#import "WebLoginViewController.h"

@interface BaseViewController : UIViewController<UITextFieldDelegate,UIPopoverPresentationControllerDelegate,UIPopoverControllerDelegate>{
    MBProgressHUD *hud;
}
@property (strong,nonatomic) loginView *customLoginView;


@end
