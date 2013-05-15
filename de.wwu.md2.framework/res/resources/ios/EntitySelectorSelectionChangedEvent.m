// static: Events
//
//  EntitySelectorSelectionChangedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 28.08.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "EntitySelectorSelectionChangedEvent.h"

@implementation EntitySelectorSelectionChangedEvent

@synthesize identifier, selection;

+(id) eventWithIdentifier: (NSString *) identifier selection: (id) selection
{
    EntitySelectorSelectionChangedEvent *event = [[EntitySelectorSelectionChangedEvent alloc] init];
    event.identifier = identifier;
    event.selection = selection;
    return event;
}

@end