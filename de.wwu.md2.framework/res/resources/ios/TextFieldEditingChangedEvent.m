// static: Events
//
//  TextFieldEditingChangedEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 04.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "TextFieldEditingChangedEvent.h"

@implementation TextFieldEditingChangedEvent

@synthesize identifier, text;

+(id) eventWithIdentifier: (NSString *) identifier text: (id) text
{
    TextFieldEditingChangedEvent *event = [[TextFieldEditingChangedEvent alloc] init];
    event.identifier = identifier;
    event.text = text;
    return event;
}

@end