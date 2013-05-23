// static: Events
//
//  RegisterMappingEvent.m
//  TariffCalculator
//
//	Stores all information needed to register a mapping.
//
//  Created by Uni Muenster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "RegisterMappingEvent.h"

@implementation RegisterMappingEvent

/*
*	Implementation of the getter and setter of the instance attributes.
*/
@synthesize dataMapper, contentProvider, dataKey, identifier;

/*
*	Creates a RegisterMappingEvent with the given data mapper, content provider, data key and identifier.
*/
+(id) eventWithDataMapper: (DataMapper *) dataMapper contentProvider: (ContentProvider *) contentProvider dataKey: (NSString *) dataKey identifier: (NSString *) identifier
{
    RegisterMappingEvent *event = [[RegisterMappingEvent alloc] init];
    event.dataMapper = dataMapper;
    event.contentProvider = contentProvider;
    event.dataKey = dataKey;
    event.identifier = identifier;
    return event;
}

@end