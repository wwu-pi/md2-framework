// static: Requests
//
//  RemoteReadRequest.h
//  TariffCalculator
//
//	The RemoteReadRequest encapsulates the POST-method for objects on a remote server.
//
//  Created by Uni Muenster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"
@class Filter;

@interface RemoteReadRequest : Request
{
    Filter *filter;
    NSMutableArray *dataObjects;
}

@property (retain, nonatomic) NSMutableArray *dataObjects;

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName filter: (Filter *) filt;

@end