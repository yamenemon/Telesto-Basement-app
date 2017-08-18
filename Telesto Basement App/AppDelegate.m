//
//  AppDelegate.m
//  Telesto Basement App
//
//  Created by Emon on 11/13/16.
//  Copyright © 2016 csm. All rights reserved.
//

#import "AppDelegate.h"
#import "MTReachabilityManager.h"
#import "SWRevealViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize sharedProductArray;
//- (void)setOldCookieForAutoLogin {
//    NSData* cookieDictionary = [[NSUserDefaults standardUserDefaults] valueForKey:DOMAIN_NAME];
//    if(cookieDictionary) {
//        [CommonMethods restoreCookie];
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.deviceTokenString = @"";
    
    [MTReachabilityManager sharedManager];
    sharedProductArray = [[NSMutableArray alloc] init];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:51/255.f
                                                                  green:46/255.f
                                                                   blue:113/255.f
                                                                  alpha:1]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    //register for push notification
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // already calling from applicationDidBecomeActive
    // [self setOldCookieForAutoLogin];
    
    
    //reset old notes
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *oldNoteSettings = [defaults objectForKey:@"NoteSettings"];
    if(oldNoteSettings) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"NoteSettings"];
    }
    if ([Utility isLoggedIn] == YES) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SWRevealViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        self.window.rootViewController = vc;
        [self.window makeKeyAndVisible];
    }
    else{
        [Utility showBaseViewController];
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    NSLog(@"My token is: %@", deviceToken);
    NSString *tokenAsString = [[[[deviceToken description]
                                 stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
    self.deviceTokenString = tokenAsString;
}


-(NSString*)deviceToken {
    return self.deviceTokenString;
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive) {
        NSString *alertString;
        
        @try {
            NSDictionary *notificationDict = [userInfo objectForKey:@"aps"];
            alertString = [[notificationDict objectForKey:@"alert"] objectForKey:@"body"];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            alertString = @"New notification received.";
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JupiterNotification"
                                                            object:self];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification"
                                                                                 message:alertString
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
        
        [alertController addAction:actionOk];
        [self.window.rootViewController presentViewController:alertController
                                                     animated:YES
                                                   completion:nil];
        
//        [self resetUnreadMessageCount];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self resetUnreadMessageCount];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];

}


//-(void)resetUnreadMessageCount {
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    
//    if(![CommonMethods iSUserLoggedIn]) {
//        [self setOldCookieForAutoLogin];
//    }
//    
//    if([CommonMethods iSUserLoggedIn]) {
//        NSString *url = [NSString stringWithFormat:@"https://jupiter.centralstationmarketing.com/api/ios/UnreadMessageReset.php?devicetoken=%@", [self deviceToken]];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setHTTPMethod:@"GET"];
//        [request setURL:[NSURL URLWithString:url]];
//        
//        NSError *error = [[NSError alloc] init];
//        NSHTTPURLResponse *responseCode = nil;
//        
//        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request
//                                                      returningResponse:&responseCode
//                                                                  error:&error];
//        if([responseCode statusCode] != 200){
//            NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
//        }
//    }
// }

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Telesto_Basement_App"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
