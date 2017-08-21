//
//  GalleryItem.m
//  UICollectionView_p1_ObjC
//
//  Created by olxios on 19/11/14.
//  Copyright (c) 2014 olxios. All rights reserved.
//

#import "GalleryItem.h"

@implementation GalleryItem

+ (instancetype)galleryItemWithDictionary:(NSDictionary *)dictionary
{
    GalleryItem *item = [[GalleryItem alloc] init];
    
    item.itemId = dictionary[@"itemId"];
    item.itemImage = dictionary[@"itemImage"];
    item.itemDescription = dictionary[@"itemDescription"];
    return item;
}

@end
