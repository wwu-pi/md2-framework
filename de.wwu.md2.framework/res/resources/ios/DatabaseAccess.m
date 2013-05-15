// static: Utility
//
//  DatabaseAccess.m
//  TariffCalculator
//
//	The DatabaseAccess encapsulates the access to the database and the appropriate variables.
//
//  Created by Uni Muenster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DatabaseAccess.h"

@implementation DatabaseAccess

/*
*	Singleton instance of the database access.
*/
static DatabaseAccess *instance;

#pragma mark Initialization Methods

/*
*	Returns the singleton instance.
*/
+(id) instance
{
	@synchronized([DatabaseAccess class])
	{
		if (!instance)
			instance = [[self alloc] init];
		return instance;
	}
	return nil;
}

/*
*	Allocation of the singleton instance.
*/
+(id) alloc
{
	@synchronized([DatabaseAccess class])
	{
		NSAssert(instance == nil, @"Attempted to allocate a second instance of a singleton.");
		instance = [super alloc];
		return instance;
	}
	return nil;
}

#pragma mark CoreData Accessor Methods

/*
*	Returns the managed object context of the singleton instance.
*/
+(NSManagedObjectContext *) context
{
    return [[DatabaseAccess instance] managedObjectContext];
}

/*
*	Returns the managed object model of the singleton instance.
*/
+(NSManagedObjectModel *) model
{
    return [[DatabaseAccess instance] managedObjectModel];
}

/*
*	Returns the persistent store coordinator of the singleton instance.
*/
+(NSPersistentStoreCoordinator *) coordinator
{
    return [[DatabaseAccess instance] persistentStoreCoordinator];
}

/*
*	Prints the current error message that occurred in the database.
*/
+(void) printDetailedErrorDescription
{
    return [[DatabaseAccess instance] printDetailedErrorDescription];
}

#pragma mark CoreData Methods

/*
*	Saves the managed object context.
*/
-(void) saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *_managedObjectContext = self.managedObjectContext;
    if (_managedObjectContext != nil)
    {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save: &error])
        {
            if (isDebug)
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

/*
*	Returns the managed object context.
*/
-(NSManagedObjectContext *) managedObjectContext
{
    if (managedObjectContext != nil)
        return managedObjectContext;
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}

/*
*	Returns the managed object model.
*/
-(NSManagedObjectModel *) managedObjectModel
{
    if (managedObjectModel != nil)
        return managedObjectModel;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource: @"DataModel" withExtension: @"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL: modelURL];
    return managedObjectModel;
}

/*
*	Returns the persistent store coordinator.
*/
-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
        return persistentStoreCoordinator;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: @"DataModel.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: storeURL options: nil error: &error])
    {
        if (isDebug)
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return persistentStoreCoordinator;
}

#pragma mark Error Methods

/*
*	Prints the current error description in detail.
*/
-(void) printDetailedErrorDescription
{
    if (isDebug)
    {
        do
        {
            NSError* error;
            if(![[self managedObjectContext] save: &error])
            {
                NSLog(@"An error has occured during database access: %@", [error localizedDescription]);
                NSArray* detailedErrors = [[error userInfo] objectForKey: NSDetailedErrorsKey];
                if(detailedErrors != nil && [detailedErrors count] > 0)
                    for(NSError* detailedError in detailedErrors)
                        NSLog(@"Detailed error: %@", [detailedError userInfo]);
                else
                    NSLog(@"%@", [error userInfo]);
            }
        }
        while(0);
    }
}

#pragma mark Directory Methods

/*
*	Returns the documents directory of the operating system.
*/
-(NSURL *) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains: NSUserDomainMask] lastObject];
}

@end