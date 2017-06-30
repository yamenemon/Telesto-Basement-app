//
//  BuidingMediaPopUp.h
//  Telesto Basement App
//
//  Created by CSM on 6/29/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@class CustomerRecordViewController;
@interface BuidingMediaPopUp : UIView<iCarouselDelegate,iCarouselDataSource>
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) CustomerRecordViewController *customerRecordController;
-(void)initWithBaseController:(CustomerRecordViewController*)baseController withImageArray:(NSMutableArray*)imageArr;
@end
