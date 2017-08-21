//
//  GalleryItem.h
//  UICollectionView_p1_ObjC
//
//  Created by olxios on 19/11/14.
//  Copyright (c) 2014 olxios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GalleryItem : NSObject

@property (nonatomic, assign) int itemId;
@property (nonatomic, strong) UIImage *itemImage;
@property (nonatomic, strong) NSString *itemDescription;

+ (instancetype)galleryItemWithDictionary:(NSDictionary *)dictionary;

@end
