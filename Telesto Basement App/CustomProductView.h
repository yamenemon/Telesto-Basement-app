//
//  CustomProductView.h
//  Telesto Basement App
//
//  Created by CSM on 3/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "SPUserResizableView.h"
@class DesignViewController;
@interface CustomProductView : SPUserResizableView
{
//    UIButton *cameraBtn;
}
@property (nonatomic,strong) UIButton *infoBtn;
@property (nonatomic,strong) DesignViewController *baseVC;
@end
