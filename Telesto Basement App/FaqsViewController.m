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

    float basicFAQViewHeight;
}

@end

@implementation FaqsViewController

@synthesize basicFAQView;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"FAQs";
}
@end
