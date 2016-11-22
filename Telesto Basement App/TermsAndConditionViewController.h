//
//  TermsAndConditionViewController.h
//  Telesto Basement App
//
//  Created by Emon on 11/15/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseViewController;

@interface TermsAndConditionViewController : UIViewController
{
    BaseViewController *baseViewController;
}
-(id)initWithBaseViewController:(BaseViewController*)mainController;
@end
