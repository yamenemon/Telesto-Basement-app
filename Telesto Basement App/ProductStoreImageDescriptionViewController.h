//
//  ProductStoreImageDescriptionViewController.h
//  Telesto Basement App
//
//  Created by CSM on 8/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "GalleryItem.h"
#import "CNPPopupController.h"
#import "StoreImageDescriptionView.h"
#import "CustomProductView.h"
#import "ProductObject.h"
#import "ProductStoreImageEditingControllerViewController.h"
@class DesignViewController;

@interface ProductStoreImageDescriptionViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,iCarouselDelegate,iCarouselDataSource,CNPPopupControllerDelegate>{
    CNPPopupController *popupController;
    GalleryItem *galleryItem;
}
@property (strong,nonatomic) StoreImageDescriptionView *storeImageDescripView;
@property (assign,nonatomic) int selectedButtonIndex;
@property (strong,nonatomic) DesignViewController *baseView;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UITextView *imageDescripField;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,strong) NSMutableArray *productImageDescriptionArray;
@property (nonatomic,strong) GalleryItem *recentGalleryItem;

-(void)updateCarouselWithText:(NSString*)text;
-(void)getGalleryItem:(GalleryItem*)galleryItems;
@end
