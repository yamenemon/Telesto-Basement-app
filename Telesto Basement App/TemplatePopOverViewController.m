//
//  TemplatePopOverViewController.m
//  Telesto Basement App
//
//  Created by CSM on 12/28/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "TemplatePopOverViewController.h"
#import "Utility.h"

@interface TemplatePopOverViewController ()
@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;

@end

@implementation TemplatePopOverViewController
@synthesize parentClass;
@synthesize templateArray;

- (id)initWithBaseController:(DesignViewController*)baseController {
    if ((self = [super init])) {
        // Clear background to ensure the content view shows through.
        parentClass = baseController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CustomerDataManager *manager = [CustomerDataManager sharedManager];
    NSMutableArray *temp = [manager getTemplateObjectArray];
    templateArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<temp.count; i++) {
        DefaultTemplateObject *obj = [temp objectAtIndex:i];
        NSString *image = [manager loadDefaultTemplateImageWithImageName:obj.templateName];
        [templateArray addObject:image];
    }
    NSLog(@"%@",templateArray);
    
    self.iCarouselView.delegate = self;
    self.iCarouselView.dataSource = self;
    self.iCarouselView.type = iCarouselTypeCylinder;
}
-(void)viewDidAppear:(BOOL)animated{

//    [self makeScrollView];
    

}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(__unused iCarousel *)carousel
{
    return (NSInteger)[templateArray count];
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,500,300)];
        NSString *imageName = [NSString stringWithFormat:@"%@",[templateArray objectAtIndex:index]];
        ((UIImageView *)view).image = [UIImage imageNamed:imageName];
        view.contentMode = UIViewContentModeScaleToFill;
        view.layer.cornerRadius = 2.0f;
        view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        view.layer.borderWidth = 2.0f;
        view.backgroundColor = [UIColor lightTextColor];
    }
    
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
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,500,300)];
        NSString *imageName = [NSString stringWithFormat:@"%@",[templateArray objectAtIndex:index]];
        ((UIImageView *)view).image = [UIImage imageNamed:imageName];
        view.contentMode = UIViewContentModeScaleToFill;
        view.layer.cornerRadius = 2.0f;
        view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        view.layer.borderWidth = 2.0f;
        view.backgroundColor = [UIColor lightTextColor];
    }
    return view;
}

- (CATransform3D)carousel:(__unused iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0.0, 1.0, 0.0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * self.iCarouselView.itemWidth);
}
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    [parentClass setSavedTemplateNumber:[templateArray objectAtIndex:index]];
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
            if (self.iCarouselView.type == iCarouselTypeCustom)
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


//-(void)makeScrollView{
//    int x = 0;
//    CGRect frame;
//    for (int i = 0; i < templateArray.count; i++) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        if (i == 0) {
//            frame = CGRectMake(10, 10, _templateScroller.frame.size.width - 20, _templateScroller.frame.size.height - 20);
//        } else {
//            frame = CGRectMake((i * (_templateScroller.frame.size.width - 20)) + (i*20) + 10, 10, _templateScroller.frame.size.width - 20, _templateScroller.frame.size.height - 20);
//        }
//        
//        button.frame = frame;
//        [button setTag:i];
//        [button setImage:[UIImage imageNamed:[templateArray objectAtIndex:i]] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(templateClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [_templateScroller addSubview:button];
//        button.backgroundColor = [Utility colorWithHexString:@"0xCEDEE4"];
//        
//        if (i == templateArray.count) {
//            x = CGRectGetMaxX(button.frame);
//        }
//    }
//    
//    _templateScroller.contentSize = CGSizeMake(x, _templateScroller.frame.size.height);
//}

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

@end
