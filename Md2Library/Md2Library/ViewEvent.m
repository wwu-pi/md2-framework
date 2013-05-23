// static: Events
//
//  ViewEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ViewEvent.h"

@implementation ViewEvent

@synthesize identifier, eventType;

+(id) eventWithIdentifier: (NSString *) identifier eventType: (EventType) eventType
{
    ViewEvent *event = [[ViewEvent alloc] init];
    event.identifier = identifier;
    event.eventType = eventType;
    return event;
}

@end