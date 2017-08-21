//
//  StoreImageDescriptionView.h
//  Telesto Basement App
//
//  Created by CSM on 8/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTextView.h"
#import "GalleryItem.h"

@class ProductStoreImageDescriptionViewController;
@interface StoreImageDescriptionView : UIView

@property (nonatomic,strong) GalleryItem *galleryItem;

@property (nonatomic, strong) ProductStoreImageDescriptionViewController *baseView;
@property (weak, nonatomic) IBOutlet MPTextView *descriptionTextView;
@end
