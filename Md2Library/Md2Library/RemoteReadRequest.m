// static: Requests
//
//  RemoteReadRequest.m
//  TariffCalculator
//
//	The RemoteReadRequest encapsulates the GET-method for objects on a remote server.
//
//  Created by Uni Muenster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoteReadRequest.h"
#import "Utilities.h"
#import "LocalReadRequest.h"
#import "LocalCreateRequest.h"
#import "DatabaseAccess.h"
#import "Filter.h"

@implementation RemoteReadRequest

@synthesize dataObjects;

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName filter: (Filter *) filt
{
    self = [super init];
    if (self)
    {
        remoteURL = remoteUrl;
        dataObjectName = dataObjName;
        filter = filt;
        
        dataObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *	Executes the remote read request.
 */
-(void) execute
{
    NSURL *resourceURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@/%@", remoteURL.description, [self getDataObjectPath], [filter getRemotePredicate]]];
    if (isDebug)
        NSLog(@"resourceURL=%@", resourceURL);
    
    NSData* data = [NSData dataWithContentsOfURL: resourceURL];
    NSError* error;
    
    if (data != nil)
    {
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: &error];
        NSDictionary *objectData= [jsonData objectForKey: [self getDataObjectPath]];
        if (isDebug)
            NSLog(@"objectData=%@", objectData);
        
        NSManagedObject *firstObject = nil;
        if ([[objectData class] isSubclassOfClass: [NSArray class]])
        {
            for (id object in objectData.objectEnumerator)
            {
                LocalCreateRequest *createRequest = [[LocalCreateRequest alloc] initWithDataObjectName: dataObjectName];
                [createRequest execute];
                NSManagedObject *managedObject = createRequest.dataObject;
                
                [managedObject setAttributesByJSONData: object];
                [dataObjects addObject: managedObject];
                if (firstObject == nil)
                    firstObject = managedObject;
            }
        }
        else if ([[objectData class] isSubclassOfClass: [NSDictionary class]])
        {
            LocalCreateRequest *createRequest = [[LocalCreateRequest alloc] initWithDataObjectName: dataObjectName];
            [createRequest execute];
            NSManagedObject *managedObject = createRequest.dataObject;
            
            [managedObject setAttributesByJSONData: objectData];
            [dataObjects addObject: managedObject];
            firstObject = managedObject;
        }
        
        dataObject = firstObject;
        if (filter != nil && [filter getReplacedPredicate] != nil)
            [dataObjects filterUsingPredicate: [filter getReplacedPredicate]];
        if (isDebug)
            NSLog(@"dataObject=%@", dataObject);
    }
}

@end