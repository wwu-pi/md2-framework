// static: ContentProviders
//
//  ContentProvider.m
//  TariffCalculator
//
//  Created by Uni Münster on 03.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ContentProvider.h"
#import "DatabaseAccess.h"
#import "Utilities.h"
#import "Filter.h"
#import "DataTransferObject.h"

@implementation ContentProvider

static NSString *separator = @".";

@synthesize dataObjectName;

#pragma mark Initialization Methods

-(id) init
{
	self = [super init];
	if (self)
    {
        isLocal = YES;
        remoteURL = [NSURL URLWithString: @""];
        filter = [[Filter alloc] init];
        linkedContentProviders = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark Data Object Accessor Methods

-(void) addLinkedContentProvider: (ContentProvider *) contentProvider forKey: (NSString *) key
{
    [linkedContentProviders setValue: contentProvider forKey: key];
}

-(NSManagedObject *) getDataObject
{
    return currentDataObject;
}

-(id) getDataObjectValueForKey: (NSString *) key
{
    if (key != nil)
    {
        if ([key rangeOfString: separator].length != 0)
        {
            NSArray *pathElements = [key componentsSeparatedByString: separator];
            if ([linkedContentProviders valueForKey: [pathElements objectAtIndex: 0]] != nil)
                return [[linkedContentProviders valueForKey: [pathElements objectAtIndex: 0]] getDataObjectValueForKey: [[pathElements subarrayWithRange: NSMakeRange(1, pathElements.count - 1)] componentsJoinedByString: @""]];
            return [[self getLastRelationshipObjectForPathElements: pathElements] valueForKey: [pathElements objectAtIndex: (pathElements.count - 1)]];
        }
        if (currentDataObject != nil)
        {
            if ( [currentDataObject.entity relationshipsByName].count > 0 && [[currentDataObject.entity relationshipsByName] objectForKey: key] != nil)
            {
                NSMutableSet *set = [currentDataObject mutableSetValueForKey: key];
                return set;
            }
            if ([currentDataObject containsAttributeForKey: key])
                return [currentDataObject valueForKey: key];
        }
    }
    return nil;
}

-(void) setDataObjectValue: (id) value forKey: (NSString *) key
{
    if (key != nil && value != nil)
    {
        if (isDebug)
            NSLog(@"key=%@, value=%@", key, value);
        if ([key rangeOfString: separator].length != 0)
        {
            NSArray *pathElements = [key componentsSeparatedByString: separator];
            if ([linkedContentProviders valueForKey: [pathElements objectAtIndex: 0]] != nil)
                [[linkedContentProviders valueForKey: [pathElements objectAtIndex: 0]] setDataObjectValue: value forKey: [[pathElements subarrayWithRange: NSMakeRange(1, pathElements.count - 1)] componentsJoinedByString: @""]];
            id object = [self getLastRelationshipObjectForPathElements: pathElements];
            [object setValue: value forKey: [pathElements objectAtIndex: (pathElements.count - 1)]];
        }
        
        if (currentDataObject != nil && [currentDataObject containsAttributeForKey: key])
        {
            if ([[currentDataObject.entity relationshipsByName] objectForKey: key] != nil)
                [[currentDataObject.entity relationshipsByName] setValue: value forKey: key];
            else
                [currentDataObject setValue: value forKey: key];
        }
        
        //        [self persistDataObject];
    }
}

#pragma mark Data Object Read Methods

-(void) fetchDataObject
{
    if (isLoadAllowed)
    {
        if (isLocal)
            [self fetchLocalDataObject];
        else
            [self fetchRemoteDataObject];
    }
}

-(void) fetchLocalDataObject
{
    LocalReadRequest *request = [[LocalReadRequest alloc] initWithDataObjectName: dataObjectName filter: filter dataObjectIdentifier: [self getCurrentObjectId]];
    [request execute];
    
    if (request.dataObject != nil && request.dataObjects != nil)
    {
        currentDataObject = request.dataObject;
        currentDataObjects = request.dataObjects;
    }
}

-(void) fetchRemoteDataObject
{
    RemoteReadRequest *request =[[RemoteReadRequest alloc] initWithRemoteURL: remoteURL dataObjectName: dataObjectName filter: filter];
    [request execute];
    
    if (request.dataObject != nil && request.dataObjects != nil)
    {
        currentDataObject = request.dataObject;
        currentDataObjects = request.dataObjects;
    }
}

#pragma mark Data Object Update Methods

-(void) persistDataObject
{
    if (isSaveAllowed)
    {
        if (isLocal)
            [self persistLocalDataObject];
        else
            [self persistRemoteDataObject];
    }
}

-(void) persistLocalDataObject
{
    if (currentDataObject != nil)
    {
        [[[LocalUpdateRequest alloc] initWithDataObjectName: dataObjectName dataObject: currentDataObject] execute];
        [self saveCurrentObjectId];
    }
}

-(void) persistRemoteDataObject
{
    if (currentDataObject != nil)
        [[[RemoteUpdateRequest alloc] initWithRemoteURL: remoteURL dataObjectName: dataObjectName dataObjects: currentDataObjects] execute];
}

#pragma mark Data Object Deletion Methods

-(void) removeDataObject
{
    if (isLocal)
        [self removeLocalDataObject];
    else
        [self removeRemoteDataObject];
}

-(void) removeLocalDataObject
{
    if (currentDataObject != nil)
    {
        [[[LocalDeleteRequest alloc] initWithDataObject: currentDataObject] execute];
        [self persistDataObject];
    }
}

-(void) removeRemoteDataObject
{
    if (currentDataObject != nil)
    {
        [[[RemoteDeleteRequest alloc] initWithRemoteURL: remoteURL dataObjectName: dataObjectName dataObject: currentDataObject] execute];
        [self persistDataObject];
    }
}

#pragma mark Data Object Creation Methods

-(void) createNewDataObject
{
    if (isLocal)
        [self createLocalNewDataObject];
    else
        [self createRemoteNewDataObject];
}

-(void) createLocalNewDataObject
{
    LocalCreateRequest *request = [[LocalCreateRequest alloc] initWithDataObjectName: dataObjectName];
    [request execute];
    currentDataObject = request.dataObject;
}

-(void) createRemoteNewDataObject
{
    RemoteCreateRequest *request = [[RemoteCreateRequest alloc] initWithRemoteURL: remoteURL dataObjectName: dataObjectName dataObject: currentDataObject];
    [request execute];
    currentDataObject = request.dataObject;
}

#pragma mark Helper Methods

-(NSNumber *) getCurrentObjectId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: [NSString stringWithFormat: @"%@%@", dataObjectName, NSStringFromClass([self class])]];
}

-(void) saveCurrentObjectId
{
    [[NSUserDefaults standardUserDefaults] setObject: ((DataTransferObject *) currentDataObject).identifier forKey: [NSString stringWithFormat: @"%@%@", dataObjectName, NSStringFromClass([self class])]];
}

-(id) getLastRelationshipObjectForPathElements: (NSArray *) pathElements
{
    id object = currentDataObject;
    id reference = nil;
    for (NSString *element in pathElements)
    {
        if ([pathElements indexOfObject: element] <= (pathElements.count - 2))
        {
            NSString *relationshipName = ((NSRelationshipDescription *) [[[object entity] relationshipsByName] objectForKey: element]).name;
            reference = [object valueForKey: relationshipName];
            object = reference;
        }
        else
            break;
    }
    return object;
}

@end