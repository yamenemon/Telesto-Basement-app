//
//  FaqsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "FaqsViewController.h"
#import "BasicFAQTableViewCell.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface FaqsViewController (){

    float basicFAQViewHeight;
}

@end

@implementation FaqsViewController

@synthesize basicFAQView;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FAQs";
//    _faqScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    [self.view addSubview:_faqScroller];
    
    
}
//-(void)viewWillAppear:(BOOL)animated{
//    if( [self respondsToSelector:@selector(setEdgesForExtendedLayout:)] )
//    {
//        self.edgesForExtendedLayout=UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars=NO;
//        self.automaticallyAdjustsScrollViewInsets=NO;
//    }
//    _inspectionTableView.delegate = self;
//    _inspectionTableView.dataSource = self;
//}
//-(void)viewWillLayoutSubviews{
//    basicFAQViewHeight = basicFAQView.frame.size.height;
//}
//-(void)createFAQUserInterface{
//    
//}
//
//#pragma mark -
//#pragma mark UITableView Delegate & DataSource
//#pragma mark -
//
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
//        return 1;
//    }
//    return 3;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *simpleTableIdentifier = @"CustomTableViewCell";
//    
//    BasicFAQTableViewCell *cell = (BasicFAQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    if (cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BasicFAQTableViewCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//    
//    switch (indexPath.section) {
//        case 0:
//        {
//            if (indexPath.row==0) {
//                static NSString *simpleTableIdentifier = @"CustomTableViewCell";
//                
//                BasicFAQTableViewCell *cell = (BasicFAQTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//                if (cell == nil)
//                {
//                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BasicFAQTableViewCell" owner:self options:nil];
//                    cell = [nib objectAtIndex:0];
//                }
//            }
//            break;
//        }
//            
//        default:
//            break;
//    }
//    //etc.
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        return basicFAQViewHeight;
//    }
//    return basicFAQViewHeight;
//}
























//-(void)CustomFaqsViewWithNumber:(int)numberOfViews{
//    int y = 0;
//    
//    int baseViewHeight = 150;
//    
//    CGRect frame;
//    for (int i = 0; i < 10; i++) {
//        
//        UIView *faqView = [[UIView alloc] init];
//        
//        if (i == 0) {
//            frame = CGRectMake(10, 10, self.view.frame.size.width - 20, baseViewHeight);
//        } else {
//            frame = CGRectMake(10, (i * baseViewHeight) + (i*20) + 10, self.view.frame.size.width - 20, baseViewHeight);
//        }
//        
//        faqView.frame = frame;
//        [faqView setTag:i];
//        [faqView setBackgroundColor:[UIColor clearColor]];
//        [faqViewScroller addSubview:faqView];
//        
//        if (i == 9) {
//            y = CGRectGetMaxY(faqView.frame);
//        }
//        [self createFaqWithContainerView:faqView withTag:i];
//    }
//    
//    faqViewScroller.contentSize = CGSizeMake(faqViewScroller.frame.size.width, y+10);
//    faqViewScroller.backgroundColor = [UIColor clearColor];
//}
//-(void)createFaqWithContainerView:(UIView*)containerView withTag:(int)viewTag{
//
//    float totalHeight = containerView.frame.size.height;
//    float totalWidth =  containerView.frame.size.width;
//    
//    NSString *text = (NSString*)[questionArray objectAtIndex:viewTag];
//    
//    
//    UILabel *questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,2,totalWidth-40,30)];
//    questionLabel.text = [NSString stringWithFormat:@" %@",text];
//    questionLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
//    questionLabel.numberOfLines = 1;
//    questionLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
//    questionLabel.adjustsFontSizeToFitWidth = YES;
//    questionLabel.minimumScaleFactor = 10.0f/12.0f;
//    questionLabel.clipsToBounds = YES;
//    questionLabel.backgroundColor = [Utility colorWithHexString:@"0xCEDEE4"];
//    questionLabel.textColor = [UIColor blackColor];
//    questionLabel.layer.cornerRadius = 5.0;
//    questionLabel.layer.borderWidth = 0.5;
//    questionLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    questionLabel.textAlignment = NSTextAlignmentLeft;
//    [containerView addSubview:questionLabel];
//
//    UITextView*txtview = [[UITextView alloc]initWithFrame:CGRectMake(20,questionLabel.frame.size.height+10,questionLabel.frame.size.width,totalHeight - (questionLabel.frame.size.height + 12))];
//    [txtview setDelegate:self];
//    txtview.text =[NSString stringWithFormat:@"A: %@",(NSString*)[answerArray objectAtIndex:viewTag]] ;
//    txtview.font = [UIFont fontWithName:@"Roboto-Light" size:14];
//    [txtview setReturnKeyType:UIReturnKeyDone];
//    [txtview setTag:viewTag];
//    txtview.layer.cornerRadius = 5.0;
//    txtview.backgroundColor = [UIColor lightTextColor];
//    txtview.layer.borderWidth = 0.5;
//    txtview.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    [containerView addSubview:txtview];
//    txtview.editable = NO;
//    if ([(NSString*)[answerArray objectAtIndex:viewTag] isEqualToString:@""]) {
//        txtview.editable = YES;
//    }
//}
@end
