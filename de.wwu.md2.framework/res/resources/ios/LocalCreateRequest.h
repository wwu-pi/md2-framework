// static: Requests
//
//  LocalNewRequest.h
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"

@interface LocalCreateRequest : Request
{
    NSManagedObjectID *currentDataObjectID;
}
    
@property (retain, nonatomic) NSManagedObjectID *currentDataObjectID;

-(id) initWithDataObjectName: (NSString *) dataObjName;

@end