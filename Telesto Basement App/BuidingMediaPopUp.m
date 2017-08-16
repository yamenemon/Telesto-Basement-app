//
//  BuidingMediaPopUp.m
//  Telesto Basement App
//
//  Created by CSM on 6/29/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "BuidingMediaPopUp.h"
#import "CustomerRecordViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation BuidingMediaPopUp
@synthesize carousel;
@synthesize isFromCustomeProfile;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)initWithBaseController:(CustomerRecordViewController*)baseController withImageArray:(NSMutableArray*)imageArr{
    self.items = imageArr;
    _customerRecordController = baseController;
    self.carousel.type = iCarouselTypeCylinder;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    [self.carousel reloadData];
}

//- (IBAction)insertItem:(id)sender {
//    NSInteger index = MAX(0, self.carousel.currentItemIndex);
//    [self.items insertObject:@(self.carousel.numberOfItems) atIndex:(NSUInteger)index];
//    [self.carousel insertItemAtIndex:index animated:YES];
//}
- (IBAction)deleteItem:(id)sender {
    if (self.carousel.numberOfItems > 0)
    {
        if (self.carousel.numberOfItems == 1) {
            [_customerRecordController.popupController dismissPopupControllerAnimated:YES];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry!!" message:@"At least one building media should be there." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:ok];
            [ok setValue:UIColorFromRGB(0x0A5A78) forKey:@"titleTextColor"];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        else{
            NSInteger index = self.carousel.currentItemIndex;
            [self.items removeObjectAtIndex:(NSUInteger)index];
            [self.carousel removeItemAtIndex:index animated:YES];
            _customerRecordController.galleryItems = self.items;
            [_customerRecordController.snapShotCollectionView reloadData];
        }
    }
}
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
    ((UIImageView *)view).image = [self.items objectAtIndex:index];
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
    if (isFromCustomeProfile == YES) {
        NSURL *imageUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[self.items objectAtIndex:index]]];
        NSLog(@"building image url: %@",imageUrl);
        [((UIImageView *)view) sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"userName"]];
    }
    else{
        ((UIImageView *)view).image = [self.items objectAtIndex:index];
    }
    
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
    NSNumber *item = (self.items)[(NSUInteger)index];
    NSLog(@"Tapped view number: %@", item);
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel
{
    NSLog(@"Index: %@", @(self.carousel.currentItemIndex));
}
- (IBAction)dismissBuildingPopUp:(id)sender {
    [_customerRecordController.popupController dismissPopupControllerAnimated:YES];
}

@end
