//
//  CustomProductView.h
//  Telesto Basement App
//
//  Created by CSM on 3/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "SPUserResizableView.h"
@class DesignViewController;
@class ProductObject;

@interface CustomProductView : SPUserResizableView
{
//    UIButton *cameraBtn;
}
@property (nonatomic,strong) UIButton *infoBtn;
@property (nonatomic, assign) int productID;
@property (nonatomic,strong) DesignViewController *baseVC;
@property (strong,nonatomic) ProductObject *productObject;
@end
