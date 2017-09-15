//
//  ProductStoreImageEditingControllerViewController.h
//  Telesto Basement App
//
//  Created by CSM on 9/14/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryItem.h"
#import "MPTextView.h"
@class ProductStoreImageDescriptionViewController;


@interface ProductStoreImageEditingControllerViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    UIImage *gallerImage;
    UITextView *activeField;

}
@property (weak, nonatomic) IBOutlet MPTextView *productDescriptionTextField;
@property (strong,nonatomic) ProductStoreImageDescriptionViewController *baseViewController;
@property (weak, nonatomic) IBOutlet UIButton *imageViewer;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScroller;
@end

