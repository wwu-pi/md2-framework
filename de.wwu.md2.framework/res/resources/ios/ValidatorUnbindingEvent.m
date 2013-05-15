// static: Events
//
//  ValidatorUnbindingEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 26.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "ValidatorUnbindingEvent.h"

@implementation ValidatorUnbindingEvent

@synthesize controller, validator, identifier;

+(id) eventWithController: (Controller *) controller validator: (Validator *) validator identifier: (NSString *) identifier
{
    ValidatorUnbindingEvent *event = [[ValidatorUnbindingEvent alloc] init];
    event.controller = controller;
    event.validator = validator;
    event.identifier = identifier;
    return event;
}

@end