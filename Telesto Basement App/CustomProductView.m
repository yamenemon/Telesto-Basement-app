//
//  CustomProductView.m
//  Telesto Basement App
//
//  Created by CSM on 3/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomProductView.h"
#import "DesignViewController.h"
#import "ProductObject.h"

@implementation CustomProductView
@synthesize infoBtn;
@synthesize productID;
@synthesize baseVC;
@synthesize productObject;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)commonInit
{
    // do any initialization that's common to both -initWithFrame:
    // and -initWithCoder: in this method
    productObject = [[ProductObject alloc] init];
    
    UIImage *cameraImage = [UIImage imageNamed:@"cameraIcon"];
    infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.frame.size.height - 25, cameraImage.size.width/1.5, cameraImage.size.height/1.5)];
    [infoBtn setImage:cameraImage forState:UIControlStateNormal];
    [infoBtn addTarget:self action:@selector(infoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:infoBtn];
}

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
//        [self commonInit];
    }
    return self;
}
-(void)infoBtnAction:(UIButton*)sender{
    [baseVC showVideoPopupWithStyle:CNPPopupStyleCentered withSender:sender];
}
@end
