// static: Events
//
//  GPSUpdateEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GPSUpdateEvent.h"

@implementation GPSUpdateEvent

@synthesize bindings;

+(id) eventWithBindings: (NSArray *) bindings
{
    GPSUpdateEvent *event = [[GPSUpdateEvent alloc] init];
    event.bindings = bindings;
    return event;
}

@end