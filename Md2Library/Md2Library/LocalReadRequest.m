// static: Requests
//
//  LocalReadRequest.m
//  TariffCalculator
//
//	The LocalReadRequest encapsulates the local fetching of data objects.
//
//  Created by Uni Muenster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Utilities.h"
#import "LocalReadRequest.h"
#import "DatabaseAccess.h"
#import "DataTransferObject.h"
#import "LocalCreateRequest.h"
#import "Filter.h"

@implementation LocalReadRequest

/*
*	Implementation of the getters and setters for the instance attributes.
*/
@synthesize dataObjects, dataObjectIdentifier, filter;

/*
*	Initializes the LocalReadRequest with a given data object name.
 */
-(id) initWithDataObjectName: (NSString *) dataObjName filter: (Filter *) filt dataObjectIdentifier: (NSNumber *) dataObjIdentifier
{
    self = [super init];
    if (self)
    {
        dataObjectName = dataObjName;
        filter = filt;
        dataObjectIdentifier = dataObjIdentifier;
        
        dataObjects = [[NSMutableArray alloc] init];
        fetchRequest = [[NSFetchRequest alloc] init];
    }
    return self;
}

/*
*	Executes the local read request.
*/
-(void) execute
{
    NSEntityDescription *entity = [NSEntityDescription entityForName: dataObjectName inManagedObjectContext: [DatabaseAccess context]];
    if (fetchRequest != nil)
    {
        [fetchRequest setEntity: entity];
        if (filter != nil)
            [fetchRequest setPredicate: [filter getReplacedPredicate]];
    }
    
    NSError *error;
    [dataObjects setArray: [[DatabaseAccess context] executeFetchRequest: fetchRequest error: &error]];
    if (error != nil)
        [DatabaseAccess printDetailedErrorDescription];
    
    // Revert local changes for all fetched objects
    for(NSManagedObject *cur in dataObjects)
        [cur revertLocalChanges];
    
    NSManagedObject *foundObject = nil;
    if (dataObjectIdentifier != nil)
        for (NSManagedObject *fetchedObject in dataObjects)
            if ([((DataTransferObject *) fetchedObject).identifier isEqual: dataObjectIdentifier])
                foundObject = fetchedObject;
    
    if (foundObject != nil)
        dataObject = foundObject;
    else
    {
        LocalCreateRequest *request = [[LocalCreateRequest alloc] initWithDataObjectName: dataObjectName];
        [request execute];
        dataObject = request.dataObject;
    }
    dataObjectIdentifier = ((DataTransferObject *) dataObject).identifier;
    
    if (isDebug)
    {
        NSLog(@"dataObjects=%@", dataObjects);
        NSLog(@"dataObjectIdentifier=%@", dataObjectIdentifier);
    }
}

@end