// static: Events
//
//  EventUnbindingEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 25.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventUnbindingEvent.h"

@implementation EventUnbindingEvent

@synthesize eventActionMapping, viewEvent, action;

+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping action: (Action *) action
{
    EventUnbindingEvent *event = [EventUnbindingEvent alloc];
    event.eventActionMapping = eventActionMapping;
    event.action = action;
    return event;
}

+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping viewEvent: (ViewEvent *) viewEvent
{
    EventUnbindingEvent *event = [EventUnbindingEvent alloc];
    event.eventActionMapping = eventActionMapping;
    event.viewEvent = viewEvent;
    return event;
}

@end