// static: Requests
//
//  LocalUpdateRequest.m
//  TariffCalculator
//
//  Created by Uni Münster on 05.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LocalUpdateRequest.h"
#import "DatabaseAccess.h"

@implementation LocalUpdateRequest

-(id) initWithDataObjectName: (NSString *) dataObjName dataObject: (NSManagedObject *) dataObj
{
    self = [super init];
    if (self)
    {
        dataObjectName = dataObjName;
        dataObject = dataObj;
    }
    return self;
}

-(void) execute
{
    NSError *error;
    if (![[DatabaseAccess context] save: &error])
        [DatabaseAccess printDetailedErrorDescription];
}

@end