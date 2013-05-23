// static: Events
//
//  WriteCheckboxValueEvent.h
//  TariffCalculator
//
//  Created by Uni Münster on 22.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Event.h"
#import "TextFieldEditingChangedEvent.h"
#import "Controller.h"

@interface WriteCheckboxValueEvent : Event
{
    SwitchValueChangedEvent *switchValueChangedEvent;
    Controller *controller;
}

@property (retain, nonatomic) SwitchValueChangedEvent *switchValueChangedEvent;
@property (retain, nonatomic) Controller *controller;

+(id) eventWithEvent: (SwitchValueChangedEvent *) switchValueChangedEvent controller: (Controller *) controller;

@end