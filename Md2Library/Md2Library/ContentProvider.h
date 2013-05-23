// static: ContentProviders
//
//  ContentProvider.h
//  TariffCalculator
//
//  Created by Uni Münster on 03.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "LocalDeleteRequest.h"
#import "LocalCreateRequest.h"
#import "LocalReadRequest.h"
#import "LocalUpdateRequest.h"
#import "RemoteDeleteRequest.h"
#import "RemoteCreateRequest.h"
#import "RemoteReadRequest.h"
#import "RemoteUpdateRequest.h"
@class Filter;

@interface ContentProvider : NSObject
{
    BOOL isLocal;
    BOOL isCacheEnabled;
    BOOL isLoadAllowed;
    BOOL isSaveAllowed;
    
    NSString *dataObjectName;
    Filter *filter;
    NSURL *remoteURL;
    
    NSManagedObject *currentDataObject;
    NSArray *currentDataObjects;
    
    NSMutableDictionary *linkedContentProviders;
}

@property (readonly, nonatomic) NSString *dataObjectName;

-(void) addLinkedContentProvider: (ContentProvider *) contentProvider forKey: (NSString *) key;

-(NSManagedObject *) getDataObject;
-(id) getDataObjectValueForKey: (NSString *) key;
-(void) setDataObjectValue: (id) value forKey: (NSString *) key;

-(void) fetchDataObject;
-(void) persistDataObject;
-(void) removeDataObject;
-(void) createNewDataObject;

@end