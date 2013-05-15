// static: Events
//
//  ValidatorBindingEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 24.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ValidatorBindingEvent.h"

@implementation ValidatorBindingEvent

@synthesize controller, validator, identifier;

+(id) eventWithController: (Controller *) controller validator: (Validator *) validator identifier: (NSString *) identifier
{
    ValidatorBindingEvent *event = [[ValidatorBindingEvent alloc] init];
    event.controller = controller;
    event.validator = validator;
    event.identifier = identifier;
    return event;
}

@end