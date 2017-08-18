//
//  AppDelegate.h
//  Telesto Basement App
//
//  Created by Emon on 11/13/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Utility.h"

@class SWRevealViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) NSString *deviceTokenString;
@property (strong,nonatomic) NSMutableArray *sharedProductArray;
-(NSString*)deviceToken;
- (void)saveContext;


@end

