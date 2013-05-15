// static: Requests
//
//  LocalNewRequest.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LocalCreateRequest.h"
#import "DatabaseAccess.h"
#import "DataTransferObject.h"

@implementation LocalCreateRequest

/*
 *	Counter for the created data objects.
 */
static int OBJECT_IDENTIFIER_COUNTER = 0;

@synthesize currentDataObjectID;

/*
 *	Initializes the LocalFetchRequest with a given data object name.
 */
-(id) initWithDataObjectName: (NSString *) dataObjName
{
    self = [super init];
    if (self)
    {
        if (OBJECT_IDENTIFIER_COUNTER == 0)
            OBJECT_IDENTIFIER_COUNTER = ((NSNumber *) [[NSUserDefaults standardUserDefaults]  objectForKey: @"objectIdentifier"]).intValue;
        
        dataObjectName = dataObjName;
    }
    return self;
}

-(void) execute
{
    NSEntityDescription *entity = [NSEntityDescription entityForName: dataObjectName inManagedObjectContext: [DatabaseAccess context]];
    dataObject = [[NSManagedObject alloc] initWithEntity: entity insertIntoManagedObjectContext: [DatabaseAccess context]];
    ((DataTransferObject *) dataObject).identifier = [NSNumber numberWithInt: OBJECT_IDENTIFIER_COUNTER++];
    ((DataTransferObject *) dataObject).createdDate = [NSDate date];
    
    NSDictionary *relationships = [[dataObject entity] relationshipsByName];
    if (relationships.count > 0)
    {
        for (NSString *relationshipName in relationships.keyEnumerator)
        {
            NSRelationshipDescription *relation = ((NSRelationshipDescription *) [relationships objectForKey: relationshipName]);
            NSEntityDescription *linkedEntity = [NSEntityDescription entityForName: relation.destinationEntity.name inManagedObjectContext: [DatabaseAccess context]];
            NSManagedObject *object = [[NSManagedObject alloc] initWithEntity: linkedEntity insertIntoManagedObjectContext: [DatabaseAccess context]];
            
            if (relation.isToMany)
            {
                NSMutableSet *objects = [[NSMutableSet alloc] init];
                [objects addObject: object];
                [dataObject setValue: objects forKey: relationshipName];
            }
            else
                [dataObject setValue: object forKey: relationshipName];
        }
    }
    currentDataObjectID = dataObject.objectID;
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt: OBJECT_IDENTIFIER_COUNTER] forKey: @"objectIdentifier"];
    
    if (isDebug)
    {
        NSLog(@"dataObject=%@", dataObject);
        NSLog(@"currentIdentifier=%@", currentDataObjectID);
    }
}

@end