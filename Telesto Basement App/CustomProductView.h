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

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) int productId;
@property (nonatomic, assign) NSString* staticId;
@property (nonatomic, assign) float productXcoordinate;
@property (nonatomic, assign) float productYcoordinate;
@property (nonatomic, assign) float productWidth;
@property (nonatomic, assign) float productHeight;
@property (nonatomic, strong) NSString *productColor;
@property (nonatomic, assign) float productQuantity;
@property (nonatomic, assign) float productUnitPrice;
@property (nonatomic, strong) NSString *productUnitType;
@property (nonatomic, assign) float productDiscount;
@property (nonatomic, strong) NSMutableArray *storedMediaArray;

@end
