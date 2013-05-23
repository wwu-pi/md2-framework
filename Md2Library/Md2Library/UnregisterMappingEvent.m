// static: Events
//
//  UnregisterMappingEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "UnregisterMappingEvent.h"

@implementation UnregisterMappingEvent

@synthesize dataMapper, identifier;

+(id) eventWithDataMapper: (DataMapper *) dataMapper identifier: (NSString *) identifier
{
    UnregisterMappingEvent *event = [[UnregisterMappingEvent alloc] init];
    event.dataMapper = dataMapper;
    event.identifier = identifier;
    return event;
}

@end