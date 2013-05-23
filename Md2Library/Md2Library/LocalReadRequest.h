// static: Requests
//
//  LocalReadRequest.h
//  TariffCalculator
//
//	The LocalReadRequest encapsulates the local reading of data objects.
//
//  Created by Uni Muenster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Request.h"
//#import "Filter.h"
@class Filter;

@interface LocalReadRequest : Request
{
    NSNumber *dataObjectIdentifier;
    Filter *filter;
    
    NSMutableArray *dataObjects;
    NSFetchRequest *fetchRequest;
}

@property (retain, nonatomic) NSNumber *dataObjectIdentifier;
@property (retain, nonatomic) NSMutableArray *dataObjects;
@property (retain, nonatomic) Filter *filter;

-(id) initWithDataObjectName: (NSString *) dataObjName filter: (Filter *) filter dataObjectIdentifier: (NSNumber *) dataObjectIdentifier;

@end