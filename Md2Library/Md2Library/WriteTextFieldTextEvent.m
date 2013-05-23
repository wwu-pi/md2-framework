// static: Events
//
//  WriteTextFieldTextEvent.m
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "WriteTextFieldTextEvent.h"

@implementation WriteTextFieldTextEvent

@synthesize textFieldEditingChangedEvent, controller;

+(id) eventWithEvent: (TextFieldEditingChangedEvent *) textFieldEditingChangedEvent controller: (Controller *) controller
{
    WriteTextFieldTextEvent *event = [[WriteTextFieldTextEvent alloc] init];
    event.textFieldEditingChangedEvent = textFieldEditingChangedEvent;
    event.controller = controller;
    return event;
}

@end