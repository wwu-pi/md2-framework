// static: Requests
//
//  RemoteUpdateRequest.h
//  TariffCalculator
//
//	The RemoteUpdateRequest encapsulates the POST-method for objects on a remote server.
//
//  Created by Uni Muenster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"

@interface RemoteUpdateRequest : Request
{
    NSMutableArray *dataObjects;
}

@property (retain, nonatomic) NSMutableArray *dataObjects;

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName dataObjects: (NSArray *) dataObjs;

@end