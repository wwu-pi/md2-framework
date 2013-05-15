// static: Events
//
//  EventBindingEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EventBindingEvent.h"

@implementation EventBindingEvent

@synthesize eventActionMapping, viewEvent, action;

+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping action: (Action *) action
{
    EventBindingEvent *event = [EventBindingEvent alloc];
    event.eventActionMapping = eventActionMapping;
    event.action = action;
    return event;
}

+(id) eventWithMapping: (NSMutableDictionary *) eventActionMapping viewEvent: (ViewEvent *) viewEvent action: (Action *) action
{
    EventBindingEvent *event = [EventBindingEvent alloc];
    event.eventActionMapping = eventActionMapping;
    event.viewEvent = viewEvent;
    event.action = action;
    return event;
}

@end