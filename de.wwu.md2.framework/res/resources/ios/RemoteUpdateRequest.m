// static: Requests
//
//  RemoteUpdateRequest.m
//  TariffCalculator
//
//	The RemoteUpdateRequest encapsulates the PUT-method for objects on a remote server.
//
//  Created by Uni Muenster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoteUpdateRequest.h"
#import "Utilities.h"

@implementation RemoteUpdateRequest

@synthesize dataObjects;

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName dataObjects: (NSArray *) dataObjs
{
    self = [super init];
    if (self)
    {
        remoteURL = remoteUrl;
        dataObjectName = dataObjName;
        dataObjects = [NSMutableArray arrayWithArray: dataObjs];
    }
    return self;
}

/*
 *	Executes the remote update request.
 */
-(void) execute
{
    NSError *error = nil;
    NSURL *resourceURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@/", remoteURL.description, [self getDataObjectPath]]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSManagedObject *object in dataObjects)
    {
        NSDictionary *dataObjectDictionary = [object getDictionary];
        if ([NSJSONSerialization isValidJSONObject: dataObjectDictionary])
            [array addObject: dataObjectDictionary];
    }
    if (array.count > 1)
        [dictionary setValue: array forKey: [self getDataObjectPath]];
    else if (array.count == 1 && [array objectAtIndex: 0] != nil)
        [dictionary setValue: [array objectAtIndex: 0] forKey: [self getDataObjectPath]];
    
    NSData* data = [NSJSONSerialization dataWithJSONObject: dictionary options: NSJSONWritingPrettyPrinted error: &error];
    if (isDebug)
        NSLog(@"jsonStringData=%@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: resourceURL cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    
    [request setHTTPMethod: @"PUT"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Accept"];
    [request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue: [NSString stringWithFormat: @"%d", [data length]] forHTTPHeaderField: @"Content-Length"];
    [request setHTTPBody: data];
    
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    
    if (isDebug)
        NSLog(@"statusCode=%i", response.statusCode);
    if (response.statusCode == 404)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: LocalizedKeyString(@"rem_code_404_title") message: LocalizedKeyString(@"rem_code_404_message") delegate: nil cancelButtonTitle: LocalizedKeyString(@"rem_code_404_button") otherButtonTitles: nil];
        [alert show];
    }
}

@end