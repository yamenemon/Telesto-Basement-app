//
//  CustomVideoPopUpView.m
//  Telesto Basement App
//
//  Created by CSM on 4/26/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomVideoPopUpView.h"
#import "DesignViewController.h"
#import "GalleryItem.h"

@implementation CustomVideoPopUpView
@synthesize snapContainer;
@synthesize baseView;
@synthesize selectedVideoPopUpBtnTag;
@synthesize userCapturedImageUrl;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -
#pragma mark - View Lifecycle
-(void)awakeFromNib{
    [super awakeFromNib];
//    [self initGalleryItems];
    

    UICollectionViewFlowLayout *flo = [[UICollectionViewFlowLayout alloc] init];
    
    snapShotCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-16, snapContainer.frame.size.height) collectionViewLayout:flo];
    snapShotCollectionView.delegate = self;
    snapShotCollectionView.dataSource = self;
    snapShotCollectionView.backgroundColor = [UIColor clearColor];
    [snapShotCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionViewcell"];
    [snapContainer addSubview:snapShotCollectionView];
    
    [snapShotCollectionView reloadData];
}
- (void)initGalleryItems
{
//    NSMutableArray *items = [NSMutableArray array];
//    
//    NSString *inputFile = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"plist"];
//    NSArray *inputDataArray = [NSArray arrayWithContentsOfFile:inputFile];
//    
//    for (NSDictionary *inputItem in inputDataArray)
//    {
//        [items addObject:[GalleryItem galleryItemWithDictionary:inputItem]];
//    }
//
//    _galleryItems = items;
    _galleryItems = [self listFileAtPath:baseView.templateNameString];
}
-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    NSLog(@"Path of the image: %@",path);
    int count;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%d",path,selectedVideoPopUpBtnTag]];
    NSLog(@"product folder path: %@",dataPath);
    
    NSMutableArray *imagePathArray = [[NSMutableArray alloc] init];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
        NSString *imagePath = [NSString stringWithFormat:@"%@/%@",dataPath,[directoryContent objectAtIndex:count]];
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imagePath]];
        UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
        [imagePathArray addObject:thumbNail];
    }
    return imagePathArray;
}
#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_galleryItems count]+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewcell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor greenColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:imageView];
    if (indexPath.row==0) {
        imageView.image = [UIImage imageNamed:@"cameraThumb"];
    }
    else{
//        [self setGalleryItem:[_galleryItems objectAtIndex:indexPath.row-1] withImageView:imageView];
        imageView.image = [_galleryItems objectAtIndex:indexPath.row-1];
        _bigScreenImageView.image = imageView.image;
    }
    return cell;
}
- (UIImageView*)setGalleryItem:(GalleryItem *)item withImageView:(UIImageView*)_itemImageView
{
    
//    _itemImageView.image = [UIImage imageNamed:item.itemImage];
    return _itemImageView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [baseView openCameraWindow];
    }
    else{
//        [self setGalleryItem:[_galleryItems objectAtIndex:indexPath.row-1] withImageView:_bigScreenImageView];
        _bigScreenImageView.image = [_galleryItems objectAtIndex:indexPath.row-1];
    }
    
}

#pragma mark -
#pragma mark - UICollectionViewFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat picDimension = self.frame.size.width / 6.0f;
    return CGSizeMake(picDimension, picDimension);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}
@end
