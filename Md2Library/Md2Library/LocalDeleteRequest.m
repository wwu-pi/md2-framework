// static: Requests
//
//  LocalDeleteRequest.m
//  TariffCalculator
//
//  Created by Uni Münster on 06.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "LocalDeleteRequest.h"
#import "DatabaseAccess.h"

@implementation LocalDeleteRequest

-(id) initWithDataObject: (NSManagedObject *) dataObj
{
    self = [super init];
    if (self)
        dataObject = dataObj;
    return self;
}

-(void) execute
{
    [[DatabaseAccess context] deleteObject: dataObject];
}

@end