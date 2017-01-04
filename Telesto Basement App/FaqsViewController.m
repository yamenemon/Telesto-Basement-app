//
//  FaqsViewController.m
//  Telesto Basement App
//
//  Created by CSM on 1/4/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "FaqsViewController.h"

static NSString *const kTableViewCellReuseIdentifier = @"TableViewCellReuseIdentifier";

@interface FaqsViewController (){

    NSArray *questionArray;
    NSArray *answerArray;

}

@end

@implementation FaqsViewController

@synthesize faqViewScroller;


-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FAQs";
    questionArray = [NSArray arrayWithObjects:
                              @"Q: What led you to call our company?",
                              @"Q: What year was your house built?",
                              @"Q: How long have you owned the home?",
                              @"Q: Selling Soon? If no, do you plan to stay 5, 10, 15+ years?",
                              @"Q: What's the specific problem?",
                              @"Q: How long has this gone on?",
                              @"Q: What frustrates you the most?",
                              @"Q: Who else has/will look at the problem?",
                              @"Q: Do you agree with solution offered?",
                              @"Q: What have you budgeted to fix it?",
                              @"Q: How quickly do you want it fixed?",nil];
    
    answerArray = [NSArray arrayWithObjects:
                            @"My basement leaks every time it rains and need to waterproof the basement",
                            @"1978",
                            @"12 years",
                            @"No, I plan on staying for another 5 years",
                            @"North basement wall leaks",
                            @"Last 2 weeks",
                            @"It gets flooded on heavy rain and ruined all my stuff on the last rain",
                            @"",
                            @"",
                            @"Not Much",
                            @"Immediately",nil];
    
    [self CustomFaqsViewWithNumber:(int)questionArray.count];
}
-(void)CustomFaqsViewWithNumber:(int)numberOfViews{
    int y = 0;
    
    int baseViewHeight = 150;
    
    CGRect frame;
    for (int i = 0; i < 10; i++) {
        
        UIView *faqView = [[UIView alloc] init];
        
        if (i == 0) {
            frame = CGRectMake(10, 10, self.view.frame.size.width - 20, baseViewHeight);
        } else {
            frame = CGRectMake(10, (i * baseViewHeight) + (i*20) + 10, self.view.frame.size.width - 20, baseViewHeight);
        }
        
        faqView.frame = frame;
        [faqView setTag:i];
        [faqView setBackgroundColor:[UIColor clearColor]];
        [faqViewScroller addSubview:faqView];
        
        if (i == 9) {
            y = CGRectGetMaxY(faqView.frame);
        }
        [self createFaqWithContainerView:faqView withTag:i];
    }
    
    faqViewScroller.contentSize = CGSizeMake(faqViewScroller.frame.size.width, y+10);
    faqViewScroller.backgroundColor = [UIColor clearColor];
}
-(void)createFaqWithContainerView:(UIView*)containerView withTag:(int)viewTag{

    float totalHeight = containerView.frame.size.height;
    float totalWidth =  containerView.frame.size.width;
    
    NSString *text = (NSString*)[questionArray objectAtIndex:viewTag];
    
    
    UILabel *questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,2,totalWidth-40,30)];
    questionLabel.text = [NSString stringWithFormat:@" %@",text];
    questionLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    questionLabel.numberOfLines = 1;
    questionLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    questionLabel.adjustsFontSizeToFitWidth = YES;
    questionLabel.minimumScaleFactor = 10.0f/12.0f;
    questionLabel.clipsToBounds = YES;
    questionLabel.backgroundColor = [Utility colorWithHexString:@"0xCEDEE4"];
    questionLabel.textColor = [UIColor blackColor];
    questionLabel.layer.cornerRadius = 5.0;
    questionLabel.layer.borderWidth = 0.5;
    questionLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    questionLabel.textAlignment = NSTextAlignmentLeft;
    [containerView addSubview:questionLabel];

    UITextView*txtview = [[UITextView alloc]initWithFrame:CGRectMake(20,questionLabel.frame.size.height+10,questionLabel.frame.size.width,totalHeight - (questionLabel.frame.size.height + 12))];
    [txtview setDelegate:self];
    txtview.text =[NSString stringWithFormat:@"A: %@",(NSString*)[answerArray objectAtIndex:viewTag]] ;
    txtview.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    [txtview setReturnKeyType:UIReturnKeyDone];
    [txtview setTag:viewTag];
    txtview.layer.cornerRadius = 5.0;
    txtview.backgroundColor = [UIColor lightTextColor];
    txtview.layer.borderWidth = 0.5;
    txtview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [containerView addSubview:txtview];
    txtview.editable = NO;
    if ([(NSString*)[answerArray objectAtIndex:viewTag] isEqualToString:@""]) {
        txtview.editable = YES;
    }
}
@end
