// static: Requests
//
//  LocalDeleteRequest.h
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"

@interface LocalDeleteRequest : Request

-(id) initWithDataObject: (NSManagedObject *) dataObj;

@end