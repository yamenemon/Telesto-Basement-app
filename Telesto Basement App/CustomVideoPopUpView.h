//
//  CustomVideoPopUpView.h
//  Telesto Basement App
//
//  Created by CSM on 4/26/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomVideoPopUpView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *_galleryItems;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
