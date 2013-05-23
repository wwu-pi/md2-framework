// static: Events
//
//  WriteCheckboxValueEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteCheckboxValueEvent.h"

@implementation WriteCheckboxValueEvent

@synthesize switchValueChangedEvent, controller;

+(id) eventWithEvent: (SwitchValueChangedEvent *) switchValueChangedEvent controller: (Controller *) controller
{
    WriteCheckboxValueEvent *event = [[WriteCheckboxValueEvent alloc] init];
    event.switchValueChangedEvent = switchValueChangedEvent;
    event.controller = controller;
    return event;
}

@end