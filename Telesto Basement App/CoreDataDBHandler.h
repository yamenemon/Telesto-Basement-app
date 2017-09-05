//
//  CoreDataDBHandler.h
//  CoreDataDB
//
//  Created by Farhad on 8/23/13.
//  Copyright (c) 2013 Farhad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataDBHandler : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
+ (id)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
