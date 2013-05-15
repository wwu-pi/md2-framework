// static: Requests
//
//  RemoteNewRequest.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoteCreateRequest.h"
#import "LocalCreateRequest.h"
#import "Utilities.h"

@implementation RemoteCreateRequest

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName dataObject: (NSManagedObject *) dataObj
{
    self = [super init];
    if (self)
    {
        remoteURL = remoteUrl;
        dataObjectName = dataObjName;
        dataObject = dataObj;
    }
    return self;
}

-(void) execute
{
    NSError *error = nil;
    NSURL *resourceURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@/", remoteURL.description, [self getDataObjectPath]]];
    
    LocalCreateRequest *createRequest = [[LocalCreateRequest alloc] initWithDataObjectName: dataObjectName];
    [createRequest execute];
    dataObject = createRequest.dataObject;
    
    NSDictionary *dataObjectDictionary = [dataObject getDictionary];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject: dataObjectDictionary];
    [dictionary setValue: dataObjectDictionary forKey: [self getDataObjectPath]];
    
    if ([NSJSONSerialization isValidJSONObject: dictionary])
    {
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
}

@end