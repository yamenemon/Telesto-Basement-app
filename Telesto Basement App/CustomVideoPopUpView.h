//
//  CustomVideoPopUpView.h
//  Telesto Basement App
//
//  Created by CSM on 4/26/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  DesignViewController;

@interface CustomVideoPopUpView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate>{
    NSArray *_galleryItems;
    UICollectionView *snapShotCollectionView;
}
@property (weak, nonatomic) IBOutlet UIView *snapContainer;
@property (weak, nonatomic) IBOutlet UIImageView *bigScreenImageView;
@property (strong,nonatomic) DesignViewController *baseView;

@end
