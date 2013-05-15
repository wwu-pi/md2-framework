// static: Events
//
//  AssignObjectAtContentProviderEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 29.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "AssignObjectAtContentProviderEvent.h"

@implementation AssignObjectAtContentProviderEvent

@synthesize bindings;

+(id) eventWithBindings: (NSDictionary *)bindings
{
    AssignObjectAtContentProviderEvent *event = [[AssignObjectAtContentProviderEvent alloc] init];
    event.bindings = bindings;
    return event;
}

@end