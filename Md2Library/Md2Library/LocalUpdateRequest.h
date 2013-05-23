// static: Requests
//
//  LocalUpdateRequest.h
//  TariffCalculator
//
//  Created by Uni Münster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"

@interface LocalUpdateRequest : Request

-(id) initWithDataObjectName: (NSString *) dataObjName dataObject: (NSManagedObject *) dataObj;

@end