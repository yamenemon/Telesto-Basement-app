//
//  CustomVideoPopUpView.m
//  Telesto Basement App
//
//  Created by CSM on 4/26/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomVideoPopUpView.h"
#import "GalleryItem.h"
#import "GalleryItemCollectionViewCell.h"
#import "GalleryItemCommentView.h"
@implementation CustomVideoPopUpView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -
#pragma mark - View Lifecycle

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self initGalleryItems];
        
        [_collectionView reloadData];
    }
    return self;
}
- (void)initGalleryItems
{
    NSMutableArray *items = [NSMutableArray array];
    
    NSString *inputFile = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"plist"];
    NSArray *inputDataArray = [NSArray arrayWithContentsOfFile:inputFile];
    
    for (NSDictionary *inputItem in inputDataArray)
    {
        [items addObject:[GalleryItem galleryItemWithDictionary:inputItem]];
    }
    
    _galleryItems = items;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_galleryItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryItemCollectionViewCell" forIndexPath:indexPath];
    [cell setGalleryItem:_galleryItems[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GalleryItemCommentView *commentView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GalleryItemCommentView" forIndexPath:indexPath];
    
    commentView.commentLabel.text = [NSString stringWithFormat:@"Supplementary view of kind %@", kind];
    return commentView;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"didSelectItemAtIndexPath:"
                                                                        message: [NSString stringWithFormat: @"Indexpath = %@", indexPath]
                                                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss"
                                                          style: UIAlertActionStyleDestructive
                                                        handler: nil];
    
    [controller addAction: alertAction];
    
//    [self presentViewController: controller animated: YES completion: nil];
}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.frame.size.width / 4.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat leftRightInset = self.frame.size.width / 14.0f;
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset);
}
@end
