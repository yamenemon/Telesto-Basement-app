//
//  CustomProductView.m
//  Telesto Basement App
//
//  Created by CSM on 3/13/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import "CustomProductView.h"

@implementation CustomProductView
@synthesize cameraBtn;
@synthesize centerFrame;
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
    UIImage *cameraImage = [UIImage imageNamed:@"cameraIcon"];

    centerFrame = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/4, self.frame.size.height/4, cameraImage.size.width, cameraImage.size.height)];
    [self addSubview:centerFrame];
    centerFrame.backgroundColor = [UIColor clearColor];
    cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cameraImage.size.width, cameraImage.size.height)];
    [cameraBtn setImage:cameraImage forState:UIControlStateNormal];
    [centerFrame addSubview:cameraBtn];
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
@end
