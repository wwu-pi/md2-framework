// static: Events
//
//  UnregisterMappingEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"

@interface UnregisterMappingEvent : Event
{
    DataMapper * dataMapper;
    NSString *identifier;
}

@property (retain, nonatomic) DataMapper *dataMapper;
@property (retain, nonatomic) NSString *identifier;

+(id) eventWithDataMapper: (DataMapper *) dataMapper identifier: (NSString *) identifier;

@end