// static: Requests
//
//  RemoteNewRequest.h
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"

@interface RemoteCreateRequest : Request

-(id) initWithRemoteURL: (NSURL *) remoteUrl dataObjectName: (NSString *) dataObjName dataObject: (NSManagedObject *) dataObj;

@end