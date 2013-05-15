// static: Utility
//
//  DatabaseAccess.h
//  TariffCalculator
//
//	The DatabaseAccess encapsulates the access to the database and the appropriate variables.
//
//  Created by Uni Muenster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface DatabaseAccess : NSObject
{
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

+(NSManagedObjectContext *) context;
+(NSManagedObjectModel *) model;
+(NSPersistentStoreCoordinator *) coordinator;
+(void) printDetailedErrorDescription;

@end