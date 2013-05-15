// static: Events
//
//  RegisterMappingEvent.h
//  TariffCalculator
//
//	Stores all information needed to register a mapping.
//
//  Created by Uni Muenster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "Controller.h"

@interface RegisterMappingEvent : Event
{
    DataMapper *dataMapper;
    ContentProvider *contentProvider;
    NSString *dataKey;
    NSString *identifier;
}

@property (retain, nonatomic) DataMapper *dataMapper;
@property (retain, nonatomic) ContentProvider *contentProvider;
@property (retain, nonatomic) NSString *dataKey;
@property (retain, nonatomic) NSString *identifier;

+(id) eventWithDataMapper: (DataMapper *) dataMapper contentProvider: (ContentProvider *) contentProvider dataKey: (NSString *) dataKey identifier: (NSString *) identifier;

@end