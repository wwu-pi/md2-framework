// static: Events
//
//  ComboboxSelectionChangedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ComboboxSelectionChangedEvent.h"

@implementation ComboboxSelectionChangedEvent

@synthesize identifier, selection;

+(id) eventWithIdentifier: (NSString *) identifier selection: (id) selection
{
    ComboboxSelectionChangedEvent *event = [[ComboboxSelectionChangedEvent alloc] init];
    event.identifier = identifier;
    event.selection = selection;
    return event;
}

@end