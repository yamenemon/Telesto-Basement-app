//
//  SignatureView.h
//  Telesto Basement App
//
//  Created by CSM on 7/28/17.
//  Copyright © 2017 csm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignatureView : UIView{
    
    UIBezierPath *_path;
}
- (void)erase;

@end
