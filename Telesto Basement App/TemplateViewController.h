//
//  TemplateViewController.h
//  Telesto Basement App
//
//  Created by CSM on 11/29/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface TemplateViewController : UIViewController<UIPageViewControllerDataSource>{

    UICollectionView *_collectionView;
}
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end
