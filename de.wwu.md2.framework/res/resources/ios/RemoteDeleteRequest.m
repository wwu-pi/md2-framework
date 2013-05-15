// static: Requests
//
//  RemoteDeleteRequest.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RemoteDeleteRequest.h"

@implementation RemoteDeleteRequest

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
    NSURL *resourceURL = [NSURL URLWithString: [NSString stringWithFormat: @"%@/%@/%@", remoteURL.description, [self getDataObjectPath], [dataObject valueForKey: @"identifier"]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: resourceURL cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 60];
    
    [request setHTTPMethod: @"DEL"];
    
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