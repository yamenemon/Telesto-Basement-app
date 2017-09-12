//
//  ProductStoreImageDescriptionViewController.m
//  Telesto Basement App
//
//  Created by CSM on 8/21/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "ProductStoreImageDescriptionViewController.h"
#import "DesignViewController.h"
@interface ProductStoreImageDescriptionViewController ()

@end

@implementation ProductStoreImageDescriptionViewController
@synthesize baseView,selectedButtonIndex,items;
@synthesize storeImageDescripView;
@synthesize productArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    self.carousel.type = iCarouselTypeCylinder;
    
    self.items = [[NSMutableArray alloc] init];
    
    for (CustomProductView *productObject  in productArray) {
        if (productObject.productObject.storedMediaArray.count>1) {
            self.items = productObject.productObject.storedMediaArray;
        }
        else{
            GalleryItem *gallery = [[GalleryItem alloc] init];
            gallery.itemId = selectedButtonIndex;
            gallery.itemDescription = @"Add Some Pictures.";
            [self.items addObject:gallery];
        }
        [self.carousel reloadData];
    }
    NSLog(@"%@",self.items);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[self.items count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];

    GalleryItem *galleryitems = [self.items objectAtIndex:index];
    ((UIImageView *)view).image = galleryitems.itemImage;
    view.contentMode = UIViewContentModeScaleToFill;
    view.layer.cornerRadius = 5.0f;
    view.layer.borderWidth = 2.0f;
    view.layer.borderColor = [UIColor whiteColor].CGColor;//UIColorFromRGB(0xFFFFF).CGColor;
    return view;
}

- (NSInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel
{
    //note: placeholder views are only displayed on some carousels if wrapping is disabled
    return 2;
}

- (UIView *)carousel:(__unused iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    
    //don't do anything specific to the index within
    //this `if (view == nil) {...}` statement because the view will be
    //recycled and used with other index values later
    view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    GalleryItem *galleryitems = [self.items objectAtIndex:index];
    ((UIImageView *)view).image = galleryitems.itemImage;
    view.contentMode = UIViewContentModeScaleToFill;
    view.layer.cornerRadius = 10.0f;
    view.layer.borderWidth = 2.0f;
    view.layer.borderColor = [UIColor blueColor].CGColor;
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.carousel.itemWidth);
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05;
        }
        case iCarouselOptionFadeMax:
        {
            if (self.carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0;
            }
            return value;
        }
        case iCarouselOptionShowBackfaces:
        case iCarouselOptionRadius:
        case iCarouselOptionAngle:
        case iCarouselOptionArc:
        case iCarouselOptionTilt:
        case iCarouselOptionCount:
        case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMinAlpha:
        case iCarouselOptionFadeRange:
        case iCarouselOptionOffsetMultiplier:
        case iCarouselOptionVisibleItems:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark iCarousel taps

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    //    NSNumber *item = (self.items)[(NSUInteger)index];
    //    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));

    GalleryItem *gallery = [self.items objectAtIndex:self.carousel.currentItemIndex];
    _imageDescripField.text = gallery.itemDescription;
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addBtnAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    // get the image
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    if(!img) img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData= UIImageJPEGRepresentation(img,0.1 /*compressionQuality*/);
    
    int imageSize   = (int)imgData.length;
    NSLog(@"size of image in KB: %f ", imageSize/1024.0);
    
    
    UIImage *image=[UIImage imageWithData:imgData];
    
    
    galleryItem = [[GalleryItem alloc] init];
    galleryItem.itemImage = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTextField];
    });
}
-(void)showTextField{
    storeImageDescripView = [[[NSBundle mainBundle] loadNibNamed:@"StoreImageDescriptionView" owner:self options:nil] objectAtIndex:0];
    storeImageDescripView.baseView = self;
    
    popupController = [[CNPPopupController alloc] initWithContents:@[storeImageDescripView]];
    popupController.theme = [self defaultTheme];
    popupController.theme.movesAboveKeyboard = YES;
    popupController.theme.popupStyle = CNPPopupStyleCentered;
    popupController.delegate = self;
    [popupController presentPopupControllerAnimated:YES];
}
- (CNPPopupTheme *)defaultTheme {
    CNPPopupTheme *defaultTheme = [[CNPPopupTheme alloc] init];
    defaultTheme.backgroundColor = [UIColor whiteColor];
    defaultTheme.cornerRadius = 5.0f;
    defaultTheme.popupContentInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    defaultTheme.popupStyle = CNPPopupStyleCentered;
    defaultTheme.presentationStyle = CNPPopupPresentationStyleFadeIn;
    defaultTheme.dismissesOppositeDirection = NO;
    defaultTheme.maskType = CNPPopupMaskTypeDimmed;
    defaultTheme.shouldDismissOnBackgroundTouch = NO;
    defaultTheme.movesAboveKeyboard = YES;
    defaultTheme.contentVerticalPadding = 16.0f;
    defaultTheme.maxPopupWidth = self.view.frame.size.width/2;
    defaultTheme.animationDuration = 0.65f;
    return defaultTheme;
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController*)picker{
    // image picker cancel, just dismiss it
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)updateCarouselWithText:(NSString*)text{
    [popupController dismissPopupControllerAnimated:YES];
     galleryItem.itemDescription = text;
    _imageDescripField.text = text;
    [self.items addObject:galleryItem];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.carousel reloadData];
    });
    for (CustomProductView *productView in productArray) {
        NSUInteger atIndex = [productArray indexOfObject:productView];
        if (atIndex == selectedButtonIndex) {
            [productView.productObject.storedMediaArray addObject:self.items];
            [productArray replaceObjectAtIndex:atIndex withObject:productView];
            baseView.productArray = productArray;
        }
    }
}

@end
