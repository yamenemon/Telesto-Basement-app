//
//  WebLoginViewController.h
//  Telesto Basement App
//
//  Created by CSM on 9/25/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebLoginViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
